class AppConfig {
  // Lê da build (opcional). Se vier vazio, usa a própria origem + /api
  static const String _envApiBase =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  // Em produção vira: https://pinacle.com.br/api
  static String get apiBaseUrl =>
      _envApiBase.isNotEmpty ? _envApiBase : '${Uri.base.origin}/api';

  // Helpers para montar URLs (evita // duplicado)
  static Uri api(String path)  => Uri.parse('${apiBaseUrl}/${path.replaceFirst(RegExp(r"^/"), "")}');
  static Uri write(String path)=> Uri.parse('${apiBaseUrl}/write/${path.replaceFirst(RegExp(r"^/"), "")}');
  static Uri read(String path) => Uri.parse('${apiBaseUrl}/read/${path.replaceFirst(RegExp(r"^/"), "")}');

  // --- resto permanece igual ---
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');
  static const bool enableLogging =
      bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  static const int cacheTimeout = int.fromEnvironment('CACHE_TIMEOUT', defaultValue: 300);
  static const int animationDuration = 300;
  static const double borderRadius = 12.0;
  static const int primaryColor = 0xFF4285f4;
  static const int backgroundColor = 0xFF1a1a1a;
  static const int cardColor = 0xFF2d2d2d;
  static const int successColor = 0xFF34a853;
  static const int warningColor = 0xFFff9800;
  static const int errorColor = 0xFFea4335;
  static const int httpTimeout = 30;
  static const int connectionTimeout = 10;
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const bool enablePushNotifications = true;
  static const bool enableSoundNotifications = true;

  static bool get isDebug => !isProduction;
  static void log(String message) {
    if (enableLogging && isDebug) print('[AppConfig] $message');
  }
}
