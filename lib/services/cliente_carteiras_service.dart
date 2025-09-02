import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carteira_model.dart';
import '../models/lista_model.dart';
import '../config/api_config.dart';
import '../utils/token_storage.dart';

class ClienteCarteirasService {
  final String _baseUrl = '${ApiConfig.baseUrl}/carteiras';

  Future<List<CarteiraModel>> getCarteiras() async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: ApiConfig.authHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => CarteiraModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar carteiras');
    }
  }

  Future<CarteiraModel> criarCarteira(String nome) async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: ApiConfig.authHeaders(token),
      body: jsonEncode({'nome': nome}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CarteiraModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar carteira');
    }
  }

  Future<CarteiraModel> atualizarCarteira(int id, String novoNome) async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: ApiConfig.authHeaders(token),
      body: jsonEncode({'nome': novoNome}),
    );

    if (response.statusCode == 200) {
      return CarteiraModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar carteira');
    }
  }

  Future<void> excluirCarteira(int id) async {
    final token = await TokenStorage.getToken() ?? '';
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: ApiConfig.authHeaders(token),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao excluir carteira');
    }
  }

  ListaModel toListaModel(CarteiraModel model) {
    return ListaModel(
      id: model.id!,
      tituloItem: model.nome,
      descricao1: null,
      descricao2: null,
      descricao3: null,
      dataHora: null,
      tags: [],
      podeEditar: true,
      podeDeletar: true,
      podeBaixar: false,
    );
  }
}
