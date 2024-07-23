import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      return Text(
        textAlign: TextAlign.center,
        " Today\n${value.city}",
        style: const TextStyle(
            fontFamily: 'my', fontWeight: FontWeight.bold, fontSize: 26),
      );
    });
  }
}
