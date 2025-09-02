import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  String _welcomeMessage = 'Bem-vindo ao Trading Dashboard';

  bool get isLoading => _isLoading;
  String get welcomeMessage => _welcomeMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateWelcomeMessage(String message) {
    _welcomeMessage = message;
    notifyListeners();
  }
}

