import '../../domain/inspection.dart';

/// REST-shaped client for the field server.
///
/// The demo implementation is in-memory. Paths match the fake server:
/// `GET /health`, `GET /inspections`, `PUT /inspections/:id`,
/// `DELETE /inspections/:id`.
abstract class InspectionApi {
  Future<bool> ping();

  Future<List<RemoteInspection>> fetchAll();

  Future<PushResult> pushUpsert(
    RemoteInspection inspection, {
    required int? baseUpdatedAt,
  });

  Future<PushResult> pushDelete(
    RemoteInspection inspection, {
    required int? baseUpdatedAt,
  });

  /// Inserts a server row without a client request.
  ///
  /// Demo seed data and tests use this to plant the other side of a conflict.
  void stageServerRecord(RemoteInspection inspection);

  RemoteInspection? readServerRecord(String id);
}

class RemoteInspection {
  const RemoteInspection({
    required this.id,
    required this.siteName,
    required this.assetId,
    required this.inspector,
    required this.status,
    required this.notes,
    required this.updatedAt,
    required this.deleted,
    required this.items,
  });

  final String id;
  final String siteName;
  final String assetId;
  final String inspector;
  final String status;
  final String notes;
  final int updatedAt;
  final bool deleted;
  final List<RemoteChecklistItem> items;

  RemoteInspection copyWith({
    String? notes,
    int? updatedAt,
    bool? deleted,
    String? status,
    List<RemoteChecklistItem>? items,
  }) {
    return RemoteInspection(
      id: id,
      siteName: siteName,
      assetId: assetId,
      inspector: inspector,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteName': siteName,
      'assetId': assetId,
      'inspector': inspector,
      'status': status,
      'notes': notes,
      'updatedAt': updatedAt,
      'deleted': deleted,
      'items': [for (final item in items) item.toJson()],
    };
  }

  factory RemoteInspection.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('inspection items must be a list');
    }
    return RemoteInspection(
      id: json['id'] as String,
      siteName: json['siteName'] as String,
      assetId: json['assetId'] as String,
      inspector: json['inspector'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String,
      updatedAt: json['updatedAt'] as int,
      deleted: json['deleted'] as bool,
      items: [
        for (final raw in rawItems)
          RemoteChecklistItem.fromJson(raw as Map<String, dynamic>),
      ],
    );
  }
}

class RemoteChecklistItem {
  const RemoteChecklistItem({
    required this.id,
    required this.label,
    required this.result,
    required this.note,
    required this.position,
  });

  final String id;
  final String label;
  final String result;
  final String note;
  final int position;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'result': result,
      'note': note,
      'position': position,
    };
  }

  factory RemoteChecklistItem.fromJson(Map<String, dynamic> json) {
    return RemoteChecklistItem(
      id: json['id'] as String,
      label: json['label'] as String,
      result: json['result'] as String,
      note: json['note'] as String,
      position: json['position'] as int,
    );
  }
}

class PushResult {
  const PushResult({
    required this.conflict,
    required this.localWon,
    required this.winner,
  });

  final bool conflict;
  final bool localWon;
  final RemoteInspection winner;

  factory PushResult.fromJson(Map<String, dynamic> json) {
    final winnerRaw = json['winner'];
    final inspectionRaw = json['inspection'];
    if (inspectionRaw is! Map<String, dynamic>) {
      throw const FormatException('push result is missing inspection');
    }
    final localWon = switch (winnerRaw) {
      'local' => true,
      'server' => false,
      _ => throw FormatException('Unknown winner: $winnerRaw'),
    };
    return PushResult(
      conflict: json['conflict'] as bool,
      localWon: localWon,
      winner: RemoteInspection.fromJson(inspectionRaw),
    );
  }
}

class ApiRequest {
  const ApiRequest({required this.method, required this.path, this.body});

  final String method;
  final String path;
  final Map<String, dynamic>? body;
}

class ApiOfflineException implements Exception {
  const ApiOfflineException();

  @override
  String toString() => 'API unreachable';
}

class ApiRequestException implements Exception {
  const ApiRequestException(this.message);

  final String message;

  @override
  String toString() => message;
}

RemoteInspection remoteFromInspection(Inspection inspection) {
  return RemoteInspection(
    id: inspection.id,
    siteName: inspection.siteName,
    assetId: inspection.assetId,
    inspector: inspection.inspector,
    status: inspection.status.wire,
    notes: inspection.notes,
    updatedAt: inspection.updatedAt,
    deleted: inspection.deleted,
    items: [
      for (final item in inspection.items)
        RemoteChecklistItem(
          id: item.id,
          label: item.label,
          result: item.result.wire,
          note: item.note,
          position: item.position,
        ),
    ],
  );
}
