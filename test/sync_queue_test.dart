import 'package:flutter_offline_first_app/domain/conflict_copy.dart';
import 'package:flutter_offline_first_app/domain/sync_task.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.open();
  });

  tearDown(() => env.db.close());

  test('upserts coalesce and a delete replaces them', () async {
    await env.queue.enqueue('insp-1', SyncOp.upsert, 1);
    await env.queue.enqueue('insp-1', SyncOp.upsert, 2);
    expect(await env.queue.pending(), hasLength(1));

    await env.queue.enqueue('insp-1', SyncOp.delete, 3);
    final pending = await env.queue.pending();
    expect(pending, hasLength(1));
    expect(pending.single.op, SyncOp.delete);
    expect(pending.single.enqueuedAt, 3);
  });

  test('pending tasks stay in id order', () async {
    await env.queue.enqueue('a', SyncOp.upsert, 1);
    await env.queue.enqueue('b', SyncOp.upsert, 2);
    final pending = await env.queue.pending();
    expect(pending.map((task) => task.inspectionId), ['a', 'b']);
  });

  test('offline flush does not call the server', () async {
    await env.createPump();
    env.api.reachable = false;

    final report = await env.sync.flush();

    expect(report.offline, isTrue);
    expect(report.message, 'Still offline. Nothing was pushed.');
    expect(env.api.requests, isEmpty);
    expect(await env.queue.pending(), hasLength(1));
  });

  test('simulated offline is treated as offline even if the server is up',
      () async {
    await env.createPump();
    env.gate.simulatedOffline = true;

    final report = await env.sync.flush();

    expect(report.offline, isTrue);
    expect(env.api.requests, isEmpty);
  });

  test('an online flush puts the inspection and clears the queue', () async {
    final created = await env.createPump();

    final report = await env.sync.flush();

    expect(report.message, 'Synced 1 change.');
    expect(env.api.requests.single.method, 'PUT');
    expect(env.api.requests.single.path, '/inspections/${created.id}');
    final body = env.api.requests.single.body!;
    expect(body['baseUpdatedAt'], isNull);
    expect(body['inspection'], isA<Map<String, dynamic>>());
    expect(await env.queue.pending(), isEmpty);

    final stored = await env.repository.getById(created.id);
    expect(stored!.pendingSync, isFalse);
    expect(stored.baseUpdatedAt, created.updatedAt);
    expect(stored.conflictFlag, isFalse);

    final remote = await env.api.fetchAll();
    expect(remote.map((item) => item.id), contains(created.id));
  });

  test('a clean edit after sync is not a conflict', () async {
    final created = await env.createPump();
    await env.sync.flush();
    env.api.requests.clear();
    env.clock.advance(const Duration(minutes: 10));
    await env.repository.updateNotes(
      id: created.id,
      notes: 'Pressure steady at the discharge gauge.',
    );

    final report = await env.sync.flush();

    expect(report.conflicts, 0);
    expect(report.message, 'Synced 1 change.');
    final stored = await env.repository.getById(created.id);
    expect(stored!.conflictFlag, isFalse);
    expect(stored.notes, 'Pressure steady at the discharge gauge.');
    expect(
      env.api.readServerRecord(created.id)!.notes,
      'Pressure steady at the discharge gauge.',
    );
  });

  test('a newer server record wins and raises the conflict flag', () async {
    final created = await env.createPump();
    await env.sync.flush();
    final server = env.api.readServerRecord(created.id)!;
    env.api.stageServerRecord(
      server.copyWith(
        notes: 'Night shift already closed this out.',
        updatedAt:
            server.updatedAt + const Duration(minutes: 30).inMilliseconds,
      ),
    );
    env.clock.advance(const Duration(minutes: 5));
    await env.repository
        .updateNotes(id: created.id, notes: 'Still watching the seal.');

    final report = await env.sync.flush();

    expect(report.conflicts, 1);
    expect(report.message, contains('1 conflict'));
    final stored = await env.repository.getById(created.id);
    expect(stored!.notes, 'Night shift already closed this out.');
    expect(stored.conflictFlag, isTrue);
    expect(stored.conflictDetail, serverWonConflictDetail);
    expect(stored.pendingSync, isFalse);
    expect(await env.queue.pending(), isEmpty);
    expect(
      env.api.readServerRecord(created.id)!.notes,
      'Night shift already closed this out.',
    );
  });

  test('a later local edit wins and still raises the conflict flag', () async {
    final created = await env.createPump();
    await env.sync.flush();
    final server = env.api.readServerRecord(created.id)!;
    env.api.stageServerRecord(
      server.copyWith(
        notes: 'Server copy from earlier.',
        updatedAt: server.updatedAt + const Duration(minutes: 2).inMilliseconds,
      ),
    );
    env.clock.advance(const Duration(minutes: 20));
    await env.repository.updateNotes(
      id: created.id,
      notes: 'Local reading taken after the server edit.',
    );

    final report = await env.sync.flush();

    expect(report.conflicts, 1);
    final stored = await env.repository.getById(created.id);
    expect(stored!.notes, 'Local reading taken after the server edit.');
    expect(stored.conflictFlag, isTrue);
    expect(stored.conflictDetail, localWonConflictDetail);
    expect(
      env.api.readServerRecord(created.id)!.notes,
      'Local reading taken after the server edit.',
    );
  });

  test('equal timestamps let the pushing device win', () async {
    final created = await env.createPump();
    await env.sync.flush();
    final server = env.api.readServerRecord(created.id)!;
    final tie = server.updatedAt + const Duration(minutes: 5).inMilliseconds;
    env.api.stageServerRecord(
      server.copyWith(notes: 'Same clock, other writer.', updatedAt: tie),
    );
    env.clock.millis = tie;
    await env.repository
        .updateNotes(id: created.id, notes: 'Same clock, this device.');

    await env.sync.flush();

    final stored = await env.repository.getById(created.id);
    expect(stored!.notes, 'Same clock, this device.');
    expect(stored.conflictFlag, isTrue);
  });

  test('a failed push stays queued and the next flush retries it', () async {
    final created = await env.createPump();
    env.api.failuresRemaining = 1;

    final failed = await env.sync.flush();
    expect(failed.failed, 1);
    expect(
        failed.message, 'Sync failed for 1 inspection. It stays in the queue.');
    expect((await env.queue.pending()).single.attempts, 1);
    expect(
      (await env.repository.getById(created.id))!.syncError,
      'fake server failed the request',
    );
    expect(env.api.readServerRecord(created.id), isNull);

    final retried = await env.sync.flush();
    expect(retried.pushed, 1);
    expect(await env.queue.pending(), isEmpty);
    expect((await env.repository.getById(created.id))!.syncError, isNull);
  });

  test('one failed inspection does not block the next queued inspection',
      () async {
    final first = await env.createPump(siteName: 'First pad');
    env.clock.advance(const Duration(seconds: 1));
    await env.createPump(siteName: 'Second pad');
    env.api.failuresRemaining = 1;

    final report = await env.sync.flush();

    expect(report.failed, 1);
    expect(report.pushed, 1);
    final pending = await env.queue.pending();
    expect(pending, hasLength(1));
    expect(pending.single.inspectionId, first.id);
    expect(env.api.readServerRecord(first.id), isNull);
  });

  test('delete uses DELETE and a newer server record is restored', () async {
    final created = await env.createPump();
    await env.sync.flush();
    final server = env.api.readServerRecord(created.id)!;
    env.api.stageServerRecord(
      server.copyWith(
        notes: 'Kept by the server.',
        updatedAt: server.updatedAt + const Duration(hours: 2).inMilliseconds,
      ),
    );
    env.clock.advance(const Duration(minutes: 5));
    await env.repository.deleteInspection(created.id);

    await env.sync.flush();

    expect(env.api.requests.last.method, 'DELETE');
    final stored = await env.repository.getById(created.id);
    expect(stored, isNotNull);
    expect(stored!.deleted, isFalse);
    expect(stored.notes, 'Kept by the server.');
    expect(stored.conflictFlag, isTrue);
  });

  test('a later delete removes the server record', () async {
    final created = await env.createPump();
    await env.sync.flush();
    final server = env.api.readServerRecord(created.id)!;
    env.api.stageServerRecord(
      server.copyWith(
        updatedAt: server.updatedAt + const Duration(minutes: 1).inMilliseconds,
      ),
    );
    env.clock.advance(const Duration(minutes: 10));
    await env.repository.deleteInspection(created.id);

    final report = await env.sync.flush();

    expect(report.conflicts, 1);
    expect(await env.repository.getById(created.id), isNull);
    expect(env.api.readServerRecord(created.id)!.deleted, isTrue);
    expect(await env.api.fetchAll(), isEmpty);
  });
}
