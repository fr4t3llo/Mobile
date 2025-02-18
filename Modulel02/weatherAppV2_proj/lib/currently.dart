import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';

class CurrentlyPage extends StatefulWidget {
  const CurrentlyPage({super.key});

  @override
  State<CurrentlyPage> createState() => _CurrentlyPageState();
}

class _CurrentlyPageState extends State<CurrentlyPage> {
  // Helper function to get weather description based on weather code
  String getWeatherDescription(int? weatherCode) {
    if (weatherCode == null) return 'Unknown';

    // Based on WMO Weather interpretation codes (WW)
    // Reference: https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
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

      // Extract current weather information
      final current = weatherData.current;
      final temperatureC = current?.temperature2m;
      final weatherCode = current?.weatherCode;
      final windSpeed = current?.windSpeed10m;

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              city,
              style: const TextStyle(
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${temperatureC?.toStringAsFixed(1) ?? '--'}',
                  style: const TextStyle(
                    fontFamily: 'my',
                    fontWeight: FontWeight.bold,
                    fontSize: 70,
                  ),
                ),
                const Text(
                  '°C',
                  style: TextStyle(
                    fontFamily: 'my',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Weather description
            Text(
              getWeatherDescription(weatherCode),
              style: const TextStyle(
                fontFamily: 'my',
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Wind speed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.air, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Wind: ${windSpeed?.toStringAsFixed(1) ?? '--'} km/h',
                  style: const TextStyle(
                    fontFamily: 'my',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            // Add more widgets as needed
          ],
        ),
      );
    });
  }
}
