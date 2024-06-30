import 'package:flutter/material.dart';

class Mybuttons extends StatelessWidget {
  const Mybuttons({
    super.key,
    required this.buttonText,
    required this.buttonColor,
  });

  final Text buttonText;
  final Color buttonColor;
  // final Color textColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double buttonSize =
            constraints.maxWidth / 2 - 16.0; // calculate the button size
        return GestureDetector(
          onTap: () {
            debugPrint('button pressed: ${buttonText.data}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
              color: buttonColor,
            ),
            width: buttonSize,
            height: buttonSize,
            child: Center(
              child: buttonText,
            ),
            // color: Colors.black,
          ),
        );
      },
    );
  }
}
