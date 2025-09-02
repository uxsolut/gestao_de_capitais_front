import 'app_config.dart';

class ApiConfig {
  static String get baseUrl => AppConfig.apiBaseUrl;
  
  // Endpoints
  static const String usersEndpoint = '/users';
  static const String loginEndpoint = '/users/login';
  static const String robosEndpoint = '/robos';
  static const String ordensEndpoint = '/ordens';
  static const String carteirasEndpoint = '/carteiras';
  static const String contasEndpoint = '/contas';
  static const String requisicoesEndpoint = '/requisicoes';
  static const String robosDoUserEndpoint = '/robos_do_user';
  static const dashboardEndpoint = '/dashboard';
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers com autenticação
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
  
  // Timeout configurations
  static Duration get connectTimeout => Duration(seconds: AppConfig.connectionTimeout);
  static Duration get receiveTimeout => Duration(seconds: AppConfig.httpTimeout);
}

