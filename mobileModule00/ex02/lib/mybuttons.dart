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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          color: buttonColor,
        ),
        width: 20,
        height: 20,
        child: Center(child: buttonText,),
        // color: Colors.black,
      ),
    );
  }
}
