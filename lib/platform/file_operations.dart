import 'package:flutter/services.dart';

class FileOperations {
  static const platform = MethodChannel('com.cleandev.app/file_operations');

  static Future<bool> moveToTrash(String filePath) async {
    try {
      final bool result = await platform.invokeMethod('moveToTrash', {'filePath': filePath});
      return result;
    } on PlatformException catch (e) {
      print("Failed to move file to trash: '${e.message}'.");
      return false;
    }
  }
}
