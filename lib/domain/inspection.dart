/// A field inspection and the checklist answers captured on device.
class Inspection {
  const Inspection({
    required this.id,
    required this.siteName,
    required this.assetId,
    required this.inspector,
    required this.status,
    required this.notes,
    required this.updatedAt,
    required this.baseUpdatedAt,
    required this.conflictFlag,
    required this.conflictDetail,
    required this.pendingSync,
    required this.deleted,
    required this.syncError,
    required this.items,
  });

  final String id;
  final String siteName;
  final String assetId;
  final String inspector;
  final InspectionStatus status;
  final String notes;

  /// Device clock in Unix milliseconds. Last-write-wins compares this value.
  final int updatedAt;

  /// Server `updatedAt` this device last based an edit on. Null until the
  /// first successful sync of a locally created record.
  final int? baseUpdatedAt;

  final bool conflictFlag;
  final String conflictDetail;
  final bool pendingSync;
  final bool deleted;
  final String? syncError;
  final List<ChecklistItem> items;

  int get checkedCount =>
      items.where((item) => item.result != CheckResult.pending).length;

  String get progressLabel => '$checkedCount of ${items.length} checked';

  bool get readyToComplete =>
      items.isNotEmpty &&
      items.every((item) => item.result != CheckResult.pending);

  Inspection copyWith({
    String? siteName,
    String? assetId,
    String? inspector,
    InspectionStatus? status,
    String? notes,
    int? updatedAt,
    Object? baseUpdatedAt = _keep,
    bool? conflictFlag,
    String? conflictDetail,
    bool? pendingSync,
    bool? deleted,
    Object? syncError = _keep,
    List<ChecklistItem>? items,
  }) {
    return Inspection(
      id: id,
      siteName: siteName ?? this.siteName,
      assetId: assetId ?? this.assetId,
      inspector: inspector ?? this.inspector,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      baseUpdatedAt: identical(baseUpdatedAt, _keep)
          ? this.baseUpdatedAt
          : baseUpdatedAt as int?,
      conflictFlag: conflictFlag ?? this.conflictFlag,
      conflictDetail: conflictDetail ?? this.conflictDetail,
      pendingSync: pendingSync ?? this.pendingSync,
      deleted: deleted ?? this.deleted,
      syncError:
          identical(syncError, _keep) ? this.syncError : syncError as String?,
      items: items ?? this.items,
    );
  }
}

class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.inspectionId,
    required this.label,
    required this.result,
    required this.note,
    required this.position,
  });

  final String id;
  final String inspectionId;
  final String label;
  final CheckResult result;
  final String note;
  final int position;

  ChecklistItem copyWith({
    CheckResult? result,
    String? note,
    int? position,
  }) {
    return ChecklistItem(
      id: id,
      inspectionId: inspectionId,
      label: label,
      result: result ?? this.result,
      note: note ?? this.note,
      position: position ?? this.position,
    );
  }
}

enum InspectionStatus { draft, inProgress, completed }

enum CheckResult { pending, pass, fail, na }

const Object _keep = Object();

extension InspectionStatusWire on InspectionStatus {
  String get wire {
    switch (this) {
      case InspectionStatus.draft:
        return 'draft';
      case InspectionStatus.inProgress:
        return 'inProgress';
      case InspectionStatus.completed:
        return 'completed';
    }
  }
}

extension CheckResultWire on CheckResult {
  String get wire {
    switch (this) {
      case CheckResult.pending:
        return 'pending';
      case CheckResult.pass:
        return 'pass';
      case CheckResult.fail:
        return 'fail';
      case CheckResult.na:
        return 'na';
    }
  }
}

InspectionStatus parseInspectionStatus(String value) {
  switch (value) {
    case 'draft':
      return InspectionStatus.draft;
    case 'inProgress':
      return InspectionStatus.inProgress;
    case 'completed':
      return InspectionStatus.completed;
    default:
      throw FormatException('Unknown inspection status: $value');
  }
}

CheckResult parseCheckResult(String value) {
  switch (value) {
    case 'pending':
      return CheckResult.pending;
    case 'pass':
      return CheckResult.pass;
    case 'fail':
      return CheckResult.fail;
    case 'na':
      return CheckResult.na;
    default:
      throw FormatException('Unknown check result: $value');
  }
}
