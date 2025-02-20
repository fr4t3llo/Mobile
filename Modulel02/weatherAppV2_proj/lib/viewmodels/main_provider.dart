import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/viewmodels/weather.dart';

class MainProvider extends ChangeNotifier {
  String _city = '';
  Weather? _weatherData;
  bool _invalidCityEntered = false;
  String _lastErrorMessage = '';

  String get city => _city;
  Weather? get weatherData => _weatherData;
  bool get invalidCityEntered => _invalidCityEntered;
  String get lastErrorMessage => _lastErrorMessage;

  void setInvalidCity(bool invalid, [String message = '']) {
    _invalidCityEntered = invalid;
    _lastErrorMessage = message;
    notifyListeners();
  }

  void setCity(String newCity) {
    if (newCity != _city) {
      _city = newCity;
      notifyListeners();
    }
  }

  void setWeatherData(Weather? data) {
    _weatherData = data;
    notifyListeners();
  }

  void clearData() {
    _weatherData = null;
    _city = '';
    _invalidCityEntered = false;
    _lastErrorMessage = '';
    notifyListeners();
  }
}
