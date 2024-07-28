import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_proj/viewmodels/main_provider.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      return Text(
        textAlign: TextAlign.center,
        " Weekly\n${value.city}",
        style: const TextStyle(
            fontFamily: 'my', fontWeight: FontWeight.bold, fontSize: 26),
      );
    });
  }
}
