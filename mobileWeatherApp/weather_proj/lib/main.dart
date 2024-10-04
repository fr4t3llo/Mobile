// ignore: depend_on_referenced_packages
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:weather_proj/currently.dart';
import 'package:weather_proj/today.dart';
import 'package:weather_proj/viewmodels/main_provider.dart';
import 'package:weather_proj/weekly.dart';
// Ensure you have the correct package for icons

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;
  String location = '';
  TextEditingController text1 = TextEditingController();
  List<Widget> content = const [
    CurrentlyPage(),
    TodayPage(),
    WeeklyPage()

    // Text(
    //   'Currently',
    //   style: TextStyle(
    //     fontFamily: 'my',
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // ),
    // Text(
    //   'Today',
    //   style: TextStyle(
    //     fontFamily: 'my',
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // ),
    // Text(
    //   'Weekly',
    //   style: TextStyle(
    //     fontFamily: 'my',
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // ),
    // Text(
    //   '',
    //   style: TextStyle(
    //     fontFamily: 'my',
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      
        home: SafeArea(
          child: Consumer<MainProvider>(
            builder: (context, value, child) => Scaffold(
              body: Center(child: content[_index]),
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
                  child: TextField(
                    controller: text1,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                    ],
                    style: const TextStyle(
                        fontFamily: 'my', fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search location... ex:  Khouribga',
                        hintStyle: TextStyle(
                            fontFamily: 'my', fontWeight: FontWeight.w100)),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            String newValue = text1.text;
                            value.setCity(text1.text);
                            debugPrint(newValue);
                            // content[_index] = Text(
                            //   newValue.isEmpty
                            //       ? 'No Location Provided'
                            //       : newValue,
                            //   style: const TextStyle(
                            //     fontFamily: 'my',
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 25,
                            //   ),
                            // );
                          });
                        },
                        icon: const Icon(
                          Icons.my_location_rounded,
                          color: Colors.black,
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
