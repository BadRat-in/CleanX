import 'detector.dart';
import 'detectors/flutter_cache_detector.dart';
import 'detectors/node_cache_detector.dart';
import 'detectors/user_cache_detector.dart';
import 'detectors/xcode_cache_detector.dart';
import 'package:cleanx/models/scan_item.dart';

class ScannerEngine {
  final List<Detector> _detectors = [
    UserCacheDetector(),
    NodeCacheDetector(),
    FlutterCacheDetector(),
    XcodeCacheDetector(),
  ];

  Future<List<ScanItem>> scan() async {
    final allItems = <ScanItem>[];
    for (final detector in _detectors) {
      final items = await detector.scan();
      allItems.addAll(items);
    }
    return allItems;
  Future<List<ScanItem>> deepScan() async {
    // For now, this is the same as a quick scan.
    // In the future, we'll add more detectors here.
    return scan();
  }
}
