import 'package:flutter_offline_first_app/domain/conflict_copy.dart';
import 'package:flutter_offline_first_app/domain/inspection.dart';
import 'package:flutter_offline_first_app/domain/sync_task.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.open();
  });

  tearDown(() => env.db.close());

  test('create stores the checklist and a single upsert', () async {
    final created = await env.createPump();

    final stored = await env.repository.getById(created.id);
    final queued = await env.queue.pending();

    expect(stored, isNotNull);
    expect(stored!.siteName, 'North Pump House');
    expect(stored.status, InspectionStatus.draft);
    expect(stored.pendingSync, isTrue);
    expect(stored.baseUpdatedAt, isNull);
    expect(stored.items, hasLength(5));
    expect(stored.items.first.label, 'Lockout and tagout confirmed');
    expect(queued, hasLength(1));
    expect(queued.single.op, SyncOp.upsert);
    expect(queued.single.inspectionId, created.id);
  });

  test('a second edit keeps one queue row and moves draft to in progress',
      () async {
    final created = await env.createPump();
    env.clock.advance(const Duration(minutes: 5));

    await env.repository.setItemResult(
      inspectionId: created.id,
      itemId: created.items.first.id,
      result: CheckResult.pass,
    );

    final stored = await env.repository.getById(created.id);
    final queued = await env.queue.pending();
    expect(stored!.status, InspectionStatus.inProgress);
    expect(stored.items.first.result, CheckResult.pass);
    expect(stored.updatedAt, env.clock.millis);
    expect(queued, hasLength(1));
    expect(queued.single.op, SyncOp.upsert);
  });

  test('mark complete waits for every item, then records completed', () async {
    final created = await env.createPump();
    expect(
      await env.repository.markComplete(created.id),
      'Answer every checklist item first',
    );

    for (final item in created.items) {
      env.clock.advance(const Duration(seconds: 1));
      await env.repository.setItemResult(
        inspectionId: created.id,
        itemId: item.id,
        result: CheckResult.pass,
      );
    }

    expect(await env.repository.markComplete(created.id), isNull);
    final stored = await env.repository.getById(created.id);
    expect(stored!.status, InspectionStatus.completed);
  });

  test('soft delete hides the visit and replaces the queued upsert', () async {
    final created = await env.createPump();
    env.clock.advance(const Duration(minutes: 1));
    await env.repository.deleteInspection(created.id);

    expect(await env.repository.getById(created.id), isNull);
    final hidden = await env.repository.getById(
      created.id,
      includeDeleted: true,
    );
    expect(hidden!.deleted, isTrue);
    expect(await env.repository.countActive(), 0);
    final queued = await env.queue.pending();
    expect(queued, hasLength(1));
    expect(queued.single.op, SyncOp.delete);
  });

  test('dismiss clears the conflict flag without queueing', () async {
    final created = await env.createPump();
    await env.queue.markDone((await env.queue.pending()).single.id);
    await env.repository.replaceLocal(
      (await env.repository.getById(created.id))!.copyWith(
        conflictFlag: true,
        conflictDetail: serverWonConflictDetail,
        pendingSync: false,
        baseUpdatedAt: created.updatedAt,
      ),
    );

    await env.repository.dismissConflict(created.id);

    final stored = await env.repository.getById(created.id);
    expect(stored!.conflictFlag, isFalse);
    expect(stored.conflictDetail, isEmpty);
    expect(await env.queue.pending(), isEmpty);
  });

  test('unchanged notes do not enqueue another push', () async {
    final created = await env.createPump();
    await env.repository.updateNotes(id: created.id, notes: '');
    expect(await env.queue.pending(), hasLength(1));
  });

  test('the active list stream follows local writes', () async {
    final created = await env.createPump();
    final emitted = <int>[];
    final subscription = env.repository.watchActive().listen((rows) {
      emitted.add(rows.length);
    });
    await _settle();
    env.clock.advance(const Duration(seconds: 1));
    await env.repository.deleteInspection(created.id);
    await _settle();
    await subscription.cancel();

    expect(emitted.first, 1);
    expect(emitted.last, 0);
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
