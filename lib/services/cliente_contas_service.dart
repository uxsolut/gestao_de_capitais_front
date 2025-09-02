import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/conta_model.dart';
import '../models/corretora_models.dart';
import '../models/robo_model.dart';
import '../models/robo_do_user_model.dart';
import '../models/dialog_lista_model.dart';
import '../utils/token_storage.dart';
import '../config/api_config.dart';

class ClienteContasService {
  /// Busca todas as contas do usuário logado
Future<List<ContaModel>> getContas(int carteiraId) async {
  final token = await TokenStorage.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/cliente/contas?id_carteira=$carteiraId');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => ContaModel.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar contas da carteira: ${response.statusCode}');
  }
}

  /// Busca todas as corretoras disponíveis
  Future<List<Corretora>> getCorretoras() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/corretoras');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Corretora.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar corretoras: ${response.statusCode}');
    }
  }

  /// Cria uma nova conta vinculada a uma corretora
  Future<void> criarConta({
    required String nome,
    required String contaMetaTrader,
    required int idCorretora,
    required String idCarteira,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/contas');

    final body = json.encode({
      'nome': nome,
      'conta_meta_trader': contaMetaTrader,
      'id_corretora': idCorretora,
      'id_carteira': int.parse(idCarteira),
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar conta: ${response.statusCode}');
    }
  }

  /// Cria um robo_do_user a partir do robo clicado
  Future<void> criarRoboDoUser({
    required int idRobo,
    required int idConta,
    required int idCarteira,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/robos_do_user');

    final body = json.encode({
      'id_robo': idRobo,
      'id_conta': idConta,
      'id_carteira': idCarteira,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar robô do user: ${response.statusCode}');
    }
  }
    /// Atualiza uma conta existente
  Future<void> atualizarConta({
    required int contaId,
    required String nome,
    required String contaMetaTrader,
    required int idCorretora,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/contas/$contaId');

    final body = json.encode({
      'nome': nome,
      'conta_meta_trader': contaMetaTrader,
      'id_corretora': idCorretora,
    });

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar conta: ${response.statusCode}');
    }
  }

    /// Busca todos os robôs disponíveis
  Future<List<RoboModel>> getTodosRobos() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/robos');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoboModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar robôs: ${response.statusCode}');
    }
  }

  /// Busca todos os robôs_do_user do usuário logado
  Future<List<RoboDoUserModel>> getRobosDoUser() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/robos_do_user');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoboDoUserModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar robôs vinculados: ${response.statusCode}');
    }
  }

  /// Busca apenas os robôs disponíveis (filtrando os já usados para a conta)
  Future<List<RoboModel>> getRobosDisponiveisParaConta(int contaId) async {
    final todos = await getTodosRobos();
    final usados = await getRobosDoUser();

    final usadosNaConta = usados.where((r) => r.idConta == contaId).toList();
    final idsUsados = usadosNaConta.map((r) => r.idRobo).toSet();

    return todos.where((r) => !idsUsados.contains(r.id)).toList();
  }


Future<List<DialogListaModel>> getRobosDoUserPorConta(int idConta) async {
  final token = await TokenStorage.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/cliente/robos_do_user?conta=$idConta');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final List<DialogListaModel> lista = data.map((json) {
      final robo = RoboDoUserModel.fromJson(json);
      return DialogListaModel(
        id: robo.id,
        titulo: robo.nomeRobo,
        linha1: 'ID Robô: ${robo.idRobo}',
        linha2: 'Status: ${robo.ligado ? 'Ligado' : 'Desligado'}',
      );
    }).toList();
    return lista;
  } else {
    throw Exception('Erro ao carregar robôs da conta: ${response.statusCode}');
  }
}

  /// Deleta um robô_do_user pelo ID
  Future<void> deletarRoboDoUser(int idRoboUser) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/cliente/robos_do_user/$idRoboUser');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Erro ao deletar robô do usuário');
    }
  }


/// Deleta uma conta (o backend já remove todos os robôs_do_user vinculados)
Future<void> deletarConta(int contaId) async {
  final token = await TokenStorage.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/cliente/contas/$contaId');

  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    try {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Erro ao excluir conta');
    } catch (_) {
      throw Exception('Erro ao excluir conta: ${response.statusCode}');
    }
  }
}

}