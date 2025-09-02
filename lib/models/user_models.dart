// lib/models/user.dart

class User {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final String cpf;
  final int? idCorretora;
  final String? tipoDeUser;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    this.idCorretora,
    this.tipoDeUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      cpf: json['cpf'] as String,
      idCorretora: json['id_corretora'] as int?,
      tipoDeUser: json['tipo_de_user'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'cpf': cpf,
      'id_corretora': idCorretora,
      'tipo_de_user': tipoDeUser,
    };
  }
}
