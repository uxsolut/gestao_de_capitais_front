// models/ativo_resumo.dart
class AtivoResumo {
  final int id;
  final String descricao;
  AtivoResumo({required this.id, required this.descricao});
  factory AtivoResumo.fromJson(Map<String,dynamic> j)
    => AtivoResumo(id: j['id'] as int, descricao: j['descricao'] ?? '');
}
