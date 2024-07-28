// ignore: depend_on_referenced_packages
import 'package:device_preview_plus/device_preview_plus.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/currently.dart';
import 'package:weatherappv2_proj/today.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:weatherappv2_proj/weekly.dart';
// Ensure you have the correct package for icons

void main() {
  runApp(
    DevicePreview(
        enabled: true, // Enable DevicePreview if necessary
        builder: (context) => MultiProvider(providers: [
              ChangeNotifierProvider(create: (_) => MainProvider()),
            ], child: const MyApp())
        // Wrap your app
        ),
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
  List<Widget> content = const [CurrentlyPage(), TodayPage(), WeeklyPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder:
            DevicePreview.appBuilder, // Ensure DevicePreview is used properly
        home: Consumer<MainProvider>(
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
        ));
  }
}
