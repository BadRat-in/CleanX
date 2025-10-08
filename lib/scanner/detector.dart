import '../scan_item.dart';

abstract class Detector {
  String get name;
  Future<List<ScanItem>> scan();
}
