import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

class CocoapodsCacheDetector implements Detector {
  @override
  String get name => 'CocoaPods Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final cocoapodsCachePath = p.join(homeDir, '.cocoapods', 'repos');
    final cocoapodsCacheDir = Directory(cocoapodsCachePath);

    if (await cocoapodsCacheDir.exists()) {
      final size = await getDirectorySize(cocoapodsCacheDir);
      items.add(ScanItem(
        id: 'cocoapods_cache',
        path: cocoapodsCachePath,
        name: 'CocoaPods Caches',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await cocoapodsCacheDir.stat()).modified,
        detectorName: name,
      ));
    }

    return items;
  }
}
