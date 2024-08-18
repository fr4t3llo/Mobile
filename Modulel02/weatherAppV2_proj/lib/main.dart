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
import 'package:geolocator/geolocator.dart';
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
  String _locationMessage = "Press the button to get location";

  //* to get the location for the device *//
  Future<void> _getCurrentLocation() async {
    try {
      // Check for permissions
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        setState(() {
          _locationMessage = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = "Location permissions are permanently denied.";
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationMessage =
            "Lat: ${position.latitude}, Long: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
    }
  }

  int _index = 0;
  String location = '';
  TextEditingController text1 = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget> content = const [CurrentlyPage(), TodayPage(), WeeklyPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<MainProvider>(
          builder: (context, value, child) => Scaffold(
            body: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              children: content,
              onPageChanged: (value) {
                setState(() {
                  _index = value;
                });
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 0, 211, 158),
              selectedFontSize: 15,
              unselectedFontSize: 12,
              currentIndex: _index,
              items: const [
                BottomNavigationBarItem(
                  label: 'Currently',
                  icon: Icon(
                    Iconsax.calendar_edit,
                    color: Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Today',
                  icon: Icon(
                    Iconsax.calendar,
                    color: Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Weekly',
                  icon: Icon(
                    Iconsax.calendar_circle,
                    color: Colors.black,
                  ),
                ),
              ],
              unselectedItemColor: Colors.black,
              onTap: (int newIndex) {
                setState(() {
                  _index = newIndex;
                  _pageController.jumpToPage(_index);
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
                  onChanged: (vale) {
                    value.setCity(vale);
                  },
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
                      onPressed: () async {
                        // showSearch(context: context, delegate: );
                        await _getCurrentLocation();
                        value.setLosction(_locationMessage);
                      },
                      icon: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
