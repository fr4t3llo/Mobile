import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            " Weekly\n${value.city}",
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 3, 193),
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          Text(
            value.location,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 3, 193),
              fontFamily: 'my',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      );
    });
  }
}
