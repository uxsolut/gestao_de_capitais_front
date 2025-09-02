import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/versao_aplicacao_models.dart';
import 'http_service.dart';
import 'package:file_picker/file_picker.dart';

class VersaoAplicacaoService {
  final HttpService _httpService = HttpService();

  /// POST /versoes_aplicacao/
  Future<VersaoAplicacao> criarVersaoAplicacao({
    required String descricao,
    required PlatformFile arquivo,
    required int idAplicacao,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/versoes_aplicacao/');
    final request = http.MultipartRequest('POST', uri);

    // Autenticação
    final token = await _httpService.getToken();
    request.headers['Authorization'] = 'Bearer $token';

    // Campos do formulário
    request.fields['descricao'] = descricao;
    request.fields['id_aplicacao'] = idAplicacao.toString();

    // Arquivo
    request.files.add(http.MultipartFile.fromBytes(
      'arquivo',
      arquivo.bytes!,
      filename: arquivo.name,
      contentType: MediaType('application', 'octet-stream'),
    ));

    // Enviar requisição
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VersaoAplicacao.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      _httpService.handleTokenExpired();
      throw Exception('Token expirado. Faça login novamente.');
    } else {
      throw Exception('Erro ao criar versão de aplicação: ${response.body}');
    }
  }
}
