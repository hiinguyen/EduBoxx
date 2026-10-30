import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native builds keep their file-backed store.
typedef DatabaseLocation = File;

/// The drift store file inside the app's support directory.
Future<DatabaseLocation> defaultDatabaseLocation() async {
  final dir = await getApplicationSupportDirectory();
  return File(p.join(dir.path, 'edubox.sqlite'));
}

/// Android/Linux keep the background-isolate sqlite3 database.
QueryExecutor openDatabaseExecutor(DatabaseLocation location) =>
    NativeDatabase.createInBackground(location);

/// A throwaway database for native tests and previews.
QueryExecutor openInMemoryExecutor() => NativeDatabase.memory();
