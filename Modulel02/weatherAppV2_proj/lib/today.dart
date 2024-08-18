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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            " Today\n${value.city}",
            style: const TextStyle(
              color: Color.fromARGB(255, 211, 0, 169),
              fontFamily: 'my',
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          Text(
            value.location,
            style: const TextStyle(
              fontFamily: 'my',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 211, 0, 169),
              fontSize: 18,
            ),
          )
        ],
      );
    });
  }
}
