class User {
  final int id;
  final String nome;
  final String email;
  final String? tipoDeUser;

  User({
    required this.id,
    required this.nome,
    required this.email,
    this.tipoDeUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      tipoDeUser: json['tipo_de_user'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo_de_user': tipoDeUser,
    };
  }
}

class LoginResponse {
  final int id;
  final String nome;
  final String email;
  final String token;
  final String accessToken;
  final User user;

  LoginResponse({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? {};

    return LoginResponse(
      id: userData['id'] ?? 0,
      nome: userData['nome'] ?? '',
      email: userData['email'] ?? '',
      token: json['access_token'] ?? '',
      accessToken: json['access_token'] ?? '',
      user: User.fromJson(userData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'token': token,
      'access_token': accessToken,
      'user': user.toJson(),
    };
  }
}
