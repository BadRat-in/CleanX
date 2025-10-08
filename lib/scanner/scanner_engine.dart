import 'package:cleanx/models/scan_item.dart';

import 'detector.dart';
import 'detectors/cocoapods_cache_detector.dart';
import 'detectors/flutter_cache_detector.dart';
import 'detectors/gradle_cache_detector.dart';
import 'detectors/homebrew_cache_detector.dart';
import 'detectors/node_cache_detector.dart';
import 'detectors/user_cache_detector.dart';
import 'detectors/xcode_cache_detector.dart';

class ScannerEngine {
  final List<Detector> _quickDetectors = [
    UserCacheDetector(),
  ];

  final List<Detector> _deepDetectors = [
    UserCacheDetector(),
    NodeCacheDetector(),
    FlutterCacheDetector(),
    XcodeCacheDetector(),
    GradleCacheDetector(),
    HomebrewCacheDetector(),
    CocoapodsCacheDetector(),
  ];

  Future<List<ScanItem>> scan() async {
    final allItems = <ScanItem>[];
    for (final detector in _quickDetectors) {
      final items = await detector.scan();
      allItems.addAll(items);
    }
    return allItems;
  }

  Future<List<ScanItem>> deepScan() async {
    final allItems = <ScanItem>[];
    for (final detector in _deepDetectors) {
      final items = await detector.scan();
      allItems.addAll(items);
    }
    return allItems;
  }
}
