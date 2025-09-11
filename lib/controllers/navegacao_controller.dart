import 'package:flutter/foundation.dart';

enum EstadoNavegacao { home, login, dashboard, equipe, contratar, contato }

class NavegacaoController extends ChangeNotifier {
  EstadoNavegacao _estado = EstadoNavegacao.dashboard;
  EstadoNavegacao get estado => _estado;

  void mudarPara(EstadoNavegacao novo) {
    if (_estado == novo) return;
    _estado = novo;
    notifyListeners();
  }
}
