import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class FtCalculator extends StatefulWidget {
  const FtCalculator({super.key});

  @override
  State<FtCalculator> createState() => _FtCalculatorState();
}

class _FtCalculatorState extends State<FtCalculator> {
  String expression = "";
  String result = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return (screenSize.height > screenSize.width)
        ? MaterialApp(
            home: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: const Text(
                    'Calculator',
                    style: TextStyle(
                        fontFamily: 'my', fontWeight: FontWeight.bold),
                  ),
                ),
                backgroundColor: Colors.black,
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            expression.isEmpty ? "0" : expression,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'my',
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          result.isEmpty ? "0" : result,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'my',
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Wrap(
                        children: _buttons
                            .map((value) => SizedBox(
                                  width: value == '0'
                                      ? screenSize.width / 2
                                      : (screenSize.width / 4),
                                  height: screenSize.width / 5,
                                  child: createBtn(value),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: const Text(
                  'Calculator',
                  style:
                      TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          expression.isEmpty ? "0" : expression,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'my',
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    // reverse: true,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        result.isEmpty ? "0" : result,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'my',
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Wrap(
                    children: _buttons2
                        .map((value) => SizedBox(
                              width: value == '0'
                                  ? screenSize.width / 5
                                  : (screenSize.width / 6),
                              height: screenSize.height / 7,
                              child: createBtn(value),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          );
  }

  void clickButton(String value) {
    if (value == 'AC') {
      clear();
    } else if (value == 'C') {
      backspace();
    } else if (value == '=') {
      evaluate();
    } else {
      updateExpression(value);
    }
  }

  void updateExpression(String value) {
    setState(() {
      expression += value;
    });
  }

  void backspace() {
    setState(() {
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
      }
    });
  }

  void clear() {
    setState(() {
      expression = "";
      result = "";
    });
  }

  void evaluate() {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double resultValue = exp.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        result = resultValue.toString();
        if (result.endsWith('.0')) {
          result = result.substring(0, result.length - 2);
        }
      });
    } catch (e) {
      setState(() {
        result = "Error";
      });
    }
  }

  Widget createBtn(String value) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: _getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.white10)),
        child: InkWell(
          onTap: () => clickButton(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 33,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(String value) {
    if (value == 'AC' || value == 'C') {
      return Colors.red;
    } else if (['+', '-', '*', '/'].contains(value) || value == '=') {
      return Colors.orange;
    } else {
      return const Color.fromARGB(255, 106, 106, 106);
    }
  }

  final List<String> _buttons = [
    'AC',
    'C',
    '/',
    '*',
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '0',
    '.',
  ];
  final List<String> _buttons2 = [
    '7',
    '8',
    '9',
    'C',
    'AC',
    '/',
    '4',
    '5',
    '6',
    '*',
    '-',
    '+',
    '1',
    '2',
    '3',
    '0',
    '.',
    '=',
  ];
}
