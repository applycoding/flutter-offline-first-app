import 'dart:convert';

import 'inspection_api.dart';

/// In-memory stand-in for the field REST server.
///
/// Conflict rule: if the stored `updatedAt` differs from the client's
/// `baseUpdatedAt`, the write with the later `updatedAt` is kept. Equal
/// timestamps keep the incoming write. The response sets `conflict` so the
/// device can raise a flag. The server trusts client-supplied timestamps.
class FakeInspectionApi implements InspectionApi {
  final Map<String, Map<String, dynamic>> _store = {};
  final List<ApiRequest> requests = [];

  bool reachable = true;

  /// The next N mutating calls fail before the store changes.
  int failuresRemaining = 0;

  @override
  Future<bool> ping() async => reachable;

  @override
  void stageServerRecord(RemoteInspection inspection) {
    _store[inspection.id] = _clone(inspection.toJson());
  }

  @override
  RemoteInspection? readServerRecord(String id) {
    final json = _store[id];
    if (json == null) return null;
    return RemoteInspection.fromJson(_clone(json));
  }

  @override
  Future<List<RemoteInspection>> fetchAll() async {
    _ensureOnline();
    requests.add(const ApiRequest(method: 'GET', path: '/inspections'));
    final raw = _dispatch('GET', '/inspections', null);
    final list = raw['inspections'];
    if (list is! List<dynamic>) {
      throw const FormatException('inspections must be a list');
    }
    return [
      for (final item in list)
        RemoteInspection.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<PushResult> pushUpsert(
    RemoteInspection inspection, {
    required int? baseUpdatedAt,
  }) {
    return _send('PUT', '/inspections/${inspection.id}', {
      'baseUpdatedAt': baseUpdatedAt,
      'inspection': inspection.toJson(),
    });
  }

  @override
  Future<PushResult> pushDelete(
    RemoteInspection inspection, {
    required int? baseUpdatedAt,
  }) {
    final tombstone = inspection.copyWith(deleted: true);
    return _send('DELETE', '/inspections/${inspection.id}', {
      'baseUpdatedAt': baseUpdatedAt,
      'inspection': tombstone.toJson(),
    });
  }

  Future<PushResult> _send(
    String method,
    String path,
    Map<String, dynamic> body,
  ) async {
    _ensureOnline();
    requests.add(
      ApiRequest(method: method, path: path, body: _clone(body)),
    );
    if (failuresRemaining > 0) {
      failuresRemaining -= 1;
      throw const ApiRequestException('fake server failed the request');
    }
    final raw = _dispatch(method, path, body);
    return PushResult.fromJson(raw);
  }

  void _ensureOnline() {
    if (!reachable) throw const ApiOfflineException();
  }

  Map<String, dynamic> _dispatch(
    String method,
    String path,
    Map<String, dynamic>? body,
  ) {
    if (method == 'GET' && path == '/health') {
      return {'ok': true};
    }
    if (method == 'GET' && path == '/inspections') {
      final inspections = <Map<String, dynamic>>[];
      for (final json in _store.values) {
        final record = RemoteInspection.fromJson(_clone(json));
        if (!record.deleted) inspections.add(_clone(json));
      }
      return {'inspections': inspections};
    }

    final parts = path.split('/').where((part) => part.isNotEmpty).toList();
    if (parts.length == 2 && parts[0] == 'inspections') {
      final id = parts[1];
      if (method == 'GET') {
        final json = _store[id];
        if (json == null) {
          throw const ApiRequestException('not found');
        }
        return {'inspection': _clone(json)};
      }
      if (method == 'PUT' || method == 'DELETE') {
        if (body == null) {
          throw const ApiRequestException('body is required');
        }
        return _merge(id, method, body);
      }
    }
    throw ApiRequestException('No route for $method $path');
  }

  Map<String, dynamic> _merge(
    String id,
    String method,
    Map<String, dynamic> body,
  ) {
    final base = body['baseUpdatedAt'] as int?;
    final incomingRaw = body['inspection'];
    if (incomingRaw is! Map<String, dynamic>) {
      throw const ApiRequestException('inspection body is missing');
    }
    var incoming = RemoteInspection.fromJson(_clone(incomingRaw));
    if (incoming.id != id) {
      throw const ApiRequestException('path id does not match body');
    }
    if (method == 'DELETE') {
      incoming = incoming.copyWith(deleted: true);
    }

    final currentRaw = _store[id];
    if (currentRaw == null) {
      _store[id] = _clone(incoming.toJson());
      return _result(conflict: false, localWon: true, winner: incoming);
    }

    final current = RemoteInspection.fromJson(_clone(currentRaw));
    final diverged = base == null || current.updatedAt != base;
    if (!diverged || incoming.updatedAt >= current.updatedAt) {
      _store[id] = _clone(incoming.toJson());
      return _result(conflict: diverged, localWon: true, winner: incoming);
    }
    return _result(conflict: true, localWon: false, winner: current);
  }

  Map<String, dynamic> _result({
    required bool conflict,
    required bool localWon,
    required RemoteInspection winner,
  }) {
    return {
      'conflict': conflict,
      'winner': localWon ? 'local' : 'server',
      'inspection': winner.toJson(),
    };
  }

  Map<String, dynamic> _clone(Map<String, dynamic> json) {
    final decoded = jsonDecode(jsonEncode(json));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('expected JSON object');
    }
    return decoded;
  }
}
