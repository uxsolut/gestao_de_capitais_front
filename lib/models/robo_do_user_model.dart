class RoboDoUserModel {
  final int id;
  final bool ligado;
  final bool ativo;
  final bool temRequisicao;
  final int idRobo;
  final int? idConta;
  final int? idCarteira;
  final String nomeRobo;

  RoboDoUserModel({
    required this.id,
    required this.ligado,
    required this.ativo,
    required this.temRequisicao,
    required this.idRobo,
    this.idConta,
    this.idCarteira,
    required this.nomeRobo,
  });

  factory RoboDoUserModel.fromJson(Map<String, dynamic> json) {
    return RoboDoUserModel(
      id: json['id'],
      ligado: json['ligado'],
      ativo: json['ativo'],
      temRequisicao: json['tem_requisicao'],
      idRobo: json['id_robo'],
      idConta: json['id_conta'],
      idCarteira: json['id_carteira'],
      nomeRobo: json['nome_robo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ligado': ligado,
      'ativo': ativo,
      'tem_requisicao': temRequisicao,
      'id_robo': idRobo,
      'id_conta': idConta,
      'id_carteira': idCarteira,
      'nome_robo': nomeRobo,
    };
  }
}
