import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../config/api_config.dart';
import '../models/robo_model.dart';
import 'http_service.dart';

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
  /// Envia:
  /// - nome
  /// - id_ativo
  /// - performance (múltiplas chaves)
  /// - arquivo (arquivo principal)
  Future<Map<String, dynamic>> criarRobo({
    required String nome,
    required int idAtivo,
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

      // Monta como campos repetidos para o FastAPI ler List[str]
      final formData = FormData();
      formData.fields
        ..add(MapEntry('nome', nome))
        ..add(MapEntry('id_ativo', idAtivo.toString()));
      for (final p in performance) {
        formData.fields.add(MapEntry('performance', p));
      }
      // compatibilidade de chaves de arquivo
      formData.files
        ..add(MapEntry('arquivo', arquivo))
        ..add(MapEntry('arquivo_robo', arquivo));

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
  /// Envia **somente** os campos alterados.
  /// Para `performance`, envia múltiplas chaves se presente.
  Future<void> editarRobo({
    required int id,
    String? nome,
    int? idAtivo,
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

      final formData = FormData();

      if (nome != null) {
        formData.fields.add(MapEntry('nome', nome));
      }
      if (idAtivo != null) {
        formData.fields.add(MapEntry('id_ativo', idAtivo.toString()));
      }
      if (performance != null) {
        for (final p in performance) {
          formData.fields.add(MapEntry('performance', p));
        }
      }

      // Arquivo (opcional)
      if (kIsWeb) {
        if (arquivoWeb != null && arquivoBytes != null) {
          final mf = MultipartFile.fromBytes(
            arquivoBytes,
            filename: arquivoWeb.name,
            contentType: MediaType('application', 'octet-stream'),
          );
          formData.files
            ..add(MapEntry('arquivo', mf))
            ..add(MapEntry('arquivo_robo', mf));
        }
      } else if (arquivoMobile != null) {
        final mf = await MultipartFile.fromFile(
          arquivoMobile.path,
          filename: arquivoMobile.path.split('/').last,
        );
        formData.files
          ..add(MapEntry('arquivo', mf))
          ..add(MapEntry('arquivo_robo', mf));
      }

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

  /// GET /robos/download/:id  (implementado para Web)
  Future<void> baixarArquivo(int roboId, String nomeRobo) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) throw Exception('Token não encontrado');

      final url = Uri.parse('${ApiConfig.baseUrl}/robos/download/$roboId');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        if (!kIsWeb) {
          throw Exception('Download implementado apenas para Web neste app.');
        }

        final fileName = '${_sanitizeFileName('arquivo_$nomeRobo')}.ex5';
        final blob = html.Blob([response.bodyBytes]);
        final urlDownload = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: urlDownload)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(urlDownload);
      } else if (response.statusCode == 401) {
        throw Exception('Não autorizado. Faça login novamente.');
      } else {
        throw Exception('Erro ao baixar arquivo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no download do robô: $e');
      rethrow;
    }
  }

  String _sanitizeFileName(String input) {
    return input.replaceAll(RegExp(r'[^\w\s.-]'), '').replaceAll(' ', '_').toLowerCase();
  }
}
