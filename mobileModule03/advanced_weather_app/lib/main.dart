// ignore_for_file: use_build_context_synchronously, unused_field, depend_on_referenced_packages
import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weatherappv2_proj/currently.dart';
import 'package:weatherappv2_proj/today.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:weatherappv2_proj/viewmodels/weather.dart';
import 'package:weatherappv2_proj/weekly.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherappv2_proj/viewmodels/model.dart';

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
  final String _locationMessage = "Press the button to get location";

  void _handleSearchChange(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

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

    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    // Check for internet connection
    if (!mainProvider.hasInternetConnection) {
      return [
        const ListTile(
          leading: Icon(Icons.signal_wifi_off, color: Colors.red),
          title: Text('No internet connection'),
          subtitle: Text('Please check your connection and try again'),
        )
      ];
    }

    mainProvider.setLoading(true);
    mainProvider.clearError();

    try {
      final cities = await searchCities(controller.text);

      if (cities.isEmpty) {
        mainProvider.setError(
            'No cities found with that name. Please try another search.');
        return [
          ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text(mainProvider.errorMessage),
          )
        ];
      }

      final limitedCities = cities.take(5);

      return limitedCities.map((city) => ListTile(
            title: Text(city.name),
            subtitle: Text('${city.region}, ${city.country}'),
            onTap: () async {
              controller.closeView(city.name);
              mainProvider.setLoading(true);
              mainProvider.clearError();

              try {
                final weatherData =
                    await getWeather(city.latitude, city.longitude);
                mainProvider.setWeatherData(weatherData);
                mainProvider.setCity(city.name);
              } catch (e) {
                mainProvider.setError(
                    'Failed to fetch weather data. Please check your connection and try again.');
              } finally {
                mainProvider.setLoading(false);
              }
            },
          ));
    } catch (e) {
      mainProvider.setError(
          'Failed to search for cities. Please check your connection and try again.');
      return [
        ListTile(
          leading: const Icon(Icons.error_outline, color: Colors.red),
          title: Text(mainProvider.errorMessage),
        )
      ];
    } finally {
      mainProvider.setLoading(false);
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.setLoading(true);
    mainProvider.clearError();

    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        mainProvider.setError(
            'Location services are disabled. Please enable location services and try again.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          mainProvider.setError(
              'Location permissions are denied. Please enable them in settings to use this feature.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        mainProvider.setError(
            'Location permissions are permanently denied. Please enable them in settings to use this feature.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final weatherData =
          await getWeather(position.latitude, position.longitude);
      mainProvider.setWeatherData(weatherData);

      final response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&addressdetails=1"));

      if (response.statusCode == 200) {
        final address = jsonDecode(response.body)["address"];
        if (address != null) {
          final locationName = address["city"] ??
              address["town"] ??
              address["village"] ??
              address["suburb"] ??
              address["county"] ??
              "Unknown Location";
          mainProvider.setCity(locationName);
        }
      }
    } catch (e) {
      mainProvider.setError(
          'Failed to fetch location or weather data. Please check your connection and try again.');
    } finally {
      mainProvider.setLoading(false);
    }
  }

  // ignore: non_constant_identifier_names
  Future get_city(Position p) async {
    if (!mounted) return;

    var response = await http.Client().get(Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${p.latitude}&lon=${p.longitude}&addressdetails=1"));

    if (!mounted) return;

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
              .map(
                (result) => City(
                  name: result['name'],
                  region: result['admin1'] ?? '',
                  country: result['country'] ?? '',
                  latitude: result['latitude'].toDouble(),
                  longitude: result['longitude'].toDouble(),
                ),
              )
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
          .timeout(const Duration(seconds: 10));

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
          body: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/back.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: content,
                onPageChanged: (value) {
                  setState(() {
                    _index = value;
                  });
                },
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 0, 174, 255),
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
            backgroundColor: const Color.fromARGB(255, 0, 174, 255),
            // backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
