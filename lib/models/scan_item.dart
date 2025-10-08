enum FileType { file, directory }
enum RiskLevel { low, medium, high }

class ScanItem {
  final String id;
  final String path;
  final String name;
  final FileType type; // file | directory
  final int sizeBytes;
  final DateTime lastModified;
  final String detectorName;
  final RiskLevel risk; // low/medium/high
  bool selected;
  Map<String, dynamic> metadata; // e.g. childCount

  ScanItem({
    required this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.sizeBytes,
    required this.lastModified,
    required this.detectorName,
    this.risk = RiskLevel.low,
    this.selected = true,
    this.metadata = const {},
  });
}
