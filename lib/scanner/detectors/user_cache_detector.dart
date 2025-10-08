import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

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
        final size = await getDirectorySize(entity);
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
}
