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
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "$n1$operation$n2".isEmpty ? "0" : "$n1$operation$n2",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'my',
                        fontSize: 30, 
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),  
            // SingleChildScrollView(
            //   reverse: true,
            //   child: Container(
            //     alignment: Alignment.bottomRight,
            //     padding: const EdgeInsets.all(12),
            //     child: Text(
            //       n2.isEmpty ? "0" : n2,
            //       style: const TextStyle(
            //           color: Colors.white,
            //           fontFamily: 'my',
            //           fontSize: 30,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
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
    );
  }

  void clickButton(String value) {
    setState(() {
      n1 += value;
      operation += value;
      n2 += value;
    });
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
                  fontFamily: 'my',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
