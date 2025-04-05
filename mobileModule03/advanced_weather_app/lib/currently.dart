import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';

class CurrentlyPage extends StatefulWidget {
  const CurrentlyPage({super.key});

  @override
  State<CurrentlyPage> createState() => _CurrentlyPageState();
}

class _CurrentlyPageState extends State<CurrentlyPage> {
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
      if (provider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (provider.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'my',
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.clearError(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }

      // Check if weather data is available
      if (weatherData == null) {
        return const Center(
          child: Text(
            'Loading weather data...\nPlease search for a location.',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontFamily: 'my', fontSize: 18, color: Colors.white),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    fontFamily: 'my',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      temperatureC?.toStringAsFixed(1) ?? '--',
                      style: const TextStyle(
                        fontFamily: 'my',
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 70,
                      ),
                    ),
                    const Text(
                      '°C',
                      style: TextStyle(
                        fontFamily: 'my',
                        color: Colors.amber,
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
                    color: Colors.white,
                    fontFamily: 'my',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 50,
                  child: Icon(
                    getWeatherIcon(weatherCode),
                    size: 70,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                // Wind speed
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.air,
                      size: 24,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Wind: ${windSpeed?.toStringAsFixed(1) ?? '--'} km/h',
                      style: const TextStyle(
                          fontFamily: 'my', fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
              color: Colors.white,
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
