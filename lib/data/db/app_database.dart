import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DataClassName('InspectionRow')
class Inspections extends Table {
  TextColumn get id => text()();
  TextColumn get siteName => text()();
  TextColumn get assetId => text()();
  TextColumn get inspector => text()();
  TextColumn get status => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();
  IntColumn get baseUpdatedAt => integer().nullable()();
  BoolColumn get conflictFlag => boolean().withDefault(const Constant(false))();
  TextColumn get conflictDetail => text().withDefault(const Constant(''))();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ChecklistItemRow')
class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get inspectionId => text()();
  TextColumn get label => text()();
  TextColumn get result => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SyncTaskRow')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get inspectionId => text()();
  TextColumn get op => text()();
  IntColumn get enqueuedAt => integer()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

@DriftDatabase(tables: [Inspections, ChecklistItems, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
