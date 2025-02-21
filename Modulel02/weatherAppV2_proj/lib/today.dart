// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:intl/intl.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  String getWeatherDescription(int? weatherCode) {
    if (weatherCode == null) return 'Unknown';

    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  IconData getWeatherIcon(int? weatherCode) {
    if (weatherCode == null) return Icons.question_mark;

    if (weatherCode == 0) return Icons.wb_sunny;
    if (weatherCode >= 1 && weatherCode <= 3) return Icons.cloud;
    if (weatherCode >= 45 && weatherCode <= 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 57) return Icons.grain;
    if (weatherCode >= 61 && weatherCode <= 67) return Icons.water_drop;
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.beach_access;
    if (weatherCode >= 85 && weatherCode <= 86) return Icons.snowing;
    if (weatherCode >= 95) return Icons.flash_on;

    return Icons.question_mark;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, child) {
      final weatherData = provider.weatherData;
      final city = provider.city;

      // Check if weather data is available
      if (weatherData == null) {
        return const Center(
          child: Text(
            'Loading weather data...\nPlease search for a location.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'my',
              fontSize: 18,
            ),
          ),
        );
      }

      // Extract hourly data
      final hourly = weatherData.hourly;
      if (hourly == null || hourly.time == null || hourly.time!.isEmpty) {
        return const Center(
          child: Text(
            'No hourly data available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'my',
              fontSize: 18,
            ),
          ),
        );
      }

      // Filter to get only todays data
      final now = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(now);

      List<int> todayIndices = [];
      for (int i = 0; i < hourly.time!.length; i++) {
        if (hourly.time![i].startsWith(todayDateString)) {
          todayIndices.add(i);
        }
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Today's Forecast for $city",
              style: const TextStyle(
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: todayIndices.isEmpty
                ? const Center(child: Text('No data for today'))
                : ListView.builder(
                    itemCount: todayIndices.length,
                    itemBuilder: (context, index) {
                      final idx = todayIndices[index];
                      final hourString = hourly.time![idx].substring(11, 16);
                      final temp = hourly.temperature2m![idx];
                      final weatherCode = hourly.weatherCode![idx];
                      final windSpeed = hourly.windSpeed10m![idx];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Time
                              SizedBox(
                                width: 60,
                                child: Text(
                                  hourString,
                                  style: const TextStyle(
                                    fontFamily: 'my',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              // Weather icon
                              SizedBox(
                                width: 50,
                                child: Icon(
                                  getWeatherIcon(weatherCode),
                                  size: 28,
                                  color: Colors.blue,
                                ),
                              ),
                              // Temperature and description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${temp.toStringAsFixed(1)}°C',
                                      style: const TextStyle(
                                        fontFamily: 'my',
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      getWeatherDescription(weatherCode),
                                      style: const TextStyle(
                                        fontFamily: 'my',
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Wind speed
                              Row(
                                children: [
                                  const Icon(Icons.air,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${windSpeed.toStringAsFixed(1)} km/h',
                                    style: const TextStyle(
                                      fontFamily: 'my',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'my',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Provider.of<MainProvider>(context, listen: false).clearError();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
