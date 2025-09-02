// lib/models/resultado.dart

class Resultado {
  final int id;
  final String? descricao;

  Resultado({
    required this.id,
    this.descricao,
  });

  factory Resultado.fromJson(Map<String, dynamic> json) {
    return Resultado(
      id: json['id'] as int,
      descricao: json['descricao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }
}
