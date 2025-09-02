class CarteiraModel {
  final int? id;
  String nome;

  CarteiraModel({
    this.id,
    required this.nome,
  });

  CarteiraModel copyWith({int? id, String? nome}) {
    return CarteiraModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  factory CarteiraModel.fromJson(Map<String, dynamic> json) {
    return CarteiraModel(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
