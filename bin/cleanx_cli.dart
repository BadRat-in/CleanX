import 'dart:convert';
import 'dart:io';

import 'package:cleanx/scanner/scanner_engine.dart';
import 'package:args/args.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('scan', help: 'Scan for caches.')
    ..addFlag('clean', help: 'Clean caches found in a scan.')
    ..addOption('input', help: 'Input JSON file for the clean command.')
    ..addFlag('dry-run', help: 'Simulate a clean without deleting files.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help message.');

  final argResults = parser.parse(arguments);

  if (argResults['help']) {
    print(parser.usage);
    return;
  }

  if (argResults['scan']) {
    final scanner = ScannerEngine();
    final items = await scanner.scan();
    final json = items.map((item) => {
      'path': item.path,
      'size': item.sizeBytes,
      'detector': item.detectorName,
    }).toList();
    print(jsonEncode(json));
  } else if (argResults['clean']) {
    // Clean functionality will be implemented in a future step.
    print('Clean functionality is not yet implemented.');
  } else {
    print(parser.usage);
  }
}
