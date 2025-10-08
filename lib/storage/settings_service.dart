import 'package:shared_preferences/shared_preferences.dart';

import '../ui/screens/settings_screen.dart';

class SettingsService {
  static const _deleteActionKey = 'delete_action';

  Future<DeleteAction> getDeleteAction() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_deleteActionKey) ?? 0;
    return DeleteAction.values[index];
  }

  Future<void> setDeleteAction(DeleteAction action) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_deleteActionKey, action.index);
  }
}
