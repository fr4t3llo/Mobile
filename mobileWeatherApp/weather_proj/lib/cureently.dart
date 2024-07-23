import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_proj/viewmodels.dart/main_provider.dart';

class CureentlyPage extends StatefulWidget {
  const CureentlyPage({super.key});

  @override
  State<CureentlyPage> createState() => _CureentlyPageState();
}

class _CureentlyPageState extends State<CureentlyPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      return Text(
        textAlign: TextAlign.center,
        "Currently \n${value.city}",
        style: const TextStyle(
          fontFamily: 'my',
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      );
    });
  }
}
