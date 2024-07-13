import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:iconsax/iconsax.dart";
// Ensure you have the correct package for icons

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview if necessary
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder:
            DevicePreview.appBuilder, // Ensure DevicePreview is used properly
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25)),
                // title: const CupertinoSearchTextField(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.search_rounded),
                        ),
                        Text(
                          'search',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 88, 88, 88),
                            fontFamily: 'my',
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                            child: Text(
                          'Go',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'my',
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
