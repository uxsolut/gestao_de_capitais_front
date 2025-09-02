// lib/services/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_models.dart';

class UserService {
  final String baseUrl;
  final http.Client _client;

  UserService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// GET /users/ → lista todos os usuários
  Future<List<User>> getUsers() async {
    final uri = Uri.parse('$baseUrl/users/');
    final resp = await _client.get(uri);

    if (resp.statusCode == 200) {
      final List<dynamic> body = json.decode(resp.body);
      return body.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar usuários (${resp.statusCode})');
    }
  }

  /// POST /users/ → cria um novo usuário
  Future<User> createUser(User user) async {
    final uri = Uri.parse('$baseUrl/users/');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (resp.statusCode == 201) {
      return User.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao criar usuário (${resp.statusCode})');
    }
  }

  /// PUT /users/{id}/ → atualiza um usuário existente
  Future<User> updateUser(User user) async {
    final uri = Uri.parse('$baseUrl/users/${user.id}/');
    final resp = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (resp.statusCode == 200) {
      return User.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Erro ao atualizar usuário (${resp.statusCode})');
    }
  }

  /// DELETE /users/{id}/ → exclui um usuário
  Future<void> deleteUser(int id) async {
    final uri = Uri.parse('$baseUrl/users/$id/');
    final resp = await _client.delete(uri);

    if (resp.statusCode != 204 && resp.statusCode != 200) {
      throw Exception('Erro ao deletar usuário (${resp.statusCode})');
    }
  }
}
