import 'package:device_preview_plus/device_preview_plus.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:iconsax/iconsax.dart";
import 'package:weather_proj/searchpage.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder:
            DevicePreview.appBuilder, // Ensure DevicePreview is used properly
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 211, 158),
              title: const Padding(
                padding: EdgeInsets.only(top: 6, bottom: 6),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search : Khouribga',
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
