class RoboModel {
  final int id;
  final String nome;
  final String symbol; // se existir
  final DateTime? criadoEm; // se for usado no backend
  final List<String>? performance;

  RoboModel({
    required this.id,
    required this.nome,
    required this.symbol,
    this.criadoEm,
    this.performance,
  });

  factory RoboModel.fromJson(Map<String, dynamic> json) {
    return RoboModel(
      id: json['id'],
      nome: json['nome'],
      symbol: json['symbol'] ?? '',
      criadoEm: json['criado_em'] != null ? DateTime.parse(json['criado_em']) : null,
      performance: (json['performance'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'symbol': symbol,
      'criado_em': criadoEm?.toIso8601String(),
      'performance': performance,
    };
  }
}
