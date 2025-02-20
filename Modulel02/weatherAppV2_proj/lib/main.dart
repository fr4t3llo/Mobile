// ignore: depend_on_referenced_packages
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:async';

// ignore: depend_on_referenced_packages

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:weatherappv2_proj/currently.dart';
import 'package:weatherappv2_proj/today.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:weatherappv2_proj/viewmodels/weather.dart';
import 'package:weatherappv2_proj/weekly.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:weatherappv2_proj/viewmodels/model.dart';
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
  String _locationMessage = "Press the button to get location";

  void _handleSearchChange(String value) {
    // Cancel the previous timer if it exists
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // Set a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = value.isNotEmpty;
      });
    });
  }

  Future<Iterable<Widget>> _buildSearchSuggestions(
      BuildContext context, SearchController controller) async {
    if (controller.text.isEmpty) {
      return const [];
    }

    try {
      final cities = await searchCities(controller.text);
      final mainProvider = Provider.of<MainProvider>(context, listen: false);

      return cities.map((city) => ListTile(
            title: Text(city.name),
            subtitle: Text('${city.region}, ${city.country}'),
            onTap: () async {
              controller.closeView(city.name);
              if (!mounted) return;

              setState(() {
                _isLoading = true;
              });

              try {
                final weatherData =
                    await getWeather(city.latitude, city.longitude);
                if (!mounted) return;

                // Update state using the stored provider reference
                mainProvider.setWeatherData(weatherData);
                mainProvider.setCity(city.name);
              } catch (e) {
                log('Error fetching weather data: $e');
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
          ));
    } catch (e) {
      return [
        const ListTile(
          title: Text('Error searching for cities'),
        )
      ];
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        if (mounted) {
          setState(() {
            _locationMessage = "Location services are disabled.";
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _locationMessage = "Location permissions are denied.";
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _locationMessage = "Location permissions are permanently denied.";
          });
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (!mounted) return;

      final weatherData =
          await getWeather(position.latitude, position.longitude);

      if (!mounted) return;

      Provider.of<MainProvider>(context, listen: false)
          .setWeatherData(weatherData);

      final response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&addressdetails=1"));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final address = jsonDecode(response.body)["address"];
        if (address != null) {
          final locationName = address["city"] ??
              address["town"] ??
              address["village"] ??
              address["suburb"] ??
              address["county"] ??
              "Unknown Location";

          Provider.of<MainProvider>(context, listen: false)
              .setCity(locationName);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = "Failed to fetch location.";
        });
      }
      print("Error: $e");
    }
  }

  // ignore: non_constant_identifier_names
  Future get_city(Position p) async {
    if (!mounted) return; // Check before starting the operation

    var response = await http.Client().get(Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${p.latitude}&lon=${p.longitude}&addressdetails=1"));

    if (!mounted) return; // Check again after the async operation

    try {
      final address = jsonDecode(response.body)["address"];
      if (address != null && address.containsKey("city")) {
        // log(address["city"]);
        context.read<MainProvider>().setCity(address["city"]);
      }
    } catch (e) {
      log("Error parsing city: $e");
    }
  }

  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(query)}&count=10&language=en&format=json'));
      // log(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          return (data['results'] as List)
              .map((result) => City(
                    name: result['name'],
                    region: result['admin1'] ?? '',
                    country: result['country'] ?? '',
                    latitude: result['latitude'].toDouble(),
                    longitude: result['longitude'].toDouble(),
                  ))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Weather> getWeather(double latitude, double longitude) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=GMT'),
          )
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception(
          'Connection timed out. Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  int _index = 0;
  String location = '';
  bool _isLoading = false;
  Timer? _debounceTimer;
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
            // title:

            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: SearchAnchor(
                      dividerColor: Colors.black,
                      viewSurfaceTintColor: Colors.white,
                      headerHintStyle: const TextStyle(
                        fontFamily: 'my',
                        fontWeight: FontWeight.bold,
                      ),
                      headerTextStyle: const TextStyle(
                        fontFamily: 'my',
                        fontWeight: FontWeight.bold,
                      ),
                      searchController: searchController,
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          controller: controller,
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: _handleSearchChange,
                          leading: const Icon(Icons.search),
                          hintText: 'Search cities...',
                        );
                      },
                      suggestionsBuilder: _buildSearchSuggestions,
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  final Iterable<Widget> suggestions;

  const SearchView({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: suggestions.toList(),
    );
  }
}
