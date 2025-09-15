class RoboModel {
  final int id;
  final String nome;
  final String symbol; // se existir
  final DateTime? criadoEm; // se for usado no backend
  final List<String>? performance;

  // >>> adição mínima: idAtivo opcional <<<
  final int? idAtivo;

  RoboModel({
    required this.id,
    required this.nome,
    required this.symbol,
    this.criadoEm,
    this.performance,
    this.idAtivo, // novo
  });

  factory RoboModel.fromJson(Map<String, dynamic> json) {
    return RoboModel(
      id: json['id'],
      nome: json['nome'],
      symbol: json['symbol'] ?? '',
      criadoEm: json['criado_em'] != null ? DateTime.parse(json['criado_em']) : null,
      performance: (json['performance'] as List?)?.map((e) => e.toString()).toList(),
      // >>> novo: lê do backend (id_ativo) quando vier <<<
      idAtivo: json['id_ativo'] is int ? json['id_ativo'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'symbol': symbol,
      'criado_em': criadoEm?.toIso8601String(),
      'performance': performance,
      // >>> mantém compat: envia id_ativo se existir <<<
      'id_ativo': idAtivo,
    };
  }
}

typedef Robo = RoboModel;
