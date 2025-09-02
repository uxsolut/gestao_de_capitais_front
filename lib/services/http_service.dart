import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Método para obter headers com token JWT
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'token');
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Uri _buildUri(String endpoint) {
    return endpoint.startsWith('http')
        ? Uri.parse(endpoint)
        : Uri.parse('${ApiConfig.baseUrl}$endpoint');
  }

  // GET com autenticação
  Future<http.Response> get(String endpoint) async {
    final uri = _buildUri(endpoint);
    final headers = await _getAuthHeaders();
    
    try {
      return await _client.get(uri, headers: headers);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // POST com autenticação
  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(endpoint);
    final headers = await _getAuthHeaders();
    
    try {
      return await _client.post(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT com autenticação
  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(endpoint);
    final headers = await _getAuthHeaders();
    
    try {
      return await _client.put(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // DELETE com autenticação
  Future<http.Response> delete(String endpoint) async {
    final uri = _buildUri(endpoint);
    final headers = await _getAuthHeaders();
    
    try {
      return await _client.delete(uri, headers: headers);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Verifica se o token expirou (HTTP 401)
  bool isTokenExpired(http.Response response) {
    return response.statusCode == 401;
  }

  // Trata token expirado (limpa storage)
  void handleTokenExpired() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_data');
    // Aqui você pode redirecionar para login ou exibir alerta
  }

  // Método para obter token diretamente
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
