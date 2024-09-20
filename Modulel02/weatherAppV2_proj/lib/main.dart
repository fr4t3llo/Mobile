// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

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
  String _locationMessage = "Press the button to get location";
  //* to get the location for the device *//

  @override
  void initState() {
    super.initState();
    _getCities();
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

  List<dynamic> listSearch = [];
  Future<void> _getCities() async {
    String city = 'new york';
    String? apiUrl = dotenv.env['API_CITIES'];

    // Ensure apiUrl is not null
    if (apiUrl == null) {
      print('API URL is not set');
      return;
    }

    // Perform the HTTP GET request
    http.Response response =
        await http.get(Uri.parse('$apiUrl$city&format=jsonv2'));

    // Check if the response is successful
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      for (int i = 0; i < responseBody.length; i++) {
        listSearch.add(responseBody[i]['display_name']);
      }

      print(listSearch);
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
                  _getCities();
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

  Future<http.Response> getDataApi(String query) async {
    String? url = dotenv.env['API_CITIES'];
    var data = {"city": query};

    try {
      final response = await http.post(
        Uri.parse(url!),
        body: data,
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return response; // Or return responseBody if needed
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error fetching data: $e');
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
    // resault search
    return FutureBuilder(
      future: getDataApi(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.lenght,
              itemBuilder: (context, i) {
                return Text('data');
              });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
    // throw UnimplementedError();
  }

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
