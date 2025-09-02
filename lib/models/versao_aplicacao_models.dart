class VersaoAplicacao {
  final int id;
  final String descricao;
  final int idUser;
  final int? idAplicacao; // ✅ novo campo
  final DateTime? dataVersao;
  final DateTime? criadoEm;

  VersaoAplicacao({
    required this.id,
    required this.descricao,
    required this.idUser,
    this.idAplicacao, // ✅ novo campo
    this.dataVersao,
    this.criadoEm,
  });

  factory VersaoAplicacao.fromJson(Map<String, dynamic> json) {
    return VersaoAplicacao(
      id: json['id'],
      descricao: json['descricao'],
      idUser: json['id_user'],
      idAplicacao: json['id_aplicacao'], // ✅ novo campo
      dataVersao: json['data_versao'] != null ? DateTime.parse(json['data_versao']) : null,
      criadoEm: json['criado_em'] != null ? DateTime.parse(json['criado_em']) : null,
    );
  }
}
