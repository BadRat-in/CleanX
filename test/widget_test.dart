// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cleanx/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Initial UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CleanXApp());

    // Verify that the initial UI is correct.
    expect(find.text("Click 'Quick Scan' to start."), findsOneWidget);
    expect(find.text('Quick Scan'), findsOneWidget);
    expect(find.text('Deep Scan (Dev Tools)'), findsOneWidget);
  });
}
