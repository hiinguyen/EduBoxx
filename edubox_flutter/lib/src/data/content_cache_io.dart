import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'content_cache.dart';

ContentCache createContentCache() => DirectoryContentCache();

/// Native file cache under `<app support>/edubox-content/`.
class DirectoryContentCache implements ContentCache {
  DirectoryContentCache({Future<Directory> Function()? root})
    : _root = root ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _root;

  @override
  Future<String> write({
    required int contentId,
    required String extension,
    required List<int> bytes,
  }) async {
    final directory = Directory(
      p.join((await _root()).path, 'edubox-content'),
    );
    await directory.create(recursive: true);
    final file = File(p.join(directory.path, '$contentId.$extension'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Future<bool> exists(String path) => File(path).exists();

  @override
  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
