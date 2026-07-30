import 'package:flutter/material.dart';

import 'calculator.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B6EA5)),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorModel _model = CalculatorModel();

  void _run(VoidCallback action) => setState(action);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                child: Text(
                  _model.display,
                  key: const Key('display'),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _Keypad(model: _model, onAction: _run),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.model, required this.onAction});

  final CalculatorModel model;
  final void Function(VoidCallback) onAction;

  @override
  Widget build(BuildContext context) {
    final List<List<_Key>> rows = <List<_Key>>[
      <_Key>[
        _Key('C', model.clear, emphasis: true),
        _Key('/', () => model.setOperation(Operation.divide), emphasis: true),
        _Key('x', () => model.setOperation(Operation.multiply), emphasis: true),
        _Key('-', () => model.setOperation(Operation.subtract), emphasis: true),
      ],
      <_Key>[
        _Key('7', () => model.inputDigit('7')),
        _Key('8', () => model.inputDigit('8')),
        _Key('9', () => model.inputDigit('9')),
        _Key('+', () => model.setOperation(Operation.add), emphasis: true),
      ],
      <_Key>[
        _Key('4', () => model.inputDigit('4')),
        _Key('5', () => model.inputDigit('5')),
        _Key('6', () => model.inputDigit('6')),
        _Key('=', model.equals, emphasis: true),
      ],
      <_Key>[
        _Key('1', () => model.inputDigit('1')),
        _Key('2', () => model.inputDigit('2')),
        _Key('3', () => model.inputDigit('3')),
        _Key('0', () => model.inputDigit('0')),
      ],
      <_Key>[_Key('.', model.inputDecimalPoint)],
    ];

    return Column(
      children: rows
          .map(
            (List<_Key> row) => Expanded(
              child: Row(
                children: row
                    .map(
                      (_Key key) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FilledButton(
                            key: Key('key-${key.label}'),
                            style: key.emphasis
                                ? null
                                : FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                  ),
                            onPressed: () => onAction(key.onTap),
                            child: Text(
                              key.label,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Key {
  const _Key(this.label, this.onTap, {this.emphasis = false});

  final String label;
  final VoidCallback onTap;
  final bool emphasis;
}
