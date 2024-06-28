import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void clickMe() {
    debugPrint("Button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Calculator'),
          ),
          body: const Stack(
            children: [
              Column(
                children: [
                  TextField(),
                  TextField(),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
