// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, InspectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _siteNameMeta =
      const VerificationMeta('siteName');
  @override
  late final GeneratedColumn<String> siteName = GeneratedColumn<String>(
      'site_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inspectorMeta =
      const VerificationMeta('inspector');
  @override
  late final GeneratedColumn<String> inspector = GeneratedColumn<String>(
      'inspector', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _baseUpdatedAtMeta =
      const VerificationMeta('baseUpdatedAt');
  @override
  late final GeneratedColumn<int> baseUpdatedAt = GeneratedColumn<int>(
      'base_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _conflictFlagMeta =
      const VerificationMeta('conflictFlag');
  @override
  late final GeneratedColumn<bool> conflictFlag = GeneratedColumn<bool>(
      'conflict_flag', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("conflict_flag" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _conflictDetailMeta =
      const VerificationMeta('conflictDetail');
  @override
  late final GeneratedColumn<String> conflictDetail = GeneratedColumn<String>(
      'conflict_detail', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncErrorMeta =
      const VerificationMeta('syncError');
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
      'sync_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        siteName,
        assetId,
        inspector,
        status,
        notes,
        updatedAt,
        baseUpdatedAt,
        conflictFlag,
        conflictDetail,
        pendingSync,
        deleted,
        syncError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(Insertable<InspectionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('site_name')) {
      context.handle(_siteNameMeta,
          siteName.isAcceptableOrUnknown(data['site_name']!, _siteNameMeta));
    } else if (isInserting) {
      context.missing(_siteNameMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('inspector')) {
      context.handle(_inspectorMeta,
          inspector.isAcceptableOrUnknown(data['inspector']!, _inspectorMeta));
    } else if (isInserting) {
      context.missing(_inspectorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('base_updated_at')) {
      context.handle(
          _baseUpdatedAtMeta,
          baseUpdatedAt.isAcceptableOrUnknown(
              data['base_updated_at']!, _baseUpdatedAtMeta));
    }
    if (data.containsKey('conflict_flag')) {
      context.handle(
          _conflictFlagMeta,
          conflictFlag.isAcceptableOrUnknown(
              data['conflict_flag']!, _conflictFlagMeta));
    }
    if (data.containsKey('conflict_detail')) {
      context.handle(
          _conflictDetailMeta,
          conflictDetail.isAcceptableOrUnknown(
              data['conflict_detail']!, _conflictDetailMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('sync_error')) {
      context.handle(_syncErrorMeta,
          syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      siteName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_name'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      inspector: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inspector'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      baseUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_updated_at']),
      conflictFlag: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}conflict_flag'])!,
      conflictDetail: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conflict_detail'])!,
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      syncError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_error']),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }
}

class InspectionRow extends DataClass implements Insertable<InspectionRow> {
  final String id;
  final String siteName;
  final String assetId;
  final String inspector;
  final String status;
  final String notes;
  final int updatedAt;
  final int? baseUpdatedAt;
  final bool conflictFlag;
  final String conflictDetail;
  final bool pendingSync;
  final bool deleted;
  final String? syncError;
  const InspectionRow(
      {required this.id,
      required this.siteName,
      required this.assetId,
      required this.inspector,
      required this.status,
      required this.notes,
      required this.updatedAt,
      this.baseUpdatedAt,
      required this.conflictFlag,
      required this.conflictDetail,
      required this.pendingSync,
      required this.deleted,
      this.syncError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['site_name'] = Variable<String>(siteName);
    map['asset_id'] = Variable<String>(assetId);
    map['inspector'] = Variable<String>(inspector);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || baseUpdatedAt != null) {
      map['base_updated_at'] = Variable<int>(baseUpdatedAt);
    }
    map['conflict_flag'] = Variable<bool>(conflictFlag);
    map['conflict_detail'] = Variable<String>(conflictDetail);
    map['pending_sync'] = Variable<bool>(pendingSync);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      siteName: Value(siteName),
      assetId: Value(assetId),
      inspector: Value(inspector),
      status: Value(status),
      notes: Value(notes),
      updatedAt: Value(updatedAt),
      baseUpdatedAt: baseUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUpdatedAt),
      conflictFlag: Value(conflictFlag),
      conflictDetail: Value(conflictDetail),
      pendingSync: Value(pendingSync),
      deleted: Value(deleted),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
    );
  }

  factory InspectionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionRow(
      id: serializer.fromJson<String>(json['id']),
      siteName: serializer.fromJson<String>(json['siteName']),
      assetId: serializer.fromJson<String>(json['assetId']),
      inspector: serializer.fromJson<String>(json['inspector']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      baseUpdatedAt: serializer.fromJson<int?>(json['baseUpdatedAt']),
      conflictFlag: serializer.fromJson<bool>(json['conflictFlag']),
      conflictDetail: serializer.fromJson<String>(json['conflictDetail']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncError: serializer.fromJson<String?>(json['syncError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'siteName': serializer.toJson<String>(siteName),
      'assetId': serializer.toJson<String>(assetId),
      'inspector': serializer.toJson<String>(inspector),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'baseUpdatedAt': serializer.toJson<int?>(baseUpdatedAt),
      'conflictFlag': serializer.toJson<bool>(conflictFlag),
      'conflictDetail': serializer.toJson<String>(conflictDetail),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'deleted': serializer.toJson<bool>(deleted),
      'syncError': serializer.toJson<String?>(syncError),
    };
  }

  InspectionRow copyWith(
          {String? id,
          String? siteName,
          String? assetId,
          String? inspector,
          String? status,
          String? notes,
          int? updatedAt,
          Value<int?> baseUpdatedAt = const Value.absent(),
          bool? conflictFlag,
          String? conflictDetail,
          bool? pendingSync,
          bool? deleted,
          Value<String?> syncError = const Value.absent()}) =>
      InspectionRow(
        id: id ?? this.id,
        siteName: siteName ?? this.siteName,
        assetId: assetId ?? this.assetId,
        inspector: inspector ?? this.inspector,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        updatedAt: updatedAt ?? this.updatedAt,
        baseUpdatedAt:
            baseUpdatedAt.present ? baseUpdatedAt.value : this.baseUpdatedAt,
        conflictFlag: conflictFlag ?? this.conflictFlag,
        conflictDetail: conflictDetail ?? this.conflictDetail,
        pendingSync: pendingSync ?? this.pendingSync,
        deleted: deleted ?? this.deleted,
        syncError: syncError.present ? syncError.value : this.syncError,
      );
  InspectionRow copyWithCompanion(InspectionsCompanion data) {
    return InspectionRow(
      id: data.id.present ? data.id.value : this.id,
      siteName: data.siteName.present ? data.siteName.value : this.siteName,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      inspector: data.inspector.present ? data.inspector.value : this.inspector,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      baseUpdatedAt: data.baseUpdatedAt.present
          ? data.baseUpdatedAt.value
          : this.baseUpdatedAt,
      conflictFlag: data.conflictFlag.present
          ? data.conflictFlag.value
          : this.conflictFlag,
      conflictDetail: data.conflictDetail.present
          ? data.conflictDetail.value
          : this.conflictDetail,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionRow(')
          ..write('id: $id, ')
          ..write('siteName: $siteName, ')
          ..write('assetId: $assetId, ')
          ..write('inspector: $inspector, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('conflictFlag: $conflictFlag, ')
          ..write('conflictDetail: $conflictDetail, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('deleted: $deleted, ')
          ..write('syncError: $syncError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      siteName,
      assetId,
      inspector,
      status,
      notes,
      updatedAt,
      baseUpdatedAt,
      conflictFlag,
      conflictDetail,
      pendingSync,
      deleted,
      syncError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionRow &&
          other.id == this.id &&
          other.siteName == this.siteName &&
          other.assetId == this.assetId &&
          other.inspector == this.inspector &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.baseUpdatedAt == this.baseUpdatedAt &&
          other.conflictFlag == this.conflictFlag &&
          other.conflictDetail == this.conflictDetail &&
          other.pendingSync == this.pendingSync &&
          other.deleted == this.deleted &&
          other.syncError == this.syncError);
}

class InspectionsCompanion extends UpdateCompanion<InspectionRow> {
  final Value<String> id;
  final Value<String> siteName;
  final Value<String> assetId;
  final Value<String> inspector;
  final Value<String> status;
  final Value<String> notes;
  final Value<int> updatedAt;
  final Value<int?> baseUpdatedAt;
  final Value<bool> conflictFlag;
  final Value<String> conflictDetail;
  final Value<bool> pendingSync;
  final Value<bool> deleted;
  final Value<String?> syncError;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.siteName = const Value.absent(),
    this.assetId = const Value.absent(),
    this.inspector = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.conflictFlag = const Value.absent(),
    this.conflictDetail = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required String siteName,
    required String assetId,
    required String inspector,
    required String status,
    this.notes = const Value.absent(),
    required int updatedAt,
    this.baseUpdatedAt = const Value.absent(),
    this.conflictFlag = const Value.absent(),
    this.conflictDetail = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncError = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        siteName = Value(siteName),
        assetId = Value(assetId),
        inspector = Value(inspector),
        status = Value(status),
        updatedAt = Value(updatedAt);
  static Insertable<InspectionRow> custom({
    Expression<String>? id,
    Expression<String>? siteName,
    Expression<String>? assetId,
    Expression<String>? inspector,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? updatedAt,
    Expression<int>? baseUpdatedAt,
    Expression<bool>? conflictFlag,
    Expression<String>? conflictDetail,
    Expression<bool>? pendingSync,
    Expression<bool>? deleted,
    Expression<String>? syncError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteName != null) 'site_name': siteName,
      if (assetId != null) 'asset_id': assetId,
      if (inspector != null) 'inspector': inspector,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (baseUpdatedAt != null) 'base_updated_at': baseUpdatedAt,
      if (conflictFlag != null) 'conflict_flag': conflictFlag,
      if (conflictDetail != null) 'conflict_detail': conflictDetail,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (deleted != null) 'deleted': deleted,
      if (syncError != null) 'sync_error': syncError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? siteName,
      Value<String>? assetId,
      Value<String>? inspector,
      Value<String>? status,
      Value<String>? notes,
      Value<int>? updatedAt,
      Value<int?>? baseUpdatedAt,
      Value<bool>? conflictFlag,
      Value<String>? conflictDetail,
      Value<bool>? pendingSync,
      Value<bool>? deleted,
      Value<String?>? syncError,
      Value<int>? rowid}) {
    return InspectionsCompanion(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      assetId: assetId ?? this.assetId,
      inspector: inspector ?? this.inspector,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      baseUpdatedAt: baseUpdatedAt ?? this.baseUpdatedAt,
      conflictFlag: conflictFlag ?? this.conflictFlag,
      conflictDetail: conflictDetail ?? this.conflictDetail,
      pendingSync: pendingSync ?? this.pendingSync,
      deleted: deleted ?? this.deleted,
      syncError: syncError ?? this.syncError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (siteName.present) {
      map['site_name'] = Variable<String>(siteName.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (inspector.present) {
      map['inspector'] = Variable<String>(inspector.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (baseUpdatedAt.present) {
      map['base_updated_at'] = Variable<int>(baseUpdatedAt.value);
    }
    if (conflictFlag.present) {
      map['conflict_flag'] = Variable<bool>(conflictFlag.value);
    }
    if (conflictDetail.present) {
      map['conflict_detail'] = Variable<String>(conflictDetail.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('siteName: $siteName, ')
          ..write('assetId: $assetId, ')
          ..write('inspector: $inspector, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('conflictFlag: $conflictFlag, ')
          ..write('conflictDetail: $conflictDetail, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('deleted: $deleted, ')
          ..write('syncError: $syncError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inspectionIdMeta =
      const VerificationMeta('inspectionId');
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
      'inspection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, inspectionId, label, result, note, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(Insertable<ChecklistItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
          _inspectionIdMeta,
          inspectionId.isAcceptableOrUnknown(
              data['inspection_id']!, _inspectionIdMeta));
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inspectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inspection_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItemRow extends DataClass
    implements Insertable<ChecklistItemRow> {
  final String id;
  final String inspectionId;
  final String label;
  final String result;
  final String note;
  final int position;
  const ChecklistItemRow(
      {required this.id,
      required this.inspectionId,
      required this.label,
      required this.result,
      required this.note,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['label'] = Variable<String>(label);
    map['result'] = Variable<String>(result);
    map['note'] = Variable<String>(note);
    map['position'] = Variable<int>(position);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      label: Value(label),
      result: Value(result),
      note: Value(note),
      position: Value(position),
    );
  }

  factory ChecklistItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItemRow(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      label: serializer.fromJson<String>(json['label']),
      result: serializer.fromJson<String>(json['result']),
      note: serializer.fromJson<String>(json['note']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'label': serializer.toJson<String>(label),
      'result': serializer.toJson<String>(result),
      'note': serializer.toJson<String>(note),
      'position': serializer.toJson<int>(position),
    };
  }

  ChecklistItemRow copyWith(
          {String? id,
          String? inspectionId,
          String? label,
          String? result,
          String? note,
          int? position}) =>
      ChecklistItemRow(
        id: id ?? this.id,
        inspectionId: inspectionId ?? this.inspectionId,
        label: label ?? this.label,
        result: result ?? this.result,
        note: note ?? this.note,
        position: position ?? this.position,
      );
  ChecklistItemRow copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItemRow(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      label: data.label.present ? data.label.value : this.label,
      result: data.result.present ? data.result.value : this.result,
      note: data.note.present ? data.note.value : this.note,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemRow(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('label: $label, ')
          ..write('result: $result, ')
          ..write('note: $note, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, inspectionId, label, result, note, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItemRow &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.label == this.label &&
          other.result == this.result &&
          other.note == this.note &&
          other.position == this.position);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItemRow> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String> label;
  final Value<String> result;
  final Value<String> note;
  final Value<int> position;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.label = const Value.absent(),
    this.result = const Value.absent(),
    this.note = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String inspectionId,
    required String label,
    required String result,
    this.note = const Value.absent(),
    required int position,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        inspectionId = Value(inspectionId),
        label = Value(label),
        result = Value(result),
        position = Value(position);
  static Insertable<ChecklistItemRow> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? label,
    Expression<String>? result,
    Expression<String>? note,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (label != null) 'label': label,
      if (result != null) 'result': result,
      if (note != null) 'note': note,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? inspectionId,
      Value<String>? label,
      Value<String>? result,
      Value<String>? note,
      Value<int>? position,
      Value<int>? rowid}) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      label: label ?? this.label,
      result: result ?? this.result,
      note: note ?? this.note,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('label: $label, ')
          ..write('result: $result, ')
          ..write('note: $note, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _inspectionIdMeta =
      const VerificationMeta('inspectionId');
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
      'inspection_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
      'op', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enqueuedAtMeta =
      const VerificationMeta('enqueuedAt');
  @override
  late final GeneratedColumn<int> enqueuedAt = GeneratedColumn<int>(
      'enqueued_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, inspectionId, op, enqueuedAt, attempts, lastError];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncTaskRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
          _inspectionIdMeta,
          inspectionId.isAcceptableOrUnknown(
              data['inspection_id']!, _inspectionIdMeta));
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('enqueued_at')) {
      context.handle(
          _enqueuedAtMeta,
          enqueuedAt.isAcceptableOrUnknown(
              data['enqueued_at']!, _enqueuedAtMeta));
    } else if (isInserting) {
      context.missing(_enqueuedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncTaskRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      inspectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inspection_id'])!,
      op: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}op'])!,
      enqueuedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}enqueued_at'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncTaskRow extends DataClass implements Insertable<SyncTaskRow> {
  final int id;
  final String inspectionId;
  final String op;
  final int enqueuedAt;
  final int attempts;
  final String? lastError;
  const SyncTaskRow(
      {required this.id,
      required this.inspectionId,
      required this.op,
      required this.enqueuedAt,
      required this.attempts,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['op'] = Variable<String>(op);
    map['enqueued_at'] = Variable<int>(enqueuedAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      op: Value(op),
      enqueuedAt: Value(enqueuedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncTaskRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncTaskRow(
      id: serializer.fromJson<int>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      op: serializer.fromJson<String>(json['op']),
      enqueuedAt: serializer.fromJson<int>(json['enqueuedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'op': serializer.toJson<String>(op),
      'enqueuedAt': serializer.toJson<int>(enqueuedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncTaskRow copyWith(
          {int? id,
          String? inspectionId,
          String? op,
          int? enqueuedAt,
          int? attempts,
          Value<String?> lastError = const Value.absent()}) =>
      SyncTaskRow(
        id: id ?? this.id,
        inspectionId: inspectionId ?? this.inspectionId,
        op: op ?? this.op,
        enqueuedAt: enqueuedAt ?? this.enqueuedAt,
        attempts: attempts ?? this.attempts,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  SyncTaskRow copyWithCompanion(SyncQueueCompanion data) {
    return SyncTaskRow(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      op: data.op.present ? data.op.value : this.op,
      enqueuedAt:
          data.enqueuedAt.present ? data.enqueuedAt.value : this.enqueuedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncTaskRow(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('op: $op, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, inspectionId, op, enqueuedAt, attempts, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncTaskRow &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.op == this.op &&
          other.enqueuedAt == this.enqueuedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class SyncQueueCompanion extends UpdateCompanion<SyncTaskRow> {
  final Value<int> id;
  final Value<String> inspectionId;
  final Value<String> op;
  final Value<int> enqueuedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.op = const Value.absent(),
    this.enqueuedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String inspectionId,
    required String op,
    required int enqueuedAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  })  : inspectionId = Value(inspectionId),
        op = Value(op),
        enqueuedAt = Value(enqueuedAt);
  static Insertable<SyncTaskRow> custom({
    Expression<int>? id,
    Expression<String>? inspectionId,
    Expression<String>? op,
    Expression<int>? enqueuedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (op != null) 'op': op,
      if (enqueuedAt != null) 'enqueued_at': enqueuedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? inspectionId,
      Value<String>? op,
      Value<int>? enqueuedAt,
      Value<int>? attempts,
      Value<String?>? lastError}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      op: op ?? this.op,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (enqueuedAt.present) {
      map['enqueued_at'] = Variable<int>(enqueuedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('op: $op, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [inspections, checklistItems, syncQueue];
}

typedef $$InspectionsTableCreateCompanionBuilder = InspectionsCompanion
    Function({
  required String id,
  required String siteName,
  required String assetId,
  required String inspector,
  required String status,
  Value<String> notes,
  required int updatedAt,
  Value<int?> baseUpdatedAt,
  Value<bool> conflictFlag,
  Value<String> conflictDetail,
  Value<bool> pendingSync,
  Value<bool> deleted,
  Value<String?> syncError,
  Value<int> rowid,
});
typedef $$InspectionsTableUpdateCompanionBuilder = InspectionsCompanion
    Function({
  Value<String> id,
  Value<String> siteName,
  Value<String> assetId,
  Value<String> inspector,
  Value<String> status,
  Value<String> notes,
  Value<int> updatedAt,
  Value<int?> baseUpdatedAt,
  Value<bool> conflictFlag,
  Value<String> conflictDetail,
  Value<bool> pendingSync,
  Value<bool> deleted,
  Value<String?> syncError,
  Value<int> rowid,
});

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteName => $composableBuilder(
      column: $table.siteName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inspector => $composableBuilder(
      column: $table.inspector, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseUpdatedAt => $composableBuilder(
      column: $table.baseUpdatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get conflictFlag => $composableBuilder(
      column: $table.conflictFlag, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictDetail => $composableBuilder(
      column: $table.conflictDetail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnFilters(column));
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteName => $composableBuilder(
      column: $table.siteName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inspector => $composableBuilder(
      column: $table.inspector, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseUpdatedAt => $composableBuilder(
      column: $table.baseUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get conflictFlag => $composableBuilder(
      column: $table.conflictFlag,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictDetail => $composableBuilder(
      column: $table.conflictDetail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnOrderings(column));
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siteName =>
      $composableBuilder(column: $table.siteName, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get inspector =>
      $composableBuilder(column: $table.inspector, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get baseUpdatedAt => $composableBuilder(
      column: $table.baseUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get conflictFlag => $composableBuilder(
      column: $table.conflictFlag, builder: (column) => column);

  GeneratedColumn<String> get conflictDetail => $composableBuilder(
      column: $table.conflictDetail, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);
}

class $$InspectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InspectionsTable,
    InspectionRow,
    $$InspectionsTableFilterComposer,
    $$InspectionsTableOrderingComposer,
    $$InspectionsTableAnnotationComposer,
    $$InspectionsTableCreateCompanionBuilder,
    $$InspectionsTableUpdateCompanionBuilder,
    (
      InspectionRow,
      BaseReferences<_$AppDatabase, $InspectionsTable, InspectionRow>
    ),
    InspectionRow,
    PrefetchHooks Function()> {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> siteName = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<String> inspector = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> baseUpdatedAt = const Value.absent(),
            Value<bool> conflictFlag = const Value.absent(),
            Value<String> conflictDetail = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InspectionsCompanion(
            id: id,
            siteName: siteName,
            assetId: assetId,
            inspector: inspector,
            status: status,
            notes: notes,
            updatedAt: updatedAt,
            baseUpdatedAt: baseUpdatedAt,
            conflictFlag: conflictFlag,
            conflictDetail: conflictDetail,
            pendingSync: pendingSync,
            deleted: deleted,
            syncError: syncError,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String siteName,
            required String assetId,
            required String inspector,
            required String status,
            Value<String> notes = const Value.absent(),
            required int updatedAt,
            Value<int?> baseUpdatedAt = const Value.absent(),
            Value<bool> conflictFlag = const Value.absent(),
            Value<String> conflictDetail = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InspectionsCompanion.insert(
            id: id,
            siteName: siteName,
            assetId: assetId,
            inspector: inspector,
            status: status,
            notes: notes,
            updatedAt: updatedAt,
            baseUpdatedAt: baseUpdatedAt,
            conflictFlag: conflictFlag,
            conflictDetail: conflictDetail,
            pendingSync: pendingSync,
            deleted: deleted,
            syncError: syncError,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InspectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InspectionsTable,
    InspectionRow,
    $$InspectionsTableFilterComposer,
    $$InspectionsTableOrderingComposer,
    $$InspectionsTableAnnotationComposer,
    $$InspectionsTableCreateCompanionBuilder,
    $$InspectionsTableUpdateCompanionBuilder,
    (
      InspectionRow,
      BaseReferences<_$AppDatabase, $InspectionsTable, InspectionRow>
    ),
    InspectionRow,
    PrefetchHooks Function()>;
typedef $$ChecklistItemsTableCreateCompanionBuilder = ChecklistItemsCompanion
    Function({
  required String id,
  required String inspectionId,
  required String label,
  required String result,
  Value<String> note,
  required int position,
  Value<int> rowid,
});
typedef $$ChecklistItemsTableUpdateCompanionBuilder = ChecklistItemsCompanion
    Function({
  Value<String> id,
  Value<String> inspectionId,
  Value<String> label,
  Value<String> result,
  Value<String> note,
  Value<int> position,
  Value<int> rowid,
});

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$ChecklistItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistItemsTable,
    ChecklistItemRow,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (
      ChecklistItemRow,
      BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItemRow>
    ),
    ChecklistItemRow,
    PrefetchHooks Function()> {
  $$ChecklistItemsTableTableManager(
      _$AppDatabase db, $ChecklistItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> inspectionId = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion(
            id: id,
            inspectionId: inspectionId,
            label: label,
            result: result,
            note: note,
            position: position,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String inspectionId,
            required String label,
            required String result,
            Value<String> note = const Value.absent(),
            required int position,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion.insert(
            id: id,
            inspectionId: inspectionId,
            label: label,
            result: result,
            note: note,
            position: position,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChecklistItemsTable,
    ChecklistItemRow,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (
      ChecklistItemRow,
      BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItemRow>
    ),
    ChecklistItemRow,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String inspectionId,
  required String op,
  required int enqueuedAt,
  Value<int> attempts,
  Value<String?> lastError,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> inspectionId,
  Value<String> op,
  Value<int> enqueuedAt,
  Value<int> attempts,
  Value<String?> lastError,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get op => $composableBuilder(
      column: $table.op, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get enqueuedAt => $composableBuilder(
      column: $table.enqueuedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get op => $composableBuilder(
      column: $table.op, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get enqueuedAt => $composableBuilder(
      column: $table.enqueuedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
      column: $table.inspectionId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<int> get enqueuedAt => $composableBuilder(
      column: $table.enqueuedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncTaskRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (SyncTaskRow, BaseReferences<_$AppDatabase, $SyncQueueTable, SyncTaskRow>),
    SyncTaskRow,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> inspectionId = const Value.absent(),
            Value<String> op = const Value.absent(),
            Value<int> enqueuedAt = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            inspectionId: inspectionId,
            op: op,
            enqueuedAt: enqueuedAt,
            attempts: attempts,
            lastError: lastError,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String inspectionId,
            required String op,
            required int enqueuedAt,
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            inspectionId: inspectionId,
            op: op,
            enqueuedAt: enqueuedAt,
            attempts: attempts,
            lastError: lastError,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncTaskRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (SyncTaskRow, BaseReferences<_$AppDatabase, $SyncQueueTable, SyncTaskRow>),
    SyncTaskRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
