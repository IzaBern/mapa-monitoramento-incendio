import 'package:app/models/user_role.dart';

class Actor {
  final String nome;
  final String cpf;
  final String usuario;
  final String senha;
  final UserRole role;

  const Actor({
    required this.nome,
    required this.cpf,
    required this.usuario,
    required this.senha,
    required this.role,
  });
}