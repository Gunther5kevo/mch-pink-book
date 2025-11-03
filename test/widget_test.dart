import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:mch_pink_book/presentation/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MCHPinkBookApp Widget Tests', () {
    testWidgets('App builds without crashing', (WidgetTester tester) async {
      // Run just the app widget inside ProviderScope
      await tester.pumpWidget(
        const ProviderScope(
          child: MCHPinkBookApp(),
        ),
      );

      // Allow widget tree to build
      await tester.pumpAndSettle();

      // Expect the MaterialApp to be found
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Splash screen is the initial screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MCHPinkBookApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that SplashScreen widget or text is shown
      expect(find.textContaining('Splash'), findsOneWidget,
          reason: 'Expected SplashScreen to appear initially');
    });
  });
}
