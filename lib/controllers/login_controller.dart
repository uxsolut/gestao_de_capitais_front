import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../services/login_service.dart';
import '../models/login_request_models.dart';
import '../models/login_response_models.dart';

class LoginController extends ChangeNotifier {
  final LoginService _loginService = LoginService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _currentUser;
  String? _currentToken;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get currentUser => _currentUser;
  String? get currentToken => _currentToken;
  bool get isLoggedIn => _currentUser != null && _currentToken != null;

  // Inicializar controller verificando se há dados salvos
  Future<void> initialize() async {
    try {
      final token = await _storage.read(key: 'token');
      final userDataJson = await _storage.read(key: 'user_data');
      
      if (token != null && userDataJson != null) {
        _currentToken = token;
        final userData = json.decode(userDataJson);
        _currentUser = LoginResponse.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao carregar dados salvos: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(email: email, senha: password);
      final response = await _loginService.login(request);
      
      // Salvar dados no controller
      _currentUser = response;
      _currentToken = response.accessToken;
      
      // Persistir dados no storage
      await _storage.write(key: 'token', value: response.accessToken);
      await _storage.write(key: 'user_data', value: json.encode(response.toJson()));
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erro ao fazer login: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _currentToken = null;
    _clearError();
    
    // Limpar storage
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_data');
    
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

