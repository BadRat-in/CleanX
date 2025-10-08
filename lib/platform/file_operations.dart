import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';

class FileOperations {
  static const platform = MethodChannel('com.cleanx.app/file_operations');

  static Future<bool> moveToTrash(String filePath) async {
    try {
      final bool result =
          await platform.invokeMethod('moveToTrash', {'filePath': filePath});
      return result;
    } on PlatformException catch (e) {
      print("Failed to move file to trash: '${e.message}'.");
      return false;
    }
  }

  static Future<bool> permanentDelete(String filePath) async {
    try {
      final bool result = await platform
          .invokeMethod('permanentDelete', {'filePath': filePath});
      return result;
    } on PlatformException catch (e) {
      print("Failed to permanently delete file: '${e.message}'.");
      return false;
    }
  }

  static Future<void> backupToZip(
      List<String> paths, String backupPath) async {
    final encoder = ZipFileEncoder();
    await encoder.create(backupPath);
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) {
        await encoder.addFile(file);
      } else {
        final dir = Directory(path);
        if (await dir.exists()) {
          await encoder.addDirectory(dir);
        }
      }
    }
    encoder.close();
  }
}
