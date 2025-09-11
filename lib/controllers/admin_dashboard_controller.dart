import 'package:flutter/foundation.dart';

enum ViewDashboard {
  usuarios,
  atendimentos,
  estrategias,
  corretoras,
  dashboard,
  ordens,
  perfil,
  contas,
  noticias,
}

class AdminDashboardController extends ChangeNotifier {
  ViewDashboard _currentView = ViewDashboard.usuarios;
  ViewDashboard get currentView => _currentView;

  void navegarPara(ViewDashboard view) {
    if (_currentView == view) return;
    _currentView = view;
    notifyListeners();
  }
}
