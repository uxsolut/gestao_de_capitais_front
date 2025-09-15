class RoboModel {
  final int id;
  final String nome;
  final String symbol; // manter compatibilidade, se não usar pode ficar vazio
  final DateTime? criadoEm;
  final List<String>? performance;

  /// novo: para preencher o dropdown no editar
  final int? idAtivo;

  /// opcional: útil se quiser desabilitar download quando não existir
  final bool? temArquivo;

  RoboModel({
    required this.id,
    required this.nome,
    required this.symbol,
    this.criadoEm,
    this.performance,
    this.idAtivo,
    this.temArquivo,
  });

  factory RoboModel.fromJson(Map<String, dynamic> json) {
    return RoboModel(
      id: json['id'],
      nome: json['nome'],
      symbol: json['symbol'] ?? '',
      criadoEm: json['criado_em'] != null ? DateTime.parse(json['criado_em']) : null,
      performance: (json['performance'] as List?)?.map((e) => e.toString()).toList(),
      idAtivo: json['id_ativo'],
      temArquivo: json['tem_arquivo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'symbol': symbol,
      'criado_em': criadoEm?.toIso8601String(),
      'performance': performance,
      'id_ativo': idAtivo,
      'tem_arquivo': temArquivo,
    };
  }
}

typedef Robo = RoboModel;
