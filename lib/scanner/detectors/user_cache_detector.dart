import 'dart:io';

import 'package:path/path.dart' as p;

import '../detector.dart';
import 'package:cleanx/models/scan_item.dart';

class UserCacheDetector implements Detector {
  @override
  String get name => 'User Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final cachesPath = p.join(homeDir, 'Library', 'Caches');
    final logsPath = p.join(homeDir, 'Library', 'Logs');

    await _scanDirectory(Directory(cachesPath), items);
    await _scanDirectory(Directory(logsPath), items);

    return items;
  }

  Future<void> _scanDirectory(Directory dir, List<ScanItem> items) async {
    if (!await dir.exists()) {
      return;
    }

    await for (final entity in dir.list(followLinks: false)) {
      if (entity is Directory) {
        final size = await _getDirectorySize(entity);
        if (size > 0) {
          items.add(ScanItem(
            id: entity.path,
            path: entity.path,
            name: p.basename(entity.path),
            type: FileType.directory,
            sizeBytes: size,
            lastModified: (await entity.stat()).modified,
            detectorName: name,
          ));
        }
      }
    }
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
