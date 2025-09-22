import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/corretora_models.dart';

class CorretoraService {
  final String baseUrl = "${ApiConfig.baseUrl}/corretoras";

  Future<List<Corretora>> listarCorretoras() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Corretora.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar corretoras");
    }
  }

  Future<void> criarCorretora(CorretoraCreate nova) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nova.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao criar corretora");
    }
  }

  Future<void> editarCorretora(int id, CorretoraCreate data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao editar corretora");
    }
  }

  Future<void> excluirCorretora(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir corretora");
    }
  }
}
