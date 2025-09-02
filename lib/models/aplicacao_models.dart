class Aplicacao {
  final int id;
  final String nome;
  final String tipo;
  final int? idVersaoAplicacao;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Aplicacao({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.idVersaoAplicacao,
    this.criadoEm,
    this.atualizadoEm,
  });

  factory Aplicacao.fromJson(Map<String, dynamic> json) {
    return Aplicacao(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      idVersaoAplicacao: json['id_versao_aplicacao'],
      criadoEm: json['criado_em'] != null ? DateTime.parse(json['criado_em']) : null,
      atualizadoEm: json['atualizado_em'] != null ? DateTime.parse(json['atualizado_em']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'id_versao_aplicacao': idVersaoAplicacao,
    };
  }
}
