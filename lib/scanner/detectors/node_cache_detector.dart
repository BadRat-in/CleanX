import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

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
    final searchPaths = [
      p.join(homeDir, 'Projects'),
      p.join(homeDir, 'Developer'),
      p.join(homeDir, 'Work'),
    ];

    for (final path in searchPaths) {
      final dir = Directory(path);
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is Directory && p.basename(entity.path) == 'node_modules') {
            final size = await getDirectorySize(entity);
            if (size > 0) {
              items.add(ScanItem(
                id: entity.path,
                path: entity.path,
                name: 'node_modules in ${p.basename(p.dirname(entity.path))}',
                type: FileType.directory,
                sizeBytes: size,
                lastModified: (await entity.stat()).modified,
                detectorName: name,
              ));
            }
          }
        }
      }
    }

    return items;
  }
}
