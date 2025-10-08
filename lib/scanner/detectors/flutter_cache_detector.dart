import 'dart:io';

import 'package:path/path.dart' as p;

import '../detector.dart';
import '../scan_item.dart';

class FlutterCacheDetector implements Detector {
  @override
  String get name => 'Flutter Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final pubCachePath = p.join(homeDir, '.pub-cache');
    final pubCacheDir = Directory(pubCachePath);

    if (await pubCacheDir.exists()) {
      final size = await _getDirectorySize(pubCacheDir);
      items.add(ScanItem(
        id: 'pub_cache',
        path: pubCachePath,
        name: 'Pub Cache',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await pubCacheDir.stat()).modified,
        detectorName: name,
      ));
    }

    return items;
  }

  Future<int> _getDirectorySize(Directory dir) async {
    var size = 0;
    try {
      final files = await dir.list(recursive: true).toList();
      for (final file in files) {
        if (file is File) {
          try {
            size += await file.length();
          } catch (e) {
            // Ignore files that can't be accessed.
          }
        }
      }
    } catch (e) {
      // Ignore directories that can't be accessed.
    }
    return size;
  }
}
