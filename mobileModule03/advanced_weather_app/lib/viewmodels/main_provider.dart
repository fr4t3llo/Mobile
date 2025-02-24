import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/internet_check.dart';
import 'package:weatherappv2_proj/viewmodels/weather.dart';

class MainProvider extends ChangeNotifier {
  String _city = '';
  Weather? _weatherData;
  bool _invalidCityEntered = false;
  String _lastErrorMessage = '';
  String _errorMessage = '';
  bool _isLoading = false;
  bool _hasError = false;

  bool get hasInternetConnection => _hasInternetConnection;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  String get city => _city;
  Weather? get weatherData => _weatherData;
  bool get invalidCityEntered => _invalidCityEntered;
  String get lastErrorMessage => _lastErrorMessage;

  final ConnectivityService _connectivityService;
  bool _hasInternetConnection = true;

  MainProvider() : _connectivityService = ConnectivityService() {
    _connectivityService.connectionStream.listen((hasConnection) {
      _hasInternetConnection = hasConnection;
      if (!hasConnection) {
        setError(
            'No internet connection. Please check your connection and try again.');
      } else {
        clearError();
      }
      notifyListeners();
    });
  }
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

  // Add methods to handle errors
  void setError(String message) {
    _errorMessage = message;
    _hasError = true;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    _hasError = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
}
