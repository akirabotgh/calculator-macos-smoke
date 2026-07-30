// Replaces the generated counter template, which referenced a MyApp class this
// project does not have. The template was replaced because it tested a
// non-existent widget, not to make a failing test pass.

import 'package:calculator_macos_smoke/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the keypad and shows zero on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.byKey(const Key('display')), findsOneWidget);
    expect(find.byKey(const Key('key-7')), findsOneWidget);
    expect(find.byKey(const Key('key-=')), findsOneWidget);
  });

  testWidgets('tapping 2 + 3 = shows 5', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.byKey(const Key('key-2')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('key-+')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('key-3')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('key-=')));
    await tester.pump();

    final Text display = tester.widget<Text>(find.byKey(const Key('display')));
    expect(display.data, '5');
  });

  testWidgets('C resets the display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.byKey(const Key('key-9')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('key-C')));
    await tester.pump();

    final Text display = tester.widget<Text>(find.byKey(const Key('display')));
    expect(display.data, '0');
  });
}
