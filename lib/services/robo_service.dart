import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../models/robo_model.dart';
import '../config/api_config.dart';
import 'http_service.dart';
import 'package:dio/dio.dart';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';

class RoboService {
  final HttpService _httpService = HttpService();

  /// GET /robos/
  Future<List<Robo>> getRobos() async {
    try {
      final response = await _httpService.get('${ApiConfig.robosEndpoint}/');

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((e) => Robo.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao carregar robôs: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar robôs: $e');
      rethrow;
    }
  }

  /// GET /robos/disponiveis?conta_id=X
  Future<List<Robo>> getRobosDisponiveis(int contaId) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado.');

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${ApiConfig.baseUrl}${ApiConfig.robosEndpoint}/disponiveis',
        queryParameters: {'conta_id': contaId},
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Robo.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao buscar robôs disponíveis: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar robôs disponíveis: $e');
      rethrow;
    }
  }

  /// POST /robos/
  /// (antes tinha 'symbol'; agora usa 'id_ativo')
  Future<Map<String, dynamic>> criarRobo({
    required String nome,
    required int idAtivo,                 // <- trocado
    required List<String> performance,
    PlatformFile? arquivoWeb,
    Uint8List? arquivoBytes,
    io.File? arquivoMobile,
  }) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado. Faça login novamente.');

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Arquivo principal
      MultipartFile arquivo;
      if (kIsWeb) {
        if (arquivoWeb != null && arquivoBytes != null) {
          arquivo = MultipartFile.fromBytes(
            arquivoBytes,
            filename: arquivoWeb.name,
            contentType: MediaType('application', 'octet-stream'),
          );
        } else {
          throw Exception('Arquivo não selecionado para Web.');
        }
      } else {
        if (arquivoMobile != null) {
          arquivo = await MultipartFile.fromFile(
            arquivoMobile.path,
            filename: arquivoMobile.path.split('/').last,
          );
        } else {
          throw Exception('Arquivo não selecionado para Mobile/Desktop.');
        }
      }

      final formData = FormData.fromMap({
        'nome': nome,
        'id_ativo': idAtivo,              // <- trocado (era 'symbol')
        'performance': performance,       // mantém como estava (lista)
        // mantém compatibilidade de chave do arquivo:
        'arquivo': arquivo,               // antigo
        'arquivo_robo': arquivo,          // novo (se o backend espera esse nome)
      });

      final response = await dio.post(
        '${ApiConfig.baseUrl}${ApiConfig.robosEndpoint}/',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.statusCode == 401) {
        _httpService.handleTokenExpired();
        throw Exception('Token expirado. Faça login novamente.');
      } else {
        throw Exception('Erro ao criar robô: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Erro ao criar robô (Dio): $e');
      rethrow;
    }
  }

  /// PUT /robos/{id}
  /// (antes tinha 'symbol'; agora usa 'id_ativo')
  Future<void> editarRobo({
    required int id,
    String? nome,
    int? idAtivo,                        // <- trocado
    List<String>? performance,
    PlatformFile? arquivoWeb,
    Uint8List? arquivoBytes,
    io.File? arquivoMobile,
  }) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado. Faça login novamente.');

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final Map<String, dynamic> dataMap = {};

      if (nome != null) dataMap['nome'] = nome;
      if (idAtivo != null) dataMap['id_ativo'] = idAtivo;   // <- trocado
      if (performance != null) dataMap['performance'] = performance;

      // Arquivo (opcional)
      if (kIsWeb) {
        if (arquivoWeb != null && arquivoBytes != null) {
          dataMap['arquivo'] = MultipartFile.fromBytes(
            arquivoBytes,
            filename: arquivoWeb.name,
            contentType: MediaType('application', 'octet-stream'),
          );
          dataMap['arquivo_robo'] = dataMap['arquivo']; // compatibilidade
        }
      } else if (arquivoMobile != null) {
        final mf = await MultipartFile.fromFile(
          arquivoMobile.path,
          filename: arquivoMobile.path.split('/').last,
        );
        dataMap['arquivo'] = mf;
        dataMap['arquivo_robo'] = mf; // compatibilidade
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dio.put(
        '${ApiConfig.baseUrl}${ApiConfig.robosEndpoint}/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao editar robô: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Erro ao editar robô (Dio): $e');
      rethrow;
    }
  }

  /// DELETE /robos/{id}
  Future<void> excluirRobo(int roboId) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado.');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.robosEndpoint}/$roboId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao excluir robô: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao excluir robô: $e');
      rethrow;
    }
  }

  /// GET /robos/download/:id
  Future<void> baixarArquivo(int roboId, String nomeRobo) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado');

      final url = Uri.parse('${ApiConfig.baseUrl}/robos/download/$roboId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // use o nome direto, sanitizado
        String fileName = 'arquivo_${_sanitizeFileName(nomeRobo)}.ex5';

        final blob = html.Blob([response.bodyBytes]);
        final urlDownload = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: urlDownload)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(urlDownload);
      } else if (response.statusCode == 401) {
        throw Exception("Não autorizado. Faça login novamente.");
      } else {
        throw Exception("Erro ao baixar arquivo: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro no download do robô: $e");
      rethrow;
    }
  }

  String _sanitizeFileName(String input) {
    return input
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(' ', '_')
        .toLowerCase();
  }
}
