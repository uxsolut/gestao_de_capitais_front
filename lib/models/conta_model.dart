class ContaModel {
  final int id;
  final String nome;
  final String contaMetaTrader;
  final double? margemTotal;
  final double? margemDisponivel;
  final int idCorretora;
  final String nomeCorretora;
  final int idCarteira;

  ContaModel({
    required this.id,
    required this.nome,
    required this.contaMetaTrader,
    required this.margemTotal,
    required this.margemDisponivel,
    required this.idCorretora,
    required this.nomeCorretora,
    required this.idCarteira,
  });

  factory ContaModel.fromJson(Map<String, dynamic> json) {
    return ContaModel(
      id: json['id'],
      nome: json['nome'],
      contaMetaTrader: json['conta_meta_trader'],
      margemTotal: (json['margem_total'] as num?)?.toDouble(),
      margemDisponivel: (json['margem_disponivel'] as num?)?.toDouble(),
      idCorretora: json['id_corretora'],
      nomeCorretora: json['nome_corretora'],
      idCarteira: json['id_carteira'],
    );
  }
}
