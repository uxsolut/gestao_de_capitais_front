import 'package:flutter/material.dart';

import '../../models/lista_model.dart';
import '../../models/conta_model.dart';
import '../../models/corretora_models.dart';
import '../../models/robo_model.dart';
import '../../services/cliente_contas_service.dart';
import '../../models/dialog_lista_model.dart';

class ClienteContasController extends ChangeNotifier {
  final ClienteContasService _contaService = ClienteContasService();

  List<ListaModel> contas = [];
  List<Corretora> corretoras = [];
  final Map<int, ContaModel> _contasOriginais = {};

  bool carregando = true;
  String? erro;

  /// Carrega as contas do backend e transforma para ListaModel
  Future<void> carregarContas(int carteiraId) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      final dados = await _contaService.getContas(carteiraId);

      _contasOriginais.clear();
      for (var conta in dados) {
        _contasOriginais[conta.id] = conta;
      }

      contas = dados.map(_mapearParaListaModel).toList();
    } catch (e) {
      erro = 'Erro ao carregar contas: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Carrega as corretoras disponíveis para o dropdown
  Future<void> carregarCorretoras() async {
    try {
      corretoras = await _contaService.getCorretoras();
    } catch (e) {
      print('Erro ao carregar corretoras: $e');
      corretoras = [];
    }
  }

  /// Cria uma nova conta vinculada à carteira e atualiza a lista
  Future<bool> criarConta({
    required String carteiraId,
    required String nome,
    required String contaMetaTrader,
    required int idCorretora,
  }) async {
    try {
      await _contaService.criarConta(
        idCarteira: carteiraId,
        nome: nome,
        contaMetaTrader: contaMetaTrader,
        idCorretora: idCorretora,
      );

      final id = int.tryParse(carteiraId);
      if (id != null) {
        await carregarContas(id);
      }

      return true;
    } catch (e) {
      print('Erro ao criar conta: $e');
      erro = 'Erro ao criar conta: $e';
      notifyListeners();
      return false;
    }
  }

  /// Edita uma conta existente
  Future<bool> atualizarConta({
    required int contaId,
    required String nome,
    required String contaMetaTrader,
    required int idCorretora,
    required int carteiraId,
  }) async {
    try {
      await _contaService.atualizarConta(
        contaId: contaId,
        nome: nome,
        contaMetaTrader: contaMetaTrader,
        idCorretora: idCorretora,
      );

      await carregarContas(carteiraId);
      return true;
    } catch (e) {
      erro = 'Erro ao atualizar conta: $e';
      notifyListeners();
      return false;
    }
  }

  /// Acessa a conta completa por ID
  ContaModel? obterContaCompletaPorId(int id) {
    return _contasOriginais[id];
  }

  /// Mapeia ContaModel → ListaModel para uso visual
  ListaModel _mapearParaListaModel(ContaModel conta) {
    return ListaModel(
      id: conta.id,
      tituloItem: conta.nome,
      descricao1: 'Corretora: ${conta.nomeCorretora}',
      descricao2: 'Margem Total: ${conta.margemTotal?.toStringAsFixed(2) ?? '-'}',
      descricao3: 'Margem disponível: ${conta.margemDisponivel?.toStringAsFixed(2) ?? '-'}',
      dataHora: null,
      podeEditar: true,
      podeDeletar: true,
    );
  }

  /// Busca os robôs disponíveis para uma conta
  Future<List<RoboModel>> getRobosDisponiveisParaConta(int contaId) async {
    return await _contaService.getRobosDisponiveisParaConta(contaId);
  }

  /// Cria o vínculo entre conta e robô
  Future<void> vincularRoboDoUser({
    required int idRobo,
    required int idConta,
    required int idCarteira,
  }) async {
    await _contaService.criarRoboDoUser(
      idRobo: idRobo,
      idConta: idConta,
      idCarteira: idCarteira,
    );

    await carregarContas(idCarteira);
  }


  /// Busca os robôs vinculados (robos_do_user) para uma conta e retorna no formato visual
Future<List<DialogListaModel>> buscarRobosDaConta(int contaId) async {
  return await _contaService.getRobosDoUserPorConta(contaId);
}

 /// Deleta um robô_do_user pelo ID
Future<bool> deletarRoboDoUser(int idRoboUser) async {
  try {
    await _contaService.deletarRoboDoUser(idRoboUser);
    return true; // a Page decide quando recarregar a lista do diálogo
  } catch (e) {
    erro = 'Erro ao deletar robô do user: $e';
    notifyListeners();
    return false;
  }
}

/// Exclui uma conta e recarrega a lista (backend já remove robôs vinculados)
Future<bool> deletarConta(int contaId, int carteiraId) async {
  try {
    await _contaService.deletarConta(contaId);
    await carregarContas(carteiraId);
    return true;
  } catch (e) {
    erro = 'Erro ao excluir conta: $e';
    notifyListeners();
    return false;
  }
}

}
