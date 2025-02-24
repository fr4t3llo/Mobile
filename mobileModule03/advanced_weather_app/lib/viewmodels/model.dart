class City {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  City({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherData {
  final List<double> temperatures;
  final List<String> times;

  WeatherData({required this.temperatures, required this.times});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final hourly = json['hourly'];
    return WeatherData(
      temperatures: List<double>.from(hourly['temperature_2m'].map((x) => x.toDouble())),
      times: List<String>.from(hourly['time']),
    );
  }
}
