// lib/services/ativos_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ativo_resumo.dart';

class AtivosService {
  /// Base da API (ajuste no seu --dart-define ou .env)
  /// Ex.: -DAPI_BASE_URL=/api   -> resulta em /api/ativos
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '/api',
  );

  /// Caminho do recurso (ajuste se sua API for /api/v1/ativos)
  static const String _path = String.fromEnvironment(
    'ATIVOS_PATH',
    defaultValue: '/ativos',
  );

  static Uri _u([String extra = '']) {
    final p = (_baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl) +
        (_path.startsWith('/') ? _path : '/$_path') +
        (extra.isNotEmpty ? (extra.startsWith('/') ? extra : '/$extra') : '');
    return Uri.parse(p);
  }

  /// Lista resumida: [AtivoResumo(id, descricao)]
  static Future<List<AtivoResumo>> listarResumos() async {
    final r = await http.get(_u());
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Falha ao listar ativos (${r.statusCode}): ${r.body}');
    }

    final decoded = jsonDecode(utf8.decode(r.bodyBytes));
    if (decoded is! List) {
      throw Exception('Resposta inesperada para /ativos (esperado List).');
    }

    return decoded
        .map<AtivoResumo>((e) => AtivoResumo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Busca local (em memória) por trecho na descrição
  /// Útil para autocomplete, etc.
  static Future<List<AtivoResumo>> buscarPorDescricao(String termo) async {
    final lista = await listarResumos();
    final t = termo.trim().toLowerCase();
    return lista.where((a) => a.descricao.toLowerCase().contains(t)).toList();
  }

  /// Resolve o ID do ativo pela descrição EXATA (case-insensitive).
  /// Retorna null se não encontrar.
  static Future<int?> getIdPorDescricao(String descricao) async {
    final lista = await listarResumos();
    final d = descricao.trim().toLowerCase();
    for (final a in lista) {
      if (a.descricao.toLowerCase() == d) return a.id;
    }
    return null;
  }

  /// (Opcional) Busca um ativo específico por ID, se sua API tiver /ativos/{id}
  static Future<AtivoResumo?> obterPorId(int id) async {
    final r = await http.get(_u('/$id'));
    if (r.statusCode == 404) return null;
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Erro ao obter ativo $id (${r.statusCode}): ${r.body}');
    }
    final decoded = jsonDecode(utf8.decode(r.bodyBytes));
    return AtivoResumo.fromJson(decoded as Map<String, dynamic>);
  }
}
