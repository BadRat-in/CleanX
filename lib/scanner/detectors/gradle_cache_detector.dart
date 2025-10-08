import 'dart:io';

import 'package:cleanx/models/scan_item.dart';
import 'package:cleanx/utils/file_utils.dart';
import 'package:path/path.dart' as p;

import '../detector.dart';

class GradleCacheDetector implements Detector {
  @override
  String get name => 'Gradle Caches';

  @override
  Future<List<ScanItem>> scan() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final items = <ScanItem>[];
    final gradleCachePath = p.join(homeDir, '.gradle', 'caches');
    final gradleCacheDir = Directory(gradleCachePath);

    if (await gradleCacheDir.exists()) {
      final size = await getDirectorySize(gradleCacheDir);
      items.add(ScanItem(
        id: 'gradle_cache',
        path: gradleCachePath,
        name: 'Gradle Caches',
        type: FileType.directory,
        sizeBytes: size,
        lastModified: (await gradleCacheDir.stat()).modified,
        detectorName: name,
      ));
    }

    return items;
  }
}
