import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          body: OrientationBuilder(builder: (context, orientation) {
            double containerWidth = orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width * 0.08;
            double containerHeight = orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.09
                : MediaQuery.of(context).size.height * 0.09;
            return Stack(
              fit: StackFit.expand,
              children: [
                const Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          readOnly: true,
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          readOnly: true,
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: AC');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    'AC',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: C');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red,
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    'C',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: +');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 241, 139, 7),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: -');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 241, 139, 7),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 7');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 8');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '8',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 9');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '9',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: x');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 241, 139, 7),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    'x',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 4');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 5');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 6');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: /');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 241, 139, 7),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '/',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 1');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 2');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 3');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: =');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 241, 139, 7),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '=',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 0');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: .');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 00');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('button pressed: 000');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(255, 145, 145, 145),
                                ),
                                width: containerWidth,
                                height: containerHeight,
                                child: const Center(
                                  child: Text(
                                    '000',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'my',
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
