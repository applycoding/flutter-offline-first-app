import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/db/sqlite_setup.dart';
import 'providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureSqlite();
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'site_check.sqlite'));
  final database = AppDatabase(NativeDatabase(file));
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        pollConnectivityProvider.overrideWithValue(true),
      ],
      child: const SiteCheckApp(),
    ),
  );
}
