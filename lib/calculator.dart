/// Pure calculator logic, deliberately free of any Flutter import so it can be
/// unit tested without a widget harness.
library;

enum Operation { add, subtract, multiply, divide }

class CalculationError implements Exception {
  const CalculationError(this.message);
  final String message;

  @override
  String toString() => 'CalculationError: $message';
}

/// Applies [operation] to [left] and [right].
///
/// Division by zero throws rather than returning infinity or NaN: a calculator
/// that silently displays "Infinity" has given a wrong answer confidently.
double apply(double left, double right, Operation operation) {
  switch (operation) {
    case Operation.add:
      return left + right;
    case Operation.subtract:
      return left - right;
    case Operation.multiply:
      return left * right;
    case Operation.divide:
      if (right == 0) {
        throw const CalculationError('cannot divide by zero');
      }
      return left / right;
  }
}

/// Formats a result for display, trimming the trailing '.0' on whole numbers so
/// that 2 + 2 reads as "4" rather than "4.0".
String formatResult(double value) {
  if (value.isNaN || value.isInfinite) {
    return 'Error';
  }
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toStringAsFixed(0);
  }
  final String text = value.toStringAsFixed(8);
  return text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// The state machine behind the keypad.
class CalculatorModel {
  String _display = '0';
  double? _pending;
  Operation? _operation;
  bool _startNewEntry = true;

  String get display => _display;

  void inputDigit(String digit) {
    if (_startNewEntry) {
      _display = digit;
      _startNewEntry = false;
    } else {
      _display = _display == '0' ? digit : '$_display$digit';
    }
  }

  void inputDecimalPoint() {
    if (_startNewEntry) {
      _display = '0.';
      _startNewEntry = false;
    } else if (!_display.contains('.')) {
      _display = '$_display.';
    }
  }

  void setOperation(Operation operation) {
    // Chaining (2 + 3 + 4) resolves the outstanding operation first, so the
    // display always reflects the running total.
    if (_operation != null && !_startNewEntry) {
      equals();
    }
    _pending = double.tryParse(_display) ?? 0;
    _operation = operation;
    _startNewEntry = true;
  }

  void equals() {
    final Operation? operation = _operation;
    final double? pending = _pending;
    if (operation == null || pending == null) {
      return;
    }
    final double current = double.tryParse(_display) ?? 0;
    try {
      _display = formatResult(apply(pending, current, operation));
    } on CalculationError {
      _display = 'Error';
    }
    _pending = null;
    _operation = null;
    _startNewEntry = true;
  }

  void clear() {
    _display = '0';
    _pending = null;
    _operation = null;
    _startNewEntry = true;
  }
}
