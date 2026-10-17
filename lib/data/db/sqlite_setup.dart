import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Opens the system SQLite library on Linux.
///
/// `libsqlite3.so` comes from the dev package. `libsqlite3.so.0` is the
/// runtime soname used by CI images that only install `libsqlite3-0`.
void configureSqlite() {
  if (!Platform.isLinux) return;
  open.overrideFor(OperatingSystem.linux, () {
    try {
      return DynamicLibrary.open('libsqlite3.so');
    } on ArgumentError {
      return DynamicLibrary.open('libsqlite3.so.0');
    }
  });
}
