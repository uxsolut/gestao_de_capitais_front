import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cliente_carteiras_service.dart';
import '../models/lista_model.dart';
import '../models/carteira_model.dart';
import '../controllers/dashboard_controller.dart';

class ClienteCarteirasController extends ChangeNotifier {
  final ClienteCarteirasService _service = ClienteCarteirasService();

  List<CarteiraModel> _todasCarteiras = [];
  List<ListaModel> listaCarteiras = [];

  bool isLoading = true;
  bool _jaCarregado = false;
  String? errorMessage;

  bool get jaCarregado => _jaCarregado;

  Future<void> carregarCarteirasUmaVez() async {
    if (_jaCarregado) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _todasCarteiras = await _service.getCarteiras();
      listaCarteiras = _todasCarteiras.map(_service.toListaModel).toList();
      _jaCarregado = true;
      isLoading = false;
    } catch (e) {
      errorMessage = 'Erro ao carregar carteiras';
      isLoading = false;
    }

    notifyListeners();
  }

  Future<void> criarCarteira(String nome, {BuildContext? context}) async {
    final nova = await _service.criarCarteira(nome);
    _todasCarteiras.add(nova);
    listaCarteiras = _todasCarteiras.map(_service.toListaModel).toList();
    notifyListeners();

    context?.read<DashboardController>().recarregar();
  }

  Future<void> editarCarteira(int id, String novoNome) async {
    final atualizada = await _service.atualizarCarteira(id, novoNome);
    final index = _todasCarteiras.indexWhere((c) => c.id == id);
    if (index != -1) {
      _todasCarteiras[index] = atualizada;
      listaCarteiras = _todasCarteiras.map(_service.toListaModel).toList();
      notifyListeners();
    }
  }

  Future<void> excluirCarteira(int id, {BuildContext? context}) async {
    await _service.excluirCarteira(id);
    _todasCarteiras.removeWhere((c) => c.id == id);
    listaCarteiras = _todasCarteiras.map(_service.toListaModel).toList();
    notifyListeners();

    context?.read<DashboardController>().recarregar();
  }

  /// Para forçar recarregar depois de logout, reload, etc
  void resetarCache() {
    _jaCarregado = false;
  }
}
