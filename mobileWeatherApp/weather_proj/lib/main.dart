import 'package:device_preview_plus/device_preview_plus.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
// Ensure you have the correct package for icons

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview if necessary
      builder: (context) => const MyApp(), // Wrap your app
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

  List<Widget> content = const [
    Icon(Iconsax.timer),
    Icon(Iconsax.timer4),
    Icon(Iconsax.timer5),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder:
            DevicePreview.appBuilder, // Ensure DevicePreview is used properly
        home: SafeArea(
          child: Scaffold(
            body: Center(child: content[_index]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _index,
              items: [],
            ),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 211, 158),
              title: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                  ],
                  style: const TextStyle(
                      fontFamily: 'my', fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search : Khouribga!',
                      hintStyle: TextStyle(
                          fontFamily: 'my', fontWeight: FontWeight.w100)),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                      onPressed: () {},
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
