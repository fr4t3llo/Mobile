import 'package:calculator_proj/buttons.dart';
import 'package:flutter/material.dart';

class FtCalculator extends StatefulWidget {
  const FtCalculator({super.key});

  @override
  State<FtCalculator> createState() => _FtCalculatorState();
}

class _FtCalculatorState extends State<FtCalculator> {
  String n1 = "";
  String operation = "";
  String n2 = "";

  String expressionField = ""; // New variable to store full expression
  String resultField = ""; // New variable to store the result

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Calculator',
              style: TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
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
                      expressionField.isEmpty ? "0" : expressionField,
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
                    resultField.isEmpty ? "0" : resultField,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'my',
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Wrap(
                children: Buttons.buttonValues
                    .map((value) => SizedBox(
                          width: value == Buttons.number_0
                              ? screenSize.width / 2
                              : (screenSize.width / 4),
                          height: screenSize.width / 5,
                          child: createBtn(value),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void assignValue(String value) {
    if (value != Buttons.dot && int.tryParse(value) == null) {
      if (operation.isNotEmpty && n2.isNotEmpty) {
        calculate();
      }
      operation = value;
    } else if (n1.isEmpty || operation.isEmpty) {
      if (value == Buttons.dot && n1.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (n1.isEmpty || n1 == Buttons.dot)) {
        value = "0.";
      }
      n1 += value;
    } else if (n2.isEmpty || operation.isNotEmpty) {
      if (value == Buttons.dot && n2.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (n2.isEmpty || n2 == Buttons.number_0)) {
        //check before push
        value = "0.";
      }
      n2 += value;
    }
    if (value == Buttons.delete) {
      makeDelete(value);
    }
    updateFirstField();
    setState(() {});
  }

  void updateFirstField() {
    expressionField = "$n1$operation$n2";
    if (expressionField.isEmpty) {
      expressionField = "0";
    }
  }

  void clickButton(String value) {
    if ((value == Buttons.add ||
            value == Buttons.subtract ||
            value == Buttons.divide ||
            value == Buttons.multiply) &&
        (n1.isEmpty)) {
      return;
    }
    if (value == Buttons.calculate) {
      calculate();
      return;
    }
    if (value == Buttons.delete) {
      makeDelete(value);
      return;
    }
    if (value == Buttons.clear) {
      clear(value);
      return;
    }
    assignValue(value);
  }

  void calculate() {
    if (n1.isEmpty) return;
    if (n2.isEmpty) return;
    if (operation.isEmpty) return;

    final double number_1 = double.parse(n1);
    final double number_2 = double.parse(n2);

    var result = 0.0;

    switch (operation) {
      case Buttons.add:
        result = number_1 + number_2;
        break;
      case Buttons.multiply:
        result = number_1 * number_2;
        break;
      case Buttons.subtract:
        result = number_1 - number_2;
        break;
      case Buttons.divide:
        result = number_1 / number_2;
        break;
      default:
    }
    setState(() {
      resultField = result.toString();
      if (resultField.endsWith(".0")) {
        resultField = resultField.substring(0, resultField.length - 2);
      }
      n2 = "";
      n1 = "";
      operation = "";
      updateFirstField();
    });
  }

  void clear(value) {
    setState(() {
      n1 = "";
      operation = "";
      n2 = "";
      expressionField = "";
      resultField = "";
    });
  }

  void makeDelete(value) {
    if (n2.isNotEmpty) {
      n2 = n2.substring(0, n2.length - 1);
    } else if (operation.isNotEmpty) {
      operation = "";
    } else if (n1.isNotEmpty) {
      n1 = n1.substring(0, n1.length - 1);
    }
    updateFirstField();
    setState(() {});
  }

  Widget createBtn(value) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: [Buttons.delete, Buttons.clear].contains(value)
            ? Colors.red
            : [
                Buttons.add,
                Buttons.divide,
                Buttons.multiply,
                Buttons.subtract,
                Buttons.calculate
              ].contains(value)
                ? Colors.orange
                : const Color.fromARGB(255, 106, 106, 106),
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
                // fontFamily: 'my',
                fontWeight: FontWeight.bold,
                fontSize: 33,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
