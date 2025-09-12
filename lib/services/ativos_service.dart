// services/ativos_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ativo_resumo.dart';

class AtivosService {
  static const String _baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://pinacle.com.br');

  static Future<List<AtivoResumo>> listarResumos() async {
    final r = await http.get(Uri.parse('$_baseUrl/ativos')); // ajuste se necessário
    final data = jsonDecode(utf8.decode(r.bodyBytes)) as List;
    return data.map((e) => AtivoResumo.fromJson(e)).toList();
  }
}
