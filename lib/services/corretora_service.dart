import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/corretora_models.dart';

class CorretoraService {
  final String baseUrl = "${ApiConfig.baseUrl}/corretoras";

  // Se você já tiver algo como ApiConfig.getAuthHeaders(), use-o aqui.
  // Este helper supõe que exista um método que devolva o token.
  Future<Map<String, String>> _headers() async {
    final token = await ApiConfig.getToken(); // implemente/aponte pro seu auth
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Future<List<Corretora>> listarCorretoras() async {
    final resp = await http.get(Uri.parse("$baseUrl/"), headers: await _headers());
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((j) => Corretora.fromJson(j)).toList();
    }
    // Ajuda a depurar no console:
    throw Exception("Erro ao buscar corretoras (${resp.statusCode}): ${resp.body}");
  }

  Future<void> criarCorretora(CorretoraCreate nova) async {
    final resp = await http.post(
      Uri.parse("$baseUrl/"),
      headers: await _headers(),
      body: jsonEncode(nova.toJson()),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar corretora (${resp.statusCode}): ${resp.body}");
    }
  }

  Future<void> editarCorretora(int id, CorretoraCreate data) async {
    final resp = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: await _headers(),
      body: jsonEncode(data.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao editar corretora (${resp.statusCode}): ${resp.body}");
    }
  }

  Future<void> excluirCorretora(int id) async {
    final resp = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: await _headers(),
    );

    // FastAPI pode retornar 200 ou 204 – trate ambos como OK
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Erro ao excluir corretora (${resp.statusCode}): ${resp.body}");
    }
  }
}
