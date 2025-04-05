// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
    // Get the current orientation
    final orientation = MediaQuery.of(context).orientation;

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
              color: Colors.white,
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
            style:
                TextStyle(fontFamily: 'my', fontSize: 18, color: Colors.white),
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

      // If in landscape mode, use a Row layout instead of Column
      if (orientation == Orientation.landscape) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Chart
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Today's Forecast for $city",
                      style: const TextStyle(
                        fontFamily: 'my',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (todayIndices.isNotEmpty)
                    Expanded(
                      child: _buildTemperatureChart(hourly, todayIndices),
                    ),
                ],
              ),
            ),
            // Right side: Hourly forecast list
            Expanded(
              flex: 1,
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
                              horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Time
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    hourString,
                                    style: const TextStyle(
                                      fontFamily: 'my',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                // Weather icon
                                SizedBox(
                                  width: 40,
                                  child: Icon(
                                    getWeatherIcon(weatherCode),
                                    size: 24,
                                    color: Colors.blue,
                                  ),
                                ),
                                // Temperature and description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${temp.toStringAsFixed(1)}°C',
                                        style: const TextStyle(
                                          fontFamily: 'my',
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        getWeatherDescription(weatherCode),
                                        style: const TextStyle(
                                          fontFamily: 'my',
                                          fontSize: 12,
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
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 2),
                                    Text(
                                      '$windSpeed.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontFamily: 'my',
                                        fontSize: 12,
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
      }

      // Default portrait layout
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Today's Forecast for $city",
              style: const TextStyle(
                fontFamily: 'my',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // ffixed height in portrait mode
          if (todayIndices.isNotEmpty)
            SizedBox(
              height: 200,
              child: _buildTemperatureChart(hourly, todayIndices),
            ),
          // Hourly forecast list
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
                              // Temperature and descriptions
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

  Widget _buildTemperatureChart(dynamic hourly, List<int> todayIndices) {
    final spots = <FlSpot>[];
    final hourLabels = <String>[];

    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (int i = 0; i < todayIndices.length; i++) {
      final idx = todayIndices[i];
      final temp = hourly.temperature2m![idx].toDouble();
      spots.add(FlSpot(i.toDouble(), temp));

      // Update min and max temperature
      if (temp < minY) minY = temp;
      if (temp > maxY) maxY = temp;

      // Add hour label
      final hourString = hourly.time![idx].substring(11, 13);
      hourLabels.add(hourString);
    }

    // Add padding to min and max for better visualization
    minY = (minY - 2).floorToDouble();
    maxY = (maxY + 2).ceilToDouble();

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temperature (°C)',
            style: TextStyle(
              fontFamily: 'my',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        if (MediaQuery.of(context).orientation ==
                            Orientation.landscape) {
                          if (value.toInt() % 4 != 0 &&
                              value.toInt() != todayIndices.length - 1) {
                            return const SizedBox();
                          }
                        } else {
                          // For portrait mode
                          if (value.toInt() % 3 != 0 &&
                              value.toInt() != todayIndices.length - 1) {
                            return const SizedBox();
                          }
                        }

                        final index = value.toInt();
                        if (index >= 0 && index < hourLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${hourLabels[index]}:00',
                              style: TextStyle(
                                fontFamily: 'my',
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°',
                          style: TextStyle(
                            fontFamily: 'my',
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                minX: 0,
                maxX: (todayIndices.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Colors.blueAccent,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final index = barSpot.x.toInt();
                        final hourString = hourLabels[index];
                        return LineTooltipItem(
                          '$hourString:00\n${barSpot.y.toStringAsFixed(1)}°C',
                          const TextStyle(
                            fontFamily: 'my',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
