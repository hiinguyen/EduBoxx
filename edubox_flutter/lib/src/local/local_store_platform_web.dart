import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// On the web the store lives in the browser (OPFS/IndexedDB) under this
/// name, so the platform handle is the drift database name.
typedef DatabaseLocation = String;

/// The browser store's name. `web/` ships the matching `sqlite3.wasm` and
/// `drift_worker.js` assets; see `web/README.md`.
const _databaseName = 'edubox';

/// Browser storage needs no file path; drift picks OPFS or IndexedDB.
Future<DatabaseLocation> defaultDatabaseLocation() async => _databaseName;

/// Opens the persistent browser database. `WasmDatabase.open` probes the
/// browser and may host sqlite3 in a worker; the executor is lazy because the
/// probe is asynchronous while `EduBoxDatabase.open` stays synchronous.
QueryExecutor openDatabaseExecutor(DatabaseLocation location) =>
    LazyDatabase(() async {
      final result = await WasmDatabase.open(
        databaseName: location,
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    });

/// The native in-memory executor is not part of the web build.
QueryExecutor openInMemoryExecutor() =>
    throw UnsupportedError('EduBoxDatabase.inMemory is native-only.');
