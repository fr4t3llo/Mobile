import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  String city = '';
  String location = '';
  void setCity(String city) {
    this.city = city;
    notifyListeners();
  }

  void setLosction(String location) {
    this.location = location;
    notifyListeners();
  }
}
