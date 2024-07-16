import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;
  TextEditingController textController = TextEditingController();
  List<String> centerText = [
    'Currently',
    'Today',
    'Weekly',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  centerText[_index],
                  style: TextStyle(
                    fontFamily: 'my',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: textController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                  ],
                  style: const TextStyle(
                      fontFamily: 'my', fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search location... ex: Khouribga',
                      hintStyle: TextStyle(
                          fontFamily: 'my', fontWeight: FontWeight.w100)),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            items: const [
              BottomNavigationBarItem(
                label: 'Currently',
                icon: Icon(Iconsax.calendar_edit),
              ),
              BottomNavigationBarItem(
                label: 'Today',
                icon: Icon(Iconsax.calendar),
              ),
              BottomNavigationBarItem(
                label: 'Weekly',
                icon: Icon(Iconsax.calendar_circle),
              ),
            ],
            onTap: (int newIndex) {
              setState(() {
                _index = newIndex;
              });
            },
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 211, 158),
            title: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                      ],
                      style: const TextStyle(
                          fontFamily: 'my', fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search location... ex: Khouribga',
                          hintStyle: TextStyle(
                              fontFamily: 'my', fontWeight: FontWeight.w100)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // Update the centerText based on the TextField value
                        centerText[_index] = textController.text.isEmpty
                            ? 'No Location Provided'
                            : textController.text;
                      });
                    },
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
