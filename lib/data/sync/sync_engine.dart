import '../../core/connectivity.dart';
import '../../domain/sync_task.dart';
import '../remote/inspection_api.dart';
import '../repository/inspection_repository.dart';
import 'sync_queue_store.dart';

class SyncReport {
  const SyncReport({
    required this.offline,
    required this.pushed,
    required this.conflicts,
    required this.failed,
  });

  final bool offline;
  final int pushed;
  final int conflicts;
  final int failed;

  String get message {
    if (offline && pushed == 0 && failed == 0) {
      return 'Still offline. Nothing was pushed.';
    }
    if (offline && pushed > 0) {
      return 'Pushed ${_noun(pushed, 'change')} before the connection dropped.';
    }
    if (failed > 0 && pushed == 0) {
      final pronoun = failed == 1 ? 'It stays' : 'They stay';
      return 'Sync failed for ${_noun(failed, 'inspection')}. $pronoun in the queue.';
    }
    if (failed > 0) {
      return 'Synced ${_noun(pushed, 'change')}. ${_noun(failed, 'inspection')} stayed in the queue.';
    }
    if (pushed == 0) return 'Nothing to push.';
    if (conflicts > 0) {
      return 'Synced ${_noun(pushed, 'change')}, including ${_noun(conflicts, 'conflict')}. Last write wins kept the newer record.';
    }
    return 'Synced ${_noun(pushed, 'change')}.';
  }

  static String _noun(int count, String word) {
    return '$count $word${count == 1 ? '' : 's'}';
  }
}

/// Pushes the local queue when the connectivity gate and the server ping agree
/// the device is online.
class SyncEngine {
  SyncEngine({
    required this.repository,
    required this.queue,
    required this.api,
    required this.connectivity,
  });

  final InspectionRepository repository;
  final SyncQueueStore queue;
  final InspectionApi api;
  final ConnectivityGate connectivity;

  Future<SyncReport>? _inFlight;

  Future<SyncReport> flush() {
    final current = _inFlight;
    if (current != null) return current;
    final run = _flush();
    _inFlight = run;
    return run.whenComplete(() {
      _inFlight = null;
    });
  }

  Future<SyncReport> _flush() async {
    final online = await connectivity.isOnline(api);
    if (!online) {
      return const SyncReport(
        offline: true,
        pushed: 0,
        conflicts: 0,
        failed: 0,
      );
    }

    final tasks = await queue.pending();
    var pushed = 0;
    var conflicts = 0;
    var failed = 0;
    var dropped = false;

    for (final task in tasks) {
      try {
        final outcome = await _push(task);
        if (!outcome.applied) continue;
        pushed += 1;
        if (outcome.conflict) conflicts += 1;
      } on ApiOfflineException {
        dropped = true;
        break;
      } catch (error) {
        failed += 1;
        await queue.recordAttempt(task, error.toString());
        await repository.setSyncError(task.inspectionId, error.toString());
      }
    }

    return SyncReport(
      offline: dropped,
      pushed: pushed,
      conflicts: conflicts,
      failed: failed,
    );
  }

  Future<_PushOutcome> _push(SyncTask task) async {
    final local = await repository.getById(
      task.inspectionId,
      includeDeleted: true,
    );
    if (local == null) {
      await queue.markDone(task.id);
      return const _PushOutcome(applied: false, conflict: false);
    }
    final remote = remoteFromInspection(local);
    final result = switch (task.op) {
      SyncOp.delete => await api.pushDelete(
          remote,
          baseUpdatedAt: local.baseUpdatedAt,
        ),
      SyncOp.upsert => await api.pushUpsert(
          remote,
          baseUpdatedAt: local.baseUpdatedAt,
        ),
    };
    await repository.applyPushResult(result);
    await queue.markDone(task.id);
    return _PushOutcome(applied: true, conflict: result.conflict);
  }
}

class _PushOutcome {
  const _PushOutcome({required this.applied, required this.conflict});

  final bool applied;
  final bool conflict;
}
