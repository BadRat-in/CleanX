import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

class HomebrewCacheDetector implements Detector {
  @override
  String get name => 'Homebrew Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final homebrewCachePath = p.join(homeDir, 'Library', 'Caches', 'Homebrew');
    final homebrewCacheDir = Directory(homebrewCachePath);

    if (await homebrewCacheDir.exists()) {
      final size = await getDirectorySize(homebrewCacheDir);
      items.add(ScanItem(
        id: 'homebrew_cache',
        path: homebrewCachePath,
        name: 'Homebrew Caches',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await homebrewCacheDir.stat()).modified,
        detectorName: name,
      ));
    }

    return items;
  }
}
