import 'package:flutter/cupertino.dart';

enum DeleteAction { trash, permanent, backup }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.initialDeleteAction});

  final DeleteAction initialDeleteAction;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DeleteAction _deleteAction;

  @override
  void initState() {
    super.initState();
    _deleteAction = widget.initialDeleteAction;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Default Delete Action'),
            const SizedBox(height: 10),
            CupertinoSlidingSegmentedControl<DeleteAction>(
              groupValue: _deleteAction,
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _deleteAction = value;
                  });
                  Navigator.pop(context, _deleteAction);
                }
              },
              children: const {
                DeleteAction.trash: Text('Move to Trash'),
                DeleteAction.permanent: Text('Permanent Delete'),
                DeleteAction.backup: Text('Backup to ZIP'),
              },
            ),
          ],
        ),
      ),
    );
  }
}
