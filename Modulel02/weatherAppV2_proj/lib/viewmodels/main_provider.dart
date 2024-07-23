import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  String city = '';

  void setCity(String city) {
    this.city = city;
    notifyListeners();
  }
}
