// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:developer';

import 'package:device_preview_plus/device_preview_plus.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weatherappv2_proj/currently.dart';
import 'package:weatherappv2_proj/today.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:weatherappv2_proj/weekly.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:geolocator/geolocator.dart';
// Ensure you have the correct package for icons

void main() {
  runApp(
    DevicePreview(
        // enabled: true, // Enable DevicePreview if necessary
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
        debugPrint(_locationMessage);
        get_city(position);
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
    }
  }

  Future get_city(Position p) async {
    var response = await http.Client().get(Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${p.latitude}&lon=${p.longitude}&addressdetails=1"));
    log(jsonDecode(response.body)["address"]["city"]);
    context
        .read<MainProvider>()
        .setCity(jsonDecode(response.body)["address"]["city"]);
    // log(response.body);
  }

  int _index = 0;
  String location = '';
  final List<String> _cities = [
  'London', 'New York', 'Tokyo', 'Paris', 'Dubai',
  'Singapore', 'Barcelona', 'Mumbai', 'Sydney', 'Toronto',
  'Berlin', 'Bangkok', 'Istanbul', 'Rome', 'Amsterdam'
];
  TextEditingController text1 = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  final SearchController searchController = SearchController();
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
                child: SearchAnchor(
  searchController: searchController,
  builder: (BuildContext context, SearchController controller) {
    return SearchBar(
      controller: controller,
      padding: const MaterialStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16.0)
      ),
      onTap: () {
        controller.openView();
      },
      leading: const Icon(Icons.search),
      hintText: 'Search cities...',
    );
  },
  viewBuilder: (Iterable<Widget> suggestions) {
    return SearchView(
      suggestions: suggestions,
    );
  },
  suggestionsBuilder: (BuildContext context, SearchController controller) {
    if (controller.text.isEmpty) {
      return _cities.map((city) => ListTile(
        title: Text(city),
        onTap: () {
          controller.closeView(city);
          context.read<MainProvider>().setCity(city);
        },
      )).toList();
    }

    final keyword = controller.text.toLowerCase();
    final filtered = _cities
        .where((city) => city.toLowerCase().contains(keyword))
        .toList();
    
    if (filtered.isEmpty) {
      return [
        const ListTile(
          title: Text('No cities found'),
          enabled: false,
        )
      ];
    }
    
    return filtered.map((filteredCity) => ListTile(
      title: Text(filteredCity),
      onTap: () {
        controller.closeView(filteredCity);
        context.read<MainProvider>().setCity(filteredCity);
      },
    )).toList();
  },
)
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                      onPressed: () {
                        _getCurrentLocation();
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
class SearchView extends StatelessWidget {
  final Iterable<Widget> suggestions;

  SearchView({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: suggestions.toList(),
    );
  }
}
  

  