import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request_models.dart';
import '../models/login_response_models.dart';
import '../config/api_config.dart';

class LoginService {
  final http.Client _client;

  LoginService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// POST /users/login → autentica o usuário e retorna dados + token JWT
  Future<LoginResponse> login(LoginRequest request) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');
    
    try {
      final resp = await _client.post(
        uri,
        headers: ApiConfig.defaultHeaders,
        body: json.encode(request.toJson()),
      );

      if (resp.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(resp.body));
      } else {
        final errorBody = json.decode(resp.body);
        throw Exception(errorBody['detail'] ?? 'Erro ao autenticar');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erro de conexão: $e');
    }
  }
}

