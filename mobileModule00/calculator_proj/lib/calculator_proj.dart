import 'package:calculator_proj/buttons.dart';
import 'package:flutter/material.dart';

class FtCalculator extends StatefulWidget {
  const FtCalculator({super.key});

  @override
  State<FtCalculator> createState() => _FtCalculatorState();
}

class _FtCalculatorState extends State<FtCalculator> {
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
                // reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    '0.0',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'my',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                        // width: screenSize.width / 4,
                        // height: screenSize.height / 5,
                        child: createBtn(value),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget createBtn(value) {
    return Text(
      value,
      style: const TextStyle(color: Colors.amber),
    );
  }
}
