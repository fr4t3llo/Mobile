import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void clickMe() {
    print("button Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'a simple text',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: clickMe,
                    child: const Text(
                      'Click me',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
