import 'dart:io';

import 'package:path/path.dart' as p;

import '../scan_item.dart';

class UserCacheDetector {
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final cachesPath = p.join(homeDir, 'Library', 'Caches');
    final logsPath = p.join(homeDir, 'Library', 'Logs');

    final items = <ScanItem>[];

    final cachesDir = Directory(cachesPath);
    if (await cachesDir.exists()) {
      final size = await _getDirectorySize(cachesDir);
      items.add(ScanItem(
        id: 'user_caches',
        path: cachesPath,
        name: 'User Caches',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await cachesDir.stat()).modified,
        detectorName: 'UserCacheDetector',
      ));
    }

    final logsDir = Directory(logsPath);
    if (await logsDir.exists()) {
      final size = await _getDirectorySize(logsDir);
      items.add(ScanItem(
        id: 'user_logs',
        path: logsPath,
        name: 'User Logs',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await logsDir.stat()).modified,
        detectorName: 'UserCacheDetector',
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
