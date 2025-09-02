// lib/services/resultado_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resultado.dart';

class ResultadoService {
  final String baseUrl;
  final http.Client _client;

  ResultadoService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// GET /resultados/ → lista todos os resultados
  Future<List<Resultado>> getResultados() async {
    final uri = Uri.parse('$baseUrl/resultados/');
    final resp = await _client.get(uri);

    if (resp.statusCode == 200) {
      final List<dynamic> body = json.decode(resp.body);
      return body.map((e) => Resultado.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar resultados (${resp.statusCode})');
    }
  }

  /// POST /resultados/ → cria um novo resultado
  Future<Resultado> createResultado(Resultado resultado) async {
    final uri = Uri.parse('$baseUrl/resultados/');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resultado.toJson()),
    );

    if (resp.statusCode == 201) {
      return Resultado.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao criar resultado (${resp.statusCode})');
    }
  }

  /// PUT /resultados/{id} → atualiza um resultado existente
  Future<Resultado> updateResultado(Resultado resultado) async {
    final uri = Uri.parse('$baseUrl/resultados/${resultado.id}/');
    final resp = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resultado.toJson()),
    );

    if (resp.statusCode == 200) {
      return Resultado.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao atualizar resultado (${resp.statusCode})');
    }
  }

  /// DELETE /resultados/{id} → exclui um resultado
  Future<void> deleteResultado(int id) async {
    final uri = Uri.parse('$baseUrl/resultados/$id/');
    final resp = await _client.delete(uri);

    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Erro ao deletar resultado (${resp.statusCode})');
    }
  }
}
