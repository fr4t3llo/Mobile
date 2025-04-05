// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherappv2_proj/viewmodels/main_provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> {
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

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEE, MMM d').format(date);
  }

  String formatShortDay(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('E')
        .format(date); // Returns short day name (Mon, Tue, etc.)
  }

  @override
  Widget build(BuildContext context) {
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
              fontSize: 18,
            ),
          ),
        );
      }

      // Extract daily data
      final daily = weatherData.daily;
      if (daily == null || daily.time == null || daily.time!.isEmpty) {
        return const Center(
          child: Text(
            'No daily forecast available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'my',
              fontSize: 18,
            ),
          ),
        );
      }

      // Handle landscape orientation
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
                      "Weekly Forecast for $city",
                      style: const TextStyle(
                        fontFamily: 'my',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: _buildTemperatureChart(daily),
                  ),
                ],
              ),
            ),
            // Right side: Daily forecast list
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: daily.time!.length,
                itemBuilder: (context, index) {
                  final date = daily.time![index];
                  final maxTemp = daily.temperature2mMax![index];
                  final minTemp = daily.temperature2mMin![index];
                  final weatherCode = daily.weatherCode![index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              getWeatherIcon(weatherCode),
                              size: 28,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Date and weather info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDate(date),
                                  style: const TextStyle(
                                    fontFamily: 'my',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                          // Temperature range
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.arrow_upward,
                                      size: 12, color: Colors.red),
                                  Text(
                                    '${maxTemp.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontFamily: 'my',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.arrow_downward,
                                      size: 12, color: Colors.blue),
                                  Text(
                                    '${minTemp.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontFamily: 'my',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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

      // Portrait orientation
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Weekly Forecast for $city",
              style: const TextStyle(
                fontFamily: 'my',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Temperature Chart
          SizedBox(
            height: 220,
            child: _buildTemperatureChart(daily),
          ),
          // Daily forecast list
          Expanded(
            child: ListView.builder(
              itemCount: daily.time!.length,
              itemBuilder: (context, index) {
                final date = daily.time![index];
                final maxTemp = daily.temperature2mMax![index];
                final minTemp = daily.temperature2mMin![index];
                final weatherCode = daily.weatherCode![index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            getWeatherIcon(weatherCode),
                            size: 32,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Date and weather info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatDate(date),
                                style: const TextStyle(
                                  fontFamily: 'my',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                        // Temperature range
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward,
                                    size: 14, color: Colors.red),
                                Text(
                                  '${maxTemp.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontFamily: 'my',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward,
                                    size: 14, color: Colors.blue),
                                Text(
                                  '${minTemp.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontFamily: 'my',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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

  Widget _buildTemperatureChart(dynamic daily) {
    final maxTempSpots = <FlSpot>[];
    final minTempSpots = <FlSpot>[];
    final dayLabels = <String>[];

    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (int i = 0; i < daily.time!.length; i++) {
      final maxTemp = daily.temperature2mMax![i].toDouble();
      final minTemp = daily.temperature2mMin![i].toDouble();
      maxTempSpots.add(FlSpot(i.toDouble(), maxTemp));
      minTempSpots.add(FlSpot(i.toDouble(), minTemp));
      if (minTemp < minY) minY = minTemp;
      if (maxTemp > maxY) maxY = maxTemp;
      dayLabels.add(formatShortDay(daily.time![i]));
    }
    minY = (minY - 2).floorToDouble();
    maxY = (maxY + 2).ceilToDouble();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Temperature Forecast (°C)',
            style: TextStyle(
              fontFamily: 'my',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Legend for Max temperature
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Max Temp',
                    style: TextStyle(
                      fontFamily: 'my',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Legend for Min temperature
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Min Temp',
                    style: TextStyle(
                      fontFamily: 'my',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
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
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < dayLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              dayLabels[index],
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
                maxX: (daily.time!.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  // Max temperature line
                  LineChartBarData(
                    spots: maxTempSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.red,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),
                  // Min temperature line
                  LineChartBarData(
                    spots: minTempSpots,
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
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final index = barSpot.x.toInt();
                        if (index >= 0 && index < dayLabels.length) {
                          final date = formatDate(daily.time![index]);
                          final isMaxTemp = barSpot.barIndex == 0;

                          return LineTooltipItem(
                            '$date\n${barSpot.y.toStringAsFixed(1)}°C',
                            TextStyle(
                              fontFamily: 'my',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              backgroundColor: isMaxTemp
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                            ),
                          );
                        }
                        return null;
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
              Provider.of<MainProvider>(context, listen: false).clearError();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
