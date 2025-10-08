import 'dart:io';

import 'package:cleanx/platform/file_operations.dart';
import 'package:cleanx/scanner/scan_item.dart';
import 'package:cleanx/scanner/scanner_engine.dart';
import 'package:cleanx/storage/settings_service.dart';
import 'package:cleanx/ui/screens/settings_screen.dart';
import 'package:cleanx/ui/widgets/custom_cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() => runApp(const CleanXApp());

class CleanXApp extends StatelessWidget {
  const CleanXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'CleanX',
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
  final _settingsService = SettingsService();
  List<ScanItem> _scanItems = [];
  DeleteAction _deleteAction = DeleteAction.trash;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final deleteAction = await _settingsService.getDeleteAction();
    setState(() {
      _deleteAction = deleteAction;
    });
  }

  Future<void> _runQuickScan() async {
    final items = await _scannerEngine.scan();
    setState(() {
      _scanItems = items;
    });
  }

  Future<void> _clean() async {
    final selectedItems = _scanItems.where((item) => item.selected).toList();
    if (selectedItems.isEmpty) {
      return;
    }

    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Clean'),
        content: Text(
            'Are you sure you want to clean ${selectedItems.length} items?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Clean'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    switch (_deleteAction) {
      case DeleteAction.trash:
        for (final item in selectedItems) {
          await FileOperations.moveToTrash(item.path);
        }
        break;
      case DeleteAction.permanent:
        for (final item in selectedItems) {
          await FileOperations.permanentDelete(item.path);
        }
        break;
      case DeleteAction.backup:
        final backupDir = Directory(p.join(
            (await getApplicationDocumentsDirectory()).path, 'backups'));
        if (!await backupDir.exists()) {
          await backupDir.create(recursive: true);
        }
        final backupPath =
            p.join(backupDir.path, 'backup-${DateTime.now().toIso8601String()}.zip');
        await FileOperations.backupToZip(
            selectedItems.map((i) => i.path).toList(), backupPath);
        for (final item in selectedItems) {
          await FileOperations.moveToTrash(item.path);
        }
        break;
    }
    _runQuickScan();
  }

  @override
  Widget build(BuildContext context) {
    // This is intentionally minimal — expand into real data-driven widgets.
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('CleanX'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings),
          onPressed: () async {
            final newDeleteAction = await Navigator.push<DeleteAction>(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    SettingsScreen(initialDeleteAction: _deleteAction),
              ),
            );
            if (newDeleteAction != null) {
              await _settingsService.setDeleteAction(newDeleteAction);
              setState(() {
                _deleteAction = newDeleteAction;
              });
            }
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _SummaryCard(scanItems: _scanItems),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton.filled(
                    onPressed: _runQuickScan,
                    child: const Text('Quick Scan'),
                  ),
                  const SizedBox(width: 12),
                  CupertinoButton(
                    onPressed: _clean,
                    child: const Text('Clean'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                child: const Text('Deep Scan (Dev Tools)'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: _GroupedScanResults(
                scanItems: _scanItems,
                onItemSelectionChanged: (item, selected) {
                  setState(() {
                    item.selected = selected;
                  });
                },
              )),
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
        color: CupertinoColors.extraLightBackgroundGray
            .withAlpha((255 * 0.06).round()),
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

class _GroupedScanResults extends StatelessWidget {
  const _GroupedScanResults(
      {required this.scanItems, required this.onItemSelectionChanged});

  final List<ScanItem> scanItems;
  final Function(ScanItem, bool) onItemSelectionChanged;

  @override
  Widget build(BuildContext context) {
    if (scanItems.isEmpty) {
      return const Center(
        child: Text("Click 'Quick Scan' to start."),
      );
    }

    final groupedItems = <String, List<ScanItem>>{};
    for (final item in scanItems) {
      if (groupedItems.containsKey(item.detectorName)) {
        groupedItems[item.detectorName]!.add(item);
      } else {
        groupedItems[item.detectorName] = [item];
      }
    }

    return ListView.builder(
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final detectorName = groupedItems.keys.elementAt(index);
        final items = groupedItems[detectorName]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                detectorName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final sizeInMB = item.sizeBytes / (1024 * 1024);
                return CustomCupertinoListTile(
                  leading: CupertinoCheckbox(
                    value: item.selected,
                    onChanged: (value) {
                      onItemSelectionChanged(item, value ?? false);
                    },
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.path),
                  trailing: Text('${sizeInMB.toStringAsFixed(2)} MB'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
