class Requisicao {
  final int id;
  final String? tipo;
  final String? comentarioOrdem;
  final String? symbol;
  final int? quantidade;
  final double? preco;
  final int? idRobo;
  final List<int>? idsContas;
  final DateTime? criadoEm;

  Requisicao({
    required this.id,
    this.tipo,
    this.comentarioOrdem,
    this.symbol,
    this.quantidade,
    this.preco,
    this.idRobo,
    this.idsContas,
    this.criadoEm,
  });

  factory Requisicao.fromJson(Map<String, dynamic> json) {
    return Requisicao(
      id: json['id'] as int,
      tipo: json['tipo'] as String?,
      comentarioOrdem: json['comentario_ordem'] as String?,
      symbol: json['symbol'] as String?,
      quantidade: json['quantidade'] as int?,
      preco: json['preco'] != null ? (json['preco'] as num).toDouble() : null,
      idRobo: json['id_robo'] as int?,
      idsContas: json['ids_contas'] != null
          ? List<int>.from((json['ids_contas'] as List<dynamic>).map((e) => e as int))
          : null,
      criadoEm: json['criado_em'] != null
          ? DateTime.parse(json['criado_em'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'comentario_ordem': comentarioOrdem,
      'symbol': symbol,
      'quantidade': quantidade,
      'preco': preco,
      'id_robo': idRobo,
      'ids_contas': idsContas,
      'criado_em': criadoEm?.toIso8601String(),
    };
  }
}
