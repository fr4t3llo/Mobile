import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';

class CurrentlyPage extends StatefulWidget {
  const CurrentlyPage({super.key});

  @override
  State<CurrentlyPage> createState() => _CurrentlyPageState();
}

class _CurrentlyPageState extends State<CurrentlyPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      return Center(
        child: Text(
          textAlign: TextAlign.center,
          "Currently \n${value.city}",
          style: const TextStyle(
            fontFamily: 'my',
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );
    });
  }
}
