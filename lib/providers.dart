import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/clock.dart';
import 'core/connectivity.dart';
import 'core/ids.dart';
import 'data/db/app_database.dart';
import 'data/demo_seeder.dart';
import 'data/remote/fake_inspection_api.dart';
import 'data/remote/inspection_api.dart';
import 'data/repository/inspection_repository.dart';
import 'data/sync/sync_engine.dart';
import 'data/sync/sync_queue_store.dart';
import 'domain/inspection.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError(
    'databaseProvider must be overridden with an open AppDatabase',
  );
});

final apiProvider = Provider<InspectionApi>((ref) => FakeInspectionApi());

final clockProvider = Provider<Clock>((ref) => const Clock());

final idGeneratorProvider = Provider<IdGenerator>((ref) => UuidGenerator());

final connectivityGateProvider = Provider<ConnectivityGate>(
  (ref) => ConnectivityGate(),
);

/// Periodic health checks. Enabled from `main`, left off in tests.
final pollConnectivityProvider = Provider<bool>((ref) => false);

final seedOnStartProvider = Provider<bool>((ref) => true);

final syncQueueProvider = Provider<SyncQueueStore>((ref) {
  return SyncQueueStore(ref.watch(databaseProvider));
});

final repositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(
    db: ref.watch(databaseProvider),
    queue: ref.watch(syncQueueProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    repository: ref.watch(repositoryProvider),
    queue: ref.watch(syncQueueProvider),
    api: ref.watch(apiProvider),
    connectivity: ref.watch(connectivityGateProvider),
  );
});

final seederProvider = Provider<DemoSeeder>((ref) {
  return DemoSeeder(
    repository: ref.watch(repositoryProvider),
    api: ref.watch(apiProvider),
    clock: ref.watch(clockProvider),
  );
});

final bootstrapProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(seedOnStartProvider)) return;
  await ref.watch(seederProvider).seedIfEmpty();
});

final inspectionsProvider = StreamProvider<List<Inspection>>((ref) {
  return ref.watch(repositoryProvider).watchActive();
});

final inspectionProvider = StreamProvider.family<Inspection?, String>((
  ref,
  id,
) {
  return ref.watch(repositoryProvider).watchById(id);
});

final pendingCountProvider = StreamProvider<int>((ref) {
  return ref.watch(syncQueueProvider).watchPendingCount();
});

final onlineProvider = NotifierProvider<OnlineController, ConnectionSnapshot>(
  OnlineController.new,
);

class OnlineController extends Notifier<ConnectionSnapshot> {
  @override
  ConnectionSnapshot build() {
    return const ConnectionSnapshot(
      simulatedOffline: false,
      serverReachable: true,
    );
  }

  Future<void> toggleSimulation() async {
    final nextOffline = !state.simulatedOffline;
    ref.read(connectivityGateProvider).simulatedOffline = nextOffline;
    state = state.copyWith(simulatedOffline: nextOffline);
    if (state.online) {
      await ref.read(syncControllerProvider.notifier).flush();
    }
  }

  Future<void> refresh() async {
    final reachable = await ref.read(apiProvider).ping();
    if (!ref.mounted) return;
    final wasOnline = state.online;
    state = state.copyWith(serverReachable: reachable);
    if (state.online && !wasOnline) {
      await ref.read(syncControllerProvider.notifier).flush();
    }
  }
}

class SyncControllerState {
  const SyncControllerState({this.running = false});

  final bool running;

  @override
  bool operator ==(Object other) {
    return other is SyncControllerState && other.running == running;
  }

  @override
  int get hashCode => running.hashCode;
}

final syncControllerProvider =
    NotifierProvider<SyncController, SyncControllerState>(SyncController.new);

class SyncController extends Notifier<SyncControllerState> {
  @override
  SyncControllerState build() => const SyncControllerState();

  Future<SyncReport> flush() async {
    state = const SyncControllerState(running: true);
    final report = await ref.read(syncEngineProvider).flush();
    if (ref.mounted) {
      state = const SyncControllerState(running: false);
    }
    return report;
  }
}
