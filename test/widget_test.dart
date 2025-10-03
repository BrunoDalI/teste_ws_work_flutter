// Basic integration test for the main app
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:teste_ws_work_flutter/main.dart';

void main() {
  setUpAll(() {
    // Initialize ffi loader for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
  
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app loads and shows the car page
    expect(find.text('Carros Disponíveis'), findsOneWidget);
    
    // Wait for any async initialization
    await tester.pumpAndSettle();
  });
}
