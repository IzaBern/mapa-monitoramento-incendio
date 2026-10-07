import 'package:app/data/mock_data.dart';
import 'package:app/models/user_role.dart';
import 'package:app/pages/admin/admin_page.dart';
import 'package:app/pages/authority/authority_page.dart';
import 'package:app/pages/user/user_page.dart';
import 'package:app/pages/verifier/verifier_page.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuario = TextEditingController();
  final _senha = TextEditingController();

  @override
  void dispose() {
    _usuario.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _abrir(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // Usuário comum: gov.br leva direto para a página do usuário.
  void _entrarComGovBr() => _abrir(const UserPage());

  // Atores internos: usuário e senha definem a página pelo papel.
  void _entrarInterno() {
    final usuario = _usuario.text.trim().toLowerCase();
    final senha = _senha.text;

    final ator = mockActors
        .where((a) => a.usuario.toLowerCase() == usuario && a.senha == senha)
        .firstOrNull;

    if (ator == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos.')),
        );
      return;
    }

    _senha.clear();
    _abrir(_paginaDoPapel(ator.role));
  }

  Widget _paginaDoPapel(UserRole role) => switch (role) {
    UserRole.user => const UserPage(),
    UserRole.verificador => const VerifierPage(),
    UserRole.autoridade => const AuthorityPage(),
    UserRole.admin => const AdminPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight(700),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _entrarComGovBr,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.govBR,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.badge_outlined, size: 22),
                            SizedBox(width: 12),
                            Text(
                              'Entrar com gov.br',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight(600),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Primeira vez? Ao entrar com o gov.br, seu cadastro é criado automaticamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    ExpansionTile(
                      title: const Text(
                        'Acesso interno (testes e administração)',
                        style: TextStyle(fontSize: 14),
                      ),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      childrenPadding: const EdgeInsets.only(top: 10),
                      children: [
                        const SizedBox(height: 10),
                        TextField(
                          controller: _usuario,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              size: 28,
                              color: AppColors.primary,
                            ),
                            labelText: 'Usuário',
                            hintText: 'Digite seu usuário',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _senha,
                          obscureText: true,
                          onSubmitted: (_) => _entrarInterno(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 28,
                              color: AppColors.primary,
                            ),
                            labelText: 'Senha',
                            hintText: 'Digite sua senha',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            onPressed: _entrarInterno,
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight(600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
