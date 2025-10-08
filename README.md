# CleanX

A developer-first cleaning utility for macOS, built with Flutter.

## Features

- **Deep Scans:** CleanX scans for caches from a variety of developer tools, including Xcode, Node.js, Flutter, and more.
- **Customizable Cleaning:** Choose what to clean and how to clean it. Move files to the trash, delete them permanently, or back them up to a ZIP file.
- **CLI for Automation:** Use the command-line interface to integrate CleanX into your automated workflows.

## Getting Started

To get started with CleanX, you'll need to have Flutter installed. Then, you can clone the repository and run the app:

```bash
git clone https://github.com/Badrat-in/cleanx.git
cd cleanx
flutter run -d macos
```

## CLI Usage

The CleanX CLI allows you to scan and clean your system from the command line.

### Scan

To scan for caches, use the `scan` command:

```bash
dart run bin/cleanx_cli.dart --scan
```

This will output a JSON array of the caches that were found.

### Clean

To clean the caches, you can use the `clean` command with the output of the `scan` command:

```bash
dart run bin/cleanx_cli.dart --scan > caches.json
dart run bin/cleanx_cli.dart --clean --input caches.json
```

You can also use the `--dry-run` flag to see what would be cleaned without actually deleting any files:

```bash
dart run bin/cleanx_cli.dart --clean --input caches.json --dry-run
```
