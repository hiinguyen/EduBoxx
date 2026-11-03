/// Writes downloaded content bytes to the app's private file cache.
///
/// This file is platform-neutral; the native implementation lives in
/// `content_cache_io.dart` and the web build gets a no-op cache.
abstract interface class ContentCache {
  Future<String> write({
    required int contentId,
    required String extension,
    required List<int> bytes,
  });

  Future<bool> exists(String path);

  Future<void> delete(String path);
}

/// A no-op cache for the web build: browsers do not expose a durable file
/// path to the PDF/video plugins, and the roadmap's download states are
/// Android-first.
class UnsupportedContentCache implements ContentCache {
  @override
  Future<String> write({
    required int contentId,
    required String extension,
    required List<int> bytes,
  }) => throw UnsupportedError('Local content files are Android-only.');

  @override
  Future<bool> exists(String path) async => false;

  @override
  Future<void> delete(String path) async {}
}
