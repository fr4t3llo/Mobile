import 'package:flutter/material.dart';
import 'mybuttons.dart';

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
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Calculator',
              style: TextStyle(fontFamily: 'my'),
            ),
          ),
          body: SafeArea(
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const Mybuttons(
                          buttonText: Text(
                            'AC',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 1) {
                        return const Mybuttons(
                          buttonText: Text(
                            'C',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 221, 15, 0),
                        );
                      }
                      if (index == 2) {
                        return const Mybuttons(
                          buttonText: Text(
                            '+',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 241, 139, 7),
                        );
                      }
                      if (index == 3) {
                        return const Mybuttons(
                          buttonText: Text(
                            '-',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 241, 139, 7),
                        );
                      }
                      if (index == 4) {
                        return const Mybuttons(
                          buttonText: Text(
                            '7',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 5) {
                        return const Mybuttons(
                          buttonText: Text(
                            '8',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 6) {
                        return const Mybuttons(
                          buttonText: Text(
                            '9',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 7) {
                        return const Mybuttons(
                          buttonText: Text(
                            '/',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 241, 139, 7),
                        );
                      }
                      if (index == 8) {
                        return const Mybuttons(
                          buttonText: Text(
                            '4',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 9) {
                        return const Mybuttons(
                          buttonText: Text(
                            '5',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 10) {
                        return const Mybuttons(
                          buttonText: Text(
                            '6',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 11) {
                        return const Mybuttons(
                          buttonText: Text(
                            'x',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 241, 139, 7),
                        );
                      }
                      if (index == 12) {
                        return const Mybuttons(
                          buttonText: Text(
                            '1',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 13) {
                        return const Mybuttons(
                          buttonText: Text(
                            '2',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 14) {
                        return const Mybuttons(
                          buttonText: Text(
                            '3',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 15) {
                        return const Mybuttons(
                          buttonText: Text(
                            '=',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 241, 139, 7),
                        );
                      }
                      if (index == 16) {
                        return const Mybuttons(
                          buttonText: Text(
                            '0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 17) {
                        return const Mybuttons(
                          buttonText: Text(
                            '.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 18) {
                        return const Mybuttons(
                          buttonText: Text(
                            '00',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      if (index == 19) {
                        return const Mybuttons(
                          buttonText: Text(
                            '000',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontFamily: 'my'),
                          ),
                          buttonColor: Color.fromARGB(255, 145, 145, 145),
                        );
                      }
                      return null;
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
