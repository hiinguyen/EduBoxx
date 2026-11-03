import '../contract/backend_config.dart';
import '../contract/network_controller.dart';
import '../data/cached_backend.dart';
import '../data/client_edubox_api.dart';
import '../data/content_cache_io.dart'
    if (dart.library.js_interop) '../data/content_cache_web.dart';
import '../local/local_store.dart';
import '../local/local_store_platform_io.dart'
    if (dart.library.js_interop) '../local/local_store_platform_web.dart';
import '../network/platform_sources.dart';
import '../network/probed_network_controller.dart';
import 'app_scope.dart';

/// Production wiring: the generated client, the persisted drift store and the
/// probed network seam. Native builds use a file-backed store; the web build
/// uses browser storage. The E2E harness passes its own [network] (a
/// `ManualNetworkController`) and [databaseFile] so it can switch the seam
/// and re-create the app root over the same store.
Future<AppServices> createProductionServices(
  BackendConfig config, {
  NetworkController? network,
  DatabaseLocation? databaseFile,
}) async {
  final location = databaseFile ?? await defaultDatabaseLocation();
  final ownedNetwork = network == null
      ? await _startProbedNetwork(config)
      : null;
  final seam = network ?? ownedNetwork!;
  final backend = CachedBackend(
    api: ClientEduBoxApi.create(config),
    store: CachedDataStore(EduBoxDatabase.open(location)),
    network: seam,
    contentCache: createContentCache(),
  );
  return AppServices(
    backend: backend,
    network: seam,
    disposeNetwork: ownedNetwork?.dispose,
  );
}

Future<ProbedNetworkController> _startProbedNetwork(
  BackendConfig config,
) async {
  final controller = ProbedNetworkController(
    connectivity: ConnectivityPlusSource(),
    probe: HttpReachabilityProbe(config),
  );
  await controller.start();
  return controller;
}
