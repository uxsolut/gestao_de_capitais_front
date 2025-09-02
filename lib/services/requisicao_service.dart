// lib/services/requisicao_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/requisicao.dart';

class RequisicaoService {
  final String baseUrl;
  final http.Client _client;

  RequisicaoService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// GET /requisicoes/ → lista todas as requisições
  Future<List<Requisicao>> getRequisicoes() async {
    final uri = Uri.parse('$baseUrl/requisicoes/');
    final resp = await _client.get(uri);

    if (resp.statusCode == 200) {
      final List<dynamic> body = json.decode(resp.body);
      return body.map((e) => Requisicao.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar requisições (${resp.statusCode})');
    }
  }

  /// POST /requisicoes/ → cria uma nova requisição
  Future<Requisicao> createRequisicao(Requisicao req) async {
    final uri = Uri.parse('$baseUrl/requisicoes/');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(req.toJson()),
    );

    if (resp.statusCode == 201) {
      return Requisicao.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao criar requisição (${resp.statusCode})');
    }
  }

  /// PUT /requisicoes/{id} → atualiza uma requisição existente
  Future<Requisicao> updateRequisicao(Requisicao req) async {
    final uri = Uri.parse('$baseUrl/requisicoes/${req.id}/');
    final resp = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(req.toJson()),
    );

    if (resp.statusCode == 200) {
      return Requisicao.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao atualizar requisição (${resp.statusCode})');
    }
  }

  /// DELETE /requisicoes/{id} → exclui uma requisição
  Future<void> deleteRequisicao(int id) async {
    final uri = Uri.parse('$baseUrl/requisicoes/$id/');
    final resp = await _client.delete(uri);

    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Erro ao deletar requisição (${resp.statusCode})');
    }
  }
}
