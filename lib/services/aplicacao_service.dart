import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aplicacao_models.dart';
import '../config/api_config.dart';
import 'http_service.dart';

class AplicacaoService {
  final HttpService _httpService = HttpService();

  /// POST /aplicacoes/
  Future<Aplicacao> criarAplicacao({
    required String nome,
    required String tipo,
  }) async {
    final token = await _httpService.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/aplicacoes/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome': nome,
        'tipo': tipo,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Aplicacao.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      _httpService.handleTokenExpired();
      throw Exception('Token expirado. Faça login novamente.');
    } else {
      throw Exception('Erro ao criar aplicação: ${response.body}');
    }
  }

  /// PUT /aplicacoes/{id} → atualiza id_versao_aplicacao
  Future<Aplicacao> atualizarAplicacao({
    required int id,
    required int idVersaoAplicacao,
  }) async {
    final token = await _httpService.getToken();

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/aplicacoes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_versao_aplicacao': idVersaoAplicacao,
      }),
    );

    if (response.statusCode == 200) {
  return Aplicacao.fromJson(jsonDecode(response.body));
} else {
  throw Exception('Erro ao atualizar aplicação: ${response.body}');
}
  }
}
