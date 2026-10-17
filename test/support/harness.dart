import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline_first_app/app.dart';
import 'package:flutter_offline_first_app/core/clock.dart';
import 'package:flutter_offline_first_app/core/connectivity.dart';
import 'package:flutter_offline_first_app/core/ids.dart';
import 'package:flutter_offline_first_app/data/db/app_database.dart';
import 'package:flutter_offline_first_app/data/db/sqlite_setup.dart';
import 'package:flutter_offline_first_app/data/remote/fake_inspection_api.dart';
import 'package:flutter_offline_first_app/data/repository/inspection_repository.dart';
import 'package:flutter_offline_first_app/data/sync/sync_engine.dart';
import 'package:flutter_offline_first_app/data/sync/sync_queue_store.dart';
import 'package:flutter_offline_first_app/domain/inspection.dart';
import 'package:flutter_offline_first_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

class SequentialIds implements IdGenerator {
  int _next = 0;

  @override
  String newId() {
    final id = 'id-$_next';
    _next += 1;
    return id;
  }
}

class TestEnv {
  TestEnv({
    required this.db,
    required this.api,
    required this.gate,
    required this.clock,
    required this.ids,
    required this.queue,
    required this.repository,
    required this.sync,
  });

  final AppDatabase db;
  final FakeInspectionApi api;
  final ConnectivityGate gate;
  final FakeClock clock;
  final SequentialIds ids;
  final SyncQueueStore queue;
  final InspectionRepository repository;
  final SyncEngine sync;

  static Future<TestEnv> open() async {
    configureSqlite();
    final db = AppDatabase(NativeDatabase.memory());
    final api = FakeInspectionApi();
    final gate = ConnectivityGate();
    final clock = FakeClock(1700000000000);
    final ids = SequentialIds();
    final queue = SyncQueueStore(db);
    final repository = InspectionRepository(
      db: db,
      queue: queue,
      clock: clock,
      ids: ids,
    );
    final sync = SyncEngine(
      repository: repository,
      queue: queue,
      api: api,
      connectivity: gate,
    );
    return TestEnv(
      db: db,
      api: api,
      gate: gate,
      clock: clock,
      ids: ids,
      queue: queue,
      repository: repository,
      sync: sync,
    );
  }

  List<Override> overrides({bool seed = false}) => [
        databaseProvider.overrideWithValue(db),
        apiProvider.overrideWithValue(api),
        clockProvider.overrideWithValue(clock),
        idGeneratorProvider.overrideWithValue(ids),
        connectivityGateProvider.overrideWithValue(gate),
        seedOnStartProvider.overrideWithValue(seed),
        pollConnectivityProvider.overrideWithValue(false),
      ];

  Widget buildApp({
    bool seed = false,
    List<Override> extraOverrides = const [],
  }) {
    return ProviderScope(
      overrides: [...overrides(seed: seed), ...extraOverrides],
      child: const SiteCheckApp(),
    );
  }

  Future<Inspection> createPump({String siteName = 'North Pump House'}) {
    return repository.create(
      siteName: siteName,
      assetId: 'PH-12',
      inspector: 'Arpan Bom',
      templateName: 'Pump house',
    );
  }
}

Future<void> pumpApp(WidgetTester tester, TestEnv env) async {
  await tester.pumpWidget(env.buildApp());
  await tester.pumpAndSettle();
}

Future<void> shutdown(WidgetTester tester, TestEnv env) async {
  // Unmount first so Drift can drop its stream subscriptions. Pump once more
  // so the zero-duration cache timers fire before close(); closing while those
  // fake-async timers are pending never returns.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 50));
  await env.db.close();
}
