import 'dart:convert';
import '../models/ordem_models.dart';
import '../config/api_config.dart';
import 'http_service.dart';

class OrdemService {
  final HttpService _httpService = HttpService();

  /// GET /ordens/ → lista todas as ordens (usado antes, pode remover futuramente)
  Future<List<Ordem>> getOrdens() async {
    try {
      final response = await _httpService.get('${ApiConfig.ordensEndpoint}/');

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((e) => Ordem.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao carregar ordens: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar ordens: $e');
      rethrow;
    }
  }

  /// GET /ordens/robo-user/{id} → lista ordens filtradas por id_robo_user
  Future<List<Ordem>> getOrdensByRoboUser(int idRoboUser) async {
    try {
      final response = await _httpService.get('${ApiConfig.ordensEndpoint}/robo-user/$idRoboUser');

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((e) => Ordem.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao carregar ordens filtradas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar ordens por robô: $e');
      rethrow;
    }
  }

  /// POST /ordens/ → cria uma nova ordem
  Future<Ordem> createOrdem(OrdemCreate ordemCreate) async {
    try {
      final response = await _httpService.post(
        '${ApiConfig.ordensEndpoint}/',
        body: ordemCreate.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Ordem.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Erro ao criar ordem');
      }
    } catch (e) {
      print('Erro ao criar ordem: $e');
      rethrow;
    }
  }
}
