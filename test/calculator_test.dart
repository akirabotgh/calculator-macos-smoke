import 'package:calculator_macos_smoke/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('apply', () {
    test('adds', () => expect(apply(2, 3, Operation.add), 5));
    test('subtracts', () => expect(apply(5, 3, Operation.subtract), 2));
    test('multiplies', () => expect(apply(4, 3, Operation.multiply), 12));
    test('divides', () => expect(apply(9, 3, Operation.divide), 3));

    test('throws rather than returning Infinity on divide by zero', () {
      expect(
        () => apply(1, 0, Operation.divide),
        throwsA(isA<CalculationError>()),
      );
    });
  });

  group('formatResult', () {
    test('trims the trailing .0 on whole numbers', () {
      expect(formatResult(4), '4');
      expect(formatResult(-12), '-12');
    });

    test('keeps meaningful decimals', () {
      expect(formatResult(2.5), '2.5');
      expect(formatResult(1 / 3), '0.33333333');
    });

    test('reports non-finite values as an error rather than NaN', () {
      expect(formatResult(double.nan), 'Error');
      expect(formatResult(double.infinity), 'Error');
    });
  });

  group('CalculatorModel', () {
    late CalculatorModel model;
    setUp(() => model = CalculatorModel());

    test('starts at zero', () => expect(model.display, '0'));

    test('replaces the leading zero with the first digit', () {
      model.inputDigit('7');
      expect(model.display, '7');
    });

    test('adds two numbers', () {
      model.inputDigit('2');
      model.setOperation(Operation.add);
      model.inputDigit('3');
      model.equals();
      expect(model.display, '5');
    });

    test('chains operations using the running total', () {
      model.inputDigit('2');
      model.setOperation(Operation.add);
      model.inputDigit('3');
      model.setOperation(Operation.add);
      expect(model.display, '5');
      model.inputDigit('4');
      model.equals();
      expect(model.display, '9');
    });

    test('shows Error instead of Infinity when dividing by zero', () {
      model.inputDigit('8');
      model.setOperation(Operation.divide);
      model.inputDigit('0');
      model.equals();
      expect(model.display, 'Error');
    });

    test('accepts a single decimal point only', () {
      model.inputDigit('1');
      model.inputDecimalPoint();
      model.inputDecimalPoint();
      model.inputDigit('5');
      expect(model.display, '1.5');
    });

    test('clear resets pending state, not just the display', () {
      model.inputDigit('9');
      model.setOperation(Operation.add);
      model.clear();
      model.inputDigit('1');
      model.equals();
      expect(model.display, '1');
    });
  });
}
