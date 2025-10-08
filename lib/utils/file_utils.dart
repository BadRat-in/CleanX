import 'dart:io';

import 'package:flutter/foundation.dart';

Future<int> getDirectorySize(Directory dir) async {
  int size = 0;
  final completer = Completer<int>();
  
  try {
    final files = dir.list(recursive: true, followLinks: false);
    await for (final file in files) {
      if (file is File) {
        try {
          size += await file.length();
        } catch (e) {
          debugPrint("Could not access file: ${file.path}");
        }
      }
    }
  } catch (e) {
    debugPrint("Could not list directory: ${dir.path}");
  }
  
  return size;
}
