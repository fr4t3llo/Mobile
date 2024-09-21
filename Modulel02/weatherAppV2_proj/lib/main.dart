// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'dart:async';

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
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
// Ensure you have the correct package for icons

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init supabase
  await dotenv.load(fileName: ".env");
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
  Timer? _debounce;
  String query = '';
  String _locationMessage = "Press the button to get location";
  //* to get the location for the device *//

  @override
  void initState() {
    super.initState();
  }

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
        debugPrint("${position.latitude} ${position.longitude}");
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        query = value;
      });
      if (query.isNotEmpty) {
        _getCities(query); // Call API with the current query
      } else {
        setState(() {
          listSearch.clear(); // Clear suggestions when the input is empty
        });
      }
    });
  }

  List<dynamic> listSearch = [];

  Future<void> _getCities(String city) async {
    String? apiUrl = dotenv.env['API_CITIES'];
    if (apiUrl == null) {
      print('API URL is not set');
      return;
    }

    http.Response response =
        await http.get(Uri.parse('$apiUrl$city&format=jsonv2'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      setState(() {
        listSearch = responseBody.map((item) => item['display_name']).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
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
                autofocus: false,
                readOnly: true,
                onTap: () {
                  showSearch(
                      context: context, delegate: DataSearch(list: listSearch));
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search location... ex:  Khouribga',
                    hintStyle: TextStyle(
                        fontFamily: 'my', fontWeight: FontWeight.w100)),
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        // showSearch(context: context, delegate: );
                        await _getCurrentLocation();
                        value.setLosction(_locationMessage);
                      },
                      icon: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.black,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<dynamic> list;
  DataSearch({required this.list});

  Future<List<dynamic>> getDataApi(String query) async {
    String? apiUrl = dotenv.env['API_CITIES'];
    // Ensure the query is properly formatted
    http.Response response =
        await http.get(Uri.parse('$apiUrl$query&format=jsonv2'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody; // Return the list of results
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // action for appbar
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Iconsax.close_circle))
    ];
    // throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // icon leading
    return (IconButton(
        onPressed: () {
          close(context, "test");
        },
        icon: const Icon(Iconsax.arrow_left)));
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getDataApi(query), // Fetch data based on query
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(child: Text('No results found.'));
        } else {
          var results = snapshot.data; // Assuming you return a list of results
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    results[index]['display_name'],
                    style: const TextStyle(
                        fontFamily: 'my',
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    close(
                        context,
                        results[index][
                            'display_name']); // Close search with selected city
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
  // @override
  // Widget buildResults(BuildContext context) {
  //   // resault search
  //   return FutureBuilder(
  //     future: getDataApi(query),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         return ListView.builder(
  //             itemCount: snapshot.data.lenght,
  //             itemBuilder: (context, i) {
  //               return Text('data');
  //             });
  //       }
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   // throw UnimplementedError();
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone search for something
    var searchList =
        query.isEmpty ? list : list.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const Icon(Iconsax.location),
            title: Text(searchList[i]),
            onTap: () {
              query = list[i];
              showResults(context);
            },
          );
        });

    // throw UnimplementedError();
  }
}
