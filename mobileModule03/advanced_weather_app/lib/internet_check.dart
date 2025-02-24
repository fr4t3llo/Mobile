// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _controller.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _checkConnectivity(results);
    });
    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _checkConnectivity([results.first]);
  }

  void _checkConnectivity(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);
    _controller.add(hasConnection);
  }

  void dispose() {
    _controller.close();
  }
}