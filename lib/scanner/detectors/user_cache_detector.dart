import 'dart:io';

import 'package:path/path.dart' as p;

import '../scan_item.dart';

class UserCacheDetector {
  Future<List<ScanItem>> scan() async {
    // For now, we'll return hardcoded data.
    // In the future, this will scan the file system.
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      return [];
    }

    final cachesPath = p.join(homeDir, 'Library', 'Caches');
    final logsPath = p.join(homeDir, 'Library', 'Logs');

    return [
      ScanItem(
        id: 'user_caches',
        path: cachesPath,
        name: 'User Caches',
        type: FileType.directory,
        sizeBytes: 1024 * 1024 * 123, // 123 MB
        lastModified: DateTime.now().subtract(const Duration(days: 10)),
        detectorName: 'UserCacheDetector',
      ),
      ScanItem(
        id: 'user_logs',
        path: logsPath,
        name: 'User Logs',
        type: FileType.directory,
        sizeBytes: 1024 * 1024 * 45, // 45 MB
        lastModified: DateTime.now().subtract(const Duration(days: 5)),
        detectorName: 'UserCacheDetector',
      ),
    ];
  }
}
