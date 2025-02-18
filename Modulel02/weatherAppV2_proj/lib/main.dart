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
        if (mounted) {
          _locationMessage =
              "Lat: ${position.latitude}, Long: ${position.longitude}";
          get_city(position);
        }
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
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
      log(address["city"]);
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
      log(response.body);
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

// In getWeather function in main.dart:
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
              title: SearchAnchor(
                searchController: searchController,
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      // Cancel the previous timer if any
                      _debounceTimer?.cancel();

                      // Start a new timer for the search query
                      _debounceTimer =
                          Timer(const Duration(milliseconds: 300), () async {
                        // Perform the search after the debounce duration
                        if (value.isNotEmpty) {
                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          try {
                            final results = await searchCities(value);
                            setState(() {
                              _isLoading = false; // Stop loading
                            });

                            // Pass the results to the UI
                            if (results.isEmpty) {
                              // Handle no results
                            } else {
                              // Show search results
                            }
                          } catch (e) {
                            debugPrint("Error during city search: $e");
                            setState(() {
                              _isLoading = false; // Stop loading
                            });
                          }
                        }
                      });
                    },
                    leading: const Icon(Icons.search),
                    hintText: 'Search cities...',
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) async {
                  if (controller.text.isEmpty) {
                    return [
                      const ListTile(
                        title: Text('Type to search for a city...'),
                        enabled: false,
                      )
                    ];
                  }

                  if (_isLoading) {
                    return [
                      const ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Searching...'),
                        enabled: false,
                      )
                    ];
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final results = await searchCities(controller.text);

                    if (results.isEmpty) {
                      return [
                        const ListTile(
                          title: Text('No cities found'),
                          enabled: false,
                        )
                      ];
                    }
                    return results
                        .map((city) => ListTile(
                              title: Text(city.name),
                              subtitle: Text('${city.region}, ${city.country}'),
                              onTap: () async {
                                final cityString =
                                    '${city.name}, ${city.region}, ${city.country}';
                                controller.closeView(cityString);

                                // Update the city in MainProvider
                                context.read<MainProvider>().setCity(city.name);

                                // Show loading indicator

                                // Fetch weather data
                                // In main.dart, update the catch block in the ListTile onTap callback:

                                try {
                                  final weatherData = await getWeather(
                                      city.latitude, city.longitude);
                                  context
                                      .read<MainProvider>()
                                      .setWeatherData(weatherData);
                                } catch (e) {
                                  // Re-enable this to show error messages
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('Failed to load weather data: $e'),
                                    duration: const Duration(
                                        seconds: 4), // Slightly longer duration
                                    action: SnackBarAction(
                                      label: 'Retry',
                                      onPressed: () async {
                                        // Allow user to retry the operation
                                        try {
                                          final weatherData = await getWeather(
                                              city.latitude, city.longitude);
                                          context
                                              .read<MainProvider>()
                                              .setWeatherData(weatherData);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Still unable to connect: $e')),
                                          );
                                        }
                                      },
                                    ),
                                  ));
                                }
                              },
                            ))
                        .toList();
                  } catch (e) {
                    return [
                      ListTile(
                        title: Text('Error searching cities: $e'),
                        enabled: false,
                      )
                    ];
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
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

  const SearchView({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: suggestions.toList(),
    );
  }
}
