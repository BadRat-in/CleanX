import 'dart:io';

import 'package:path/path.dart' as p;

import '../detector.dart';
import '../scan_item.dart';

class XcodeCacheDetector implements Detector {
  @override
  String get name => 'Xcode Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final derivedDataPath = p.join(homeDir, 'Library', 'Developer', 'Xcode', 'DerivedData');
    final derivedDataDir = Directory(derivedDataPath);

    if (await derivedDataDir.exists()) {
      final size = await _getDirectorySize(derivedDataDir);
      items.add(ScanItem(
        id: 'derived_data',
        path: derivedDataPath,
        name: 'Xcode DerivedData',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await derivedDataDir.stat()).modified,
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
