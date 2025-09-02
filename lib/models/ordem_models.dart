class Ordem {
  final int id;
  final String comentarioOrdem;
  final int? idRoboUser;
  final int? idUser;
  final String? numeroUnico;
  final int? quantidade;
  final double? preco;
  final String? contaMetaTrader;
  final String? tipo;
  final DateTime? criadoEm;

  Ordem({
    required this.id,
    required this.comentarioOrdem,
    this.idRoboUser,
    this.idUser,
    this.numeroUnico,
    this.quantidade,
    this.preco,
    this.contaMetaTrader,
    this.tipo,
    this.criadoEm,
  });

  factory Ordem.fromJson(Map<String, dynamic> json) {
    return Ordem(
      id: json['id'] as int,
      comentarioOrdem: json['comentario_ordem'] as String,
      idRoboUser: json['id_robo_user'] as int?,
      idUser: json['id_user'] as int?,
      numeroUnico: json['numero_unico'] as String?,
      quantidade: json['quantidade'] as int?,
      preco: json['preco']?.toDouble(),
      contaMetaTrader: json['conta_meta_trader'] as String?,
      tipo: json['tipo'] as String?,
      criadoEm: json['criado_em'] != null
          ? DateTime.parse(json['criado_em'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comentario_ordem': comentarioOrdem,
      'id_robo_user': idRoboUser,
      'id_user': idUser,
      'numero_unico': numeroUnico,
      'quantidade': quantidade,
      'preco': preco,
      'conta_meta_trader': contaMetaTrader,
      'tipo': tipo,
      'criado_em': criadoEm?.toIso8601String(),
    };
  }
}

class OrdemCreate {
  final String comentarioOrdem;
  final int? idRoboUser;
  final int? idUser;
  final String? numeroUnico;
  final int? quantidade;
  final double? preco;
  final String? contaMetaTrader;
  final String? tipo;

  OrdemCreate({
    required this.comentarioOrdem,
    this.idRoboUser,
    this.idUser,
    this.numeroUnico,
    this.quantidade,
    this.preco,
    this.contaMetaTrader,
    this.tipo,
  });

  Map<String, dynamic> toJson() {
    return {
      'comentario_ordem': comentarioOrdem,
      'id_robo_user': idRoboUser,
      'id_user': idUser,
      'numero_unico': numeroUnico,
      'quantidade': quantidade,
      'preco': preco,
      'conta_meta_trader': contaMetaTrader,
      'tipo': tipo,
    };
  }
}

