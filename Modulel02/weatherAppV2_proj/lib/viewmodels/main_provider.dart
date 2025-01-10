import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/viewmodels/model.dart';

class MainProvider extends ChangeNotifier {
  String _city = '';
  WeatherData? _weatherData;

  String get city => _city;
  WeatherData? get weatherData => _weatherData;

  void setCity(String newCity) {
    _city = newCity;
    notifyListeners();
  }

  void setWeatherData(WeatherData data) {
    _weatherData = data;
    notifyListeners();
  }
}