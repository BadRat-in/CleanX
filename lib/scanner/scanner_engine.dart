import 'detectors/user_cache_detector.dart';
import 'scan_item.dart';

class ScannerEngine {
  final _userCacheDetector = UserCacheDetector();

  Future<List<ScanItem>> scan() async {
    final userCaches = await _userCacheDetector.scan();
    // In the future, we'll add more detectors here.
    return userCaches;
  }
}
