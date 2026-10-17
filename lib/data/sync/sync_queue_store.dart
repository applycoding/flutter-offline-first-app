import 'package:drift/drift.dart';

import '../../domain/sync_task.dart';
import '../db/app_database.dart';

/// FIFO queue of inspection pushes. At most one row per inspection.
class SyncQueueStore {
  SyncQueueStore(this.db);

  final AppDatabase db;

  Future<void> enqueue(String inspectionId, SyncOp op, int enqueuedAt) async {
    final existing = await (db.select(db.syncQueue)
          ..where((row) => row.inspectionId.equals(inspectionId)))
        .getSingleOrNull();
    if (existing != null && existing.op == op.name) return;
    if (existing != null) {
      await (db.delete(db.syncQueue)
            ..where((row) => row.id.equals(existing.id)))
          .go();
    }
    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            inspectionId: inspectionId,
            op: op.name,
            enqueuedAt: enqueuedAt,
          ),
        );
  }

  Future<List<SyncTask>> pending() async {
    final rows = await (db.select(db.syncQueue)
          ..orderBy([(row) => OrderingTerm.asc(row.id)]))
        .get();
    return [for (final row in rows) _map(row)];
  }

  Stream<int> watchPendingCount() {
    final countExp = db.syncQueue.id.count();
    final query = db.selectOnly(db.syncQueue)..addColumns([countExp]);
    return query.watch().map((rows) => rows.single.read(countExp) ?? 0);
  }

  Future<void> markDone(int id) {
    return (db.delete(db.syncQueue)..where((row) => row.id.equals(id))).go();
  }

  Future<void> recordAttempt(SyncTask task, String error) {
    return (db.update(db.syncQueue)..where((row) => row.id.equals(task.id)))
        .write(
      SyncQueueCompanion(
        attempts: Value(task.attempts + 1),
        lastError: Value(error),
      ),
    );
  }

  SyncTask _map(SyncTaskRow row) {
    return SyncTask(
      id: row.id,
      inspectionId: row.inspectionId,
      op: parseSyncOp(row.op),
      enqueuedAt: row.enqueuedAt,
      attempts: row.attempts,
      lastError: row.lastError,
    );
  }
}
