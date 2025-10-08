import 'package:cleanx/scanner/scan_item.dart';
import 'package:cleanx/scanner/scanner_engine.dart';
import 'package:cleanx/ui/widgets/custom_cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(const CleanDevApp());

class CleanDevApp extends StatelessWidget {
  const CleanDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'CleanDev',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeGreen,
        scaffoldBackgroundColor: Color(0xFF0B0E14), // deep background similar to CleanMyMac dark
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle:
              TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          textStyle: TextStyle(fontSize: 14),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scannerEngine = ScannerEngine();
  List<ScanItem> _scanItems = [];

  Future<void> _runQuickScan() async {
    final items = await _scannerEngine.scan();
    setState(() {
      _scanItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This is intentionally minimal — expand into real data-driven widgets.
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CleanDev'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _SummaryCard(scanItems: _scanItems),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: _runQuickScan,
                child: const Text('Quick Scan'),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                child: const Text('Deep Scan (Dev Tools)'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Expanded(child: _RecentActivityList(scanItems: _scanItems)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.scanItems});

  final List<ScanItem> scanItems;

  @override
  Widget build(BuildContext context) {
    final totalSize = scanItems.fold<int>(
        0, (previousValue, element) => previousValue + element.sizeBytes);
    final totalSizeInGB = totalSize / (1024 * 1024 * 1024);

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray.withAlpha((255 * 0.06).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(CupertinoIcons.trash, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reclaimable space', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text('${totalSizeInGB.toStringAsFixed(2)} GB',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Text('Analyze'),
          )
        ],
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList({required this.scanItems});

  final List<ScanItem> scanItems;

  @override
  Widget build(BuildContext context) {
    if (scanItems.isEmpty) {
      return const Center(
        child: Text("Click 'Quick Scan' to start."),
      );
    }
    return ListView.builder(
      itemCount: scanItems.length,
      itemBuilder: (context, index) {
        final item = scanItems[index];
        final sizeInMB = item.sizeBytes / (1024 * 1024);
        return CustomCupertinoListTile(
          title: Text(item.name),
          subtitle: Text(item.path),
          trailing: Text('${sizeInMB.toStringAsFixed(2)} MB'),
        );
      },
    );
  }
}
