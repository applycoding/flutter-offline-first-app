import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../core/ids.dart';
import '../../domain/conflict_copy.dart';
import '../../domain/inspection.dart';
import '../../domain/sync_task.dart';
import '../../domain/templates.dart';
import '../db/app_database.dart';
import '../remote/inspection_api.dart';
import '../sync/sync_queue_store.dart';

class InspectionRepository {
  InspectionRepository({
    required this.db,
    required this.queue,
    required this.clock,
    required this.ids,
  });

  final AppDatabase db;
  final SyncQueueStore queue;
  final Clock clock;
  final IdGenerator ids;

  Stream<List<Inspection>> watchActive() {
    final query = _join()
      ..where(db.inspections.deleted.equals(false))
      ..orderBy([
        OrderingTerm.desc(db.inspections.updatedAt),
        OrderingTerm.asc(db.checklistItems.position),
      ]);
    return query.watch().map(_group);
  }

  Stream<Inspection?> watchById(String id) {
    final query = _join()
      ..where(db.inspections.id.equals(id))
      ..orderBy([OrderingTerm.asc(db.checklistItems.position)]);
    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final inspection = _group(rows).single;
      if (inspection.deleted) return null;
      return inspection;
    });
  }

  Future<int> countActive() async {
    final countExp = db.inspections.id.count();
    final query = db.selectOnly(db.inspections)
      ..addColumns([countExp])
      ..where(db.inspections.deleted.equals(false));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<Inspection?> getById(
    String id, {
    bool includeDeleted = false,
  }) async {
    final row = await (db.select(db.inspections)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    if (row.deleted && !includeDeleted) return null;
    final items = await (db.select(db.checklistItems)
          ..where((table) => table.inspectionId.equals(id))
          ..orderBy([(table) => OrderingTerm.asc(table.position)]))
        .get();
    return _fromRow(row, items);
  }

  Future<Inspection> create({
    required String siteName,
    required String assetId,
    required String inspector,
    required String templateName,
  }) async {
    final labels = checklistTemplates[templateName];
    if (labels == null) {
      throw ArgumentError.value(
        templateName,
        'templateName',
        'Unknown checklist template',
      );
    }
    final now = clock.nowMillis();
    final id = ids.newId();
    final items = <ChecklistItem>[
      for (var index = 0; index < labels.length; index++)
        ChecklistItem(
          id: ids.newId(),
          inspectionId: id,
          label: labels[index],
          result: CheckResult.pending,
          note: '',
          position: index,
        ),
    ];
    final inspection = Inspection(
      id: id,
      siteName: siteName.trim(),
      assetId: assetId.trim(),
      inspector: inspector.trim(),
      status: InspectionStatus.draft,
      notes: '',
      updatedAt: now,
      baseUpdatedAt: null,
      conflictFlag: false,
      conflictDetail: '',
      pendingSync: true,
      deleted: false,
      syncError: null,
      items: items,
    );
    await db.transaction(() async {
      await _write(inspection);
      await queue.enqueue(id, SyncOp.upsert, now);
    });
    return inspection;
  }

  Future<void> setItemResult({
    required String inspectionId,
    required String itemId,
    required CheckResult result,
  }) async {
    final current = await getById(inspectionId);
    if (current == null) {
      throw StateError('Inspection $inspectionId not found');
    }
    final now = clock.nowMillis();
    final status = _statusAfterEdit(current.status);
    await db.transaction(() async {
      await (db.update(db.checklistItems)
            ..where((table) => table.id.equals(itemId)))
          .write(ChecklistItemsCompanion(result: Value(result.wire)));
      await _markDirty(inspectionId, now, status: status);
      await queue.enqueue(inspectionId, SyncOp.upsert, now);
    });
  }

  Future<void> setItemNote({
    required String inspectionId,
    required String itemId,
    required String note,
  }) async {
    final current = await getById(inspectionId);
    if (current == null) {
      throw StateError('Inspection $inspectionId not found');
    }
    final existing = current.items.where((item) => item.id == itemId);
    if (existing.isEmpty) {
      throw StateError('Checklist item $itemId not found');
    }
    if (existing.single.note == note) return;
    final now = clock.nowMillis();
    final status = _statusAfterEdit(current.status);
    await db.transaction(() async {
      await (db.update(db.checklistItems)
            ..where((table) => table.id.equals(itemId)))
          .write(ChecklistItemsCompanion(note: Value(note)));
      await _markDirty(inspectionId, now, status: status);
      await queue.enqueue(inspectionId, SyncOp.upsert, now);
    });
  }

  Future<void> updateNotes({required String id, required String notes}) async {
    final current = await getById(id);
    if (current == null) {
      throw StateError('Inspection $id not found');
    }
    if (current.notes == notes) return;
    final now = clock.nowMillis();
    final status = _statusAfterEdit(current.status);
    await db.transaction(() async {
      await (db.update(db.inspections)..where((table) => table.id.equals(id)))
          .write(
        InspectionsCompanion(
          notes: Value(notes),
          status: Value(status.wire),
          updatedAt: Value(now),
          pendingSync: const Value(true),
          syncError: const Value(null),
        ),
      );
      await queue.enqueue(id, SyncOp.upsert, now);
    });
  }

  /// Returns an error message when the checklist is still incomplete.
  Future<String?> markComplete(String id) async {
    final current = await getById(id);
    if (current == null) return 'Inspection not found';
    if (!current.readyToComplete) {
      return 'Answer every checklist item first';
    }
    if (current.status == InspectionStatus.completed) return null;
    final now = clock.nowMillis();
    await db.transaction(() async {
      await _markDirty(id, now, status: InspectionStatus.completed);
      await queue.enqueue(id, SyncOp.upsert, now);
    });
    return null;
  }

  Future<void> deleteInspection(String id) async {
    final now = clock.nowMillis();
    await db.transaction(() async {
      await (db.update(db.inspections)..where((table) => table.id.equals(id)))
          .write(
        InspectionsCompanion(
          deleted: const Value(true),
          updatedAt: Value(now),
          pendingSync: const Value(true),
          syncError: const Value(null),
        ),
      );
      await queue.enqueue(id, SyncOp.delete, now);
    });
  }

  Future<void> dismissConflict(String id) {
    return (db.update(db.inspections)..where((table) => table.id.equals(id)))
        .write(
      const InspectionsCompanion(
        conflictFlag: Value(false),
        conflictDetail: Value(''),
      ),
    );
  }

  Future<void> setSyncError(String id, String message) {
    return (db.update(db.inspections)..where((table) => table.id.equals(id)))
        .write(InspectionsCompanion(syncError: Value(message)));
  }

  Future<void> replaceLocal(Inspection inspection) async {
    await db.transaction(() async {
      await _write(inspection);
    });
  }

  Future<void> applyPushResult(PushResult result) async {
    if (!result.localWon) {
      await replaceLocal(
        _fromRemote(
          result.winner,
          conflictFlag: true,
          conflictDetail: serverWonConflictDetail,
          pendingSync: false,
          baseUpdatedAt: result.winner.updatedAt,
        ),
      );
      return;
    }
    await (db.update(db.inspections)
          ..where((table) => table.id.equals(result.winner.id)))
        .write(
      InspectionsCompanion(
        pendingSync: const Value(false),
        syncError: const Value(null),
        baseUpdatedAt: Value(result.winner.updatedAt),
        conflictFlag:
            result.conflict ? const Value(true) : const Value.absent(),
        conflictDetail: result.conflict
            ? const Value(localWonConflictDetail)
            : const Value.absent(),
      ),
    );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _join() {
    return db.select(db.inspections).join([
      leftOuterJoin(
        db.checklistItems,
        db.checklistItems.inspectionId.equalsExp(db.inspections.id),
      ),
    ]);
  }

  Future<void> _write(Inspection inspection) async {
    await db.into(db.inspections).insertOnConflictUpdate(
          InspectionsCompanion.insert(
            id: inspection.id,
            siteName: inspection.siteName,
            assetId: inspection.assetId,
            inspector: inspection.inspector,
            status: inspection.status.wire,
            updatedAt: inspection.updatedAt,
            notes: Value(inspection.notes),
            baseUpdatedAt: Value(inspection.baseUpdatedAt),
            conflictFlag: Value(inspection.conflictFlag),
            conflictDetail: Value(inspection.conflictDetail),
            pendingSync: Value(inspection.pendingSync),
            deleted: Value(inspection.deleted),
            syncError: Value(inspection.syncError),
          ),
        );
    await (db.delete(db.checklistItems)
          ..where((table) => table.inspectionId.equals(inspection.id)))
        .go();
    for (final item in inspection.items) {
      await db.into(db.checklistItems).insert(
            ChecklistItemsCompanion.insert(
              id: item.id,
              inspectionId: inspection.id,
              label: item.label,
              result: item.result.wire,
              position: item.position,
              note: Value(item.note),
            ),
          );
    }
  }

  Future<void> _markDirty(
    String id,
    int now, {
    required InspectionStatus status,
  }) {
    return (db.update(db.inspections)..where((table) => table.id.equals(id)))
        .write(
      InspectionsCompanion(
        status: Value(status.wire),
        updatedAt: Value(now),
        pendingSync: const Value(true),
        syncError: const Value(null),
      ),
    );
  }

  InspectionStatus _statusAfterEdit(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.draft:
      case InspectionStatus.completed:
        return InspectionStatus.inProgress;
      case InspectionStatus.inProgress:
        return InspectionStatus.inProgress;
    }
  }

  List<Inspection> _group(List<TypedResult> rows) {
    final grouped = <String, List<TypedResult>>{};
    for (final row in rows) {
      final id = row.readTable(db.inspections).id;
      grouped.putIfAbsent(id, () => []).add(row);
    }
    return [for (final entry in grouped.entries) _fromJoined(entry.value)];
  }

  Inspection _fromJoined(List<TypedResult> rows) {
    final row = rows.first.readTable(db.inspections);
    final items = <ChecklistItemRow>[];
    for (final joined in rows) {
      final item = joined.readTableOrNull(db.checklistItems);
      if (item != null) items.add(item);
    }
    return _fromRow(row, items);
  }

  Inspection _fromRow(InspectionRow row, List<ChecklistItemRow> items) {
    return Inspection(
      id: row.id,
      siteName: row.siteName,
      assetId: row.assetId,
      inspector: row.inspector,
      status: parseInspectionStatus(row.status),
      notes: row.notes,
      updatedAt: row.updatedAt,
      baseUpdatedAt: row.baseUpdatedAt,
      conflictFlag: row.conflictFlag,
      conflictDetail: row.conflictDetail,
      pendingSync: row.pendingSync,
      deleted: row.deleted,
      syncError: row.syncError,
      items: [
        for (final item in items)
          ChecklistItem(
            id: item.id,
            inspectionId: item.inspectionId,
            label: item.label,
            result: parseCheckResult(item.result),
            note: item.note,
            position: item.position,
          ),
      ],
    );
  }

  Inspection _fromRemote(
    RemoteInspection remote, {
    required bool conflictFlag,
    required String conflictDetail,
    required bool pendingSync,
    required int? baseUpdatedAt,
  }) {
    return Inspection(
      id: remote.id,
      siteName: remote.siteName,
      assetId: remote.assetId,
      inspector: remote.inspector,
      status: parseInspectionStatus(remote.status),
      notes: remote.notes,
      updatedAt: remote.updatedAt,
      baseUpdatedAt: baseUpdatedAt,
      conflictFlag: conflictFlag,
      conflictDetail: conflictDetail,
      pendingSync: pendingSync,
      deleted: remote.deleted,
      syncError: null,
      items: [
        for (final item in remote.items)
          ChecklistItem(
            id: item.id,
            inspectionId: remote.id,
            label: item.label,
            result: parseCheckResult(item.result),
            note: item.note,
            position: item.position,
          ),
      ],
    );
  }
}
