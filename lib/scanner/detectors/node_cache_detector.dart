import 'dart:io';

import 'package:path/path.dart' as p;

import '../detector.dart';
import 'package:cleanx/models/scan_item.dart';

class NodeCacheDetector implements Detector {
  @override
  String get name => 'Node.js Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final projectsDir = Directory(p.join(homeDir, 'Projects')); // Assuming projects are in ~/Projects

    if (!await projectsDir.exists()) {
      return [];
    }

    await for (final entity in projectsDir.list(recursive: true, followLinks: false)) {
      if (entity is Directory && p.basename(entity.path) == 'node_modules') {
        final size = await _getDirectorySize(entity);
        if (size > 0) {
          items.add(ScanItem(
            id: entity.path,
            path: entity.path,
            name: 'node_modules',
            type: FileType.directory,
            sizeBytes: size,
            lastModified: (await entity.stat()).modified,
            detectorName: name,
          ));
        }
      }
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
