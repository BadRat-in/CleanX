import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

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
    final derivedDataPath =
        p.join(homeDir, 'Library', 'Developer', 'Xcode', 'DerivedData');
    final derivedDataDir = Directory(derivedDataPath);

    if (await derivedDataDir.exists()) {
      final size = await getDirectorySize(derivedDataDir);
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
}
