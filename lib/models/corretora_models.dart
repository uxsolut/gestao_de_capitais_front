class Corretora {
  final int id;
  final String nome;
  final String? cnpj;
  final String? telefone;
  final String? email;

  Corretora({
    required this.id,
    required this.nome,
    this.cnpj,
    this.telefone,
    this.email,
  });

  factory Corretora.fromJson(Map<String, dynamic> json) {
    return Corretora(
      id: json['id'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
      'email': email,
    };
  }
}

class CorretoraCreate {
  final String nome;
  final String? cnpj;
  final String? telefone;
  final String? email;

  CorretoraCreate({
    required this.nome,
    this.cnpj,
    this.telefone,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
      'email': email,
    };
  }
}
