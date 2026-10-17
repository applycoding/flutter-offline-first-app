/// One pending push for an inspection aggregate.
class SyncTask {
  const SyncTask({
    required this.id,
    required this.inspectionId,
    required this.op,
    required this.enqueuedAt,
    required this.attempts,
    required this.lastError,
  });

  final int id;
  final String inspectionId;
  final SyncOp op;
  final int enqueuedAt;
  final int attempts;
  final String? lastError;
}

enum SyncOp { upsert, delete }

SyncOp parseSyncOp(String value) {
  switch (value) {
    case 'upsert':
      return SyncOp.upsert;
    case 'delete':
      return SyncOp.delete;
    default:
      throw FormatException('Unknown sync op: $value');
  }
}
