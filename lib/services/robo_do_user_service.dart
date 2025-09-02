import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/robo_do_user_model.dart';
import '../config/api_config.dart';
import 'http_service.dart';

class RoboDoUserService {
  final HttpService _httpService = HttpService();

  /// GET /robos_do_user/listar → lista todas as relações robô-usuário
  Future<List<RoboDoUser>> getRobosDoUser({int? contaId}) async {
  try {
    final String endpoint = contaId == null
        ? '/robos_do_user/listar'
        : '/robos_do_user/listar?id_conta=$contaId';

    print('🔍 Endpoint usado: $endpoint'); // (ajuda no debug)

    final response = await _httpService.get(endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((e) => RoboDoUser.fromJson(e)).toList();
    } else if (_httpService.isTokenExpired(response)) {
      _httpService.handleTokenExpired();
      throw Exception('Token expirado. Faça login novamente.');
    } else {
      throw Exception('Erro ao carregar robôs do usuário (${response.statusCode})');
    }
  } catch (e) {
    throw Exception('Erro ao carregar robôs do usuário: $e');
  }
}

  /// POST /robos_do_user/ com multipart/form-data → cria uma nova relação robô-usuário
  Future<void> createRoboDoUserMultipart({
    required int idRobo,
    required int idConta,
  }) async {
    final token = await const FlutterSecureStorage().read(key: 'token');
    final uri = Uri.parse('${ApiConfig.baseUrl}/robos_do_user/');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['id_robo'] = idRobo.toString()
      ..fields['id_conta'] = idConta.toString()
      ..fields['ligado'] = 'false'
      ..fields['ativo'] = 'false'
      ..fields['tem_requisicao'] = 'false';

    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception('Erro ao criar robô do usuário: ${response.statusCode}\n$body');
    }
  }

  /// PUT /robos_do_user/{id}/ → atualiza uma relação existente
  Future<RoboDoUser> updateRoboDoUser(RoboDoUser item) async {
    try {
      final response = await _httpService.put('/robos_do_user/${item.id}/', body: item.toJson());

      if (response.statusCode == 200) {
        return RoboDoUser.fromJson(json.decode(response.body));
      } else if (_httpService.isTokenExpired(response)) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao atualizar robô do usuário (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar robô do usuário: $e');
    }
  }

  /// DELETE /robos_do_user/{id}/ → exclui uma relação robô-usuário
  Future<void> deleteRoboDoUser(int id) async {
    try {
      final response = await _httpService.delete('/robos_do_user/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        if (_httpService.isTokenExpired(response)) {
          _httpService.handleTokenExpired();
          throw Exception('Token expirado. Faça login novamente.');
        } else {
          throw Exception('Erro ao deletar robô do usuário (${response.statusCode})');
        }
      }
    } catch (e) {
      throw Exception('Erro ao deletar robô do usuário: $e');
    }
  }
}
