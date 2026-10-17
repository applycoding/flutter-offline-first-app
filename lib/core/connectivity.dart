import '../data/remote/inspection_api.dart';

/// Device-side connectivity gate.
///
/// [simulatedOffline] is the airplane-mode switch in the UI. Server
/// reachability is a separate ping of `GET /health` on the fake API.
class ConnectivityGate {
  bool simulatedOffline = false;

  Future<bool> isOnline(InspectionApi api) async {
    if (simulatedOffline) return false;
    return api.ping();
  }
}

class ConnectionSnapshot {
  const ConnectionSnapshot({
    required this.simulatedOffline,
    required this.serverReachable,
  });

  final bool simulatedOffline;
  final bool serverReachable;

  bool get online => !simulatedOffline && serverReachable;

  ConnectionSnapshot copyWith({
    bool? simulatedOffline,
    bool? serverReachable,
  }) {
    return ConnectionSnapshot(
      simulatedOffline: simulatedOffline ?? this.simulatedOffline,
      serverReachable: serverReachable ?? this.serverReachable,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectionSnapshot &&
        other.simulatedOffline == simulatedOffline &&
        other.serverReachable == serverReachable;
  }

  @override
  int get hashCode => Object.hash(simulatedOffline, serverReachable);
}
