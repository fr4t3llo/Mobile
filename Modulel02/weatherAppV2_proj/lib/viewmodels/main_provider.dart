import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/viewmodels/weather.dart';

class MainProvider extends ChangeNotifier {
  String _city = '';
  Weather? _weatherData;

  String get city => _city;
  Weather? get weatherData => _weatherData;

  void setCity(String newCity) {
    _city = newCity;
    notifyListeners();
  }

  void setWeatherData(Weather data) {
    _weatherData = data;
    notifyListeners();
  }
}