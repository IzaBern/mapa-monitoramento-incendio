import 'package:flutter/material.dart';
import 'package:app/styles/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 950, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight(700),
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          size: 28,
                          color: AppColors.primary,
                        ),
                        labelText: "Usuário",
                        hintText: "Digite seu usuário ou CPF",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 28,
                          color: AppColors.primary,
                        ),
                        labelText: "Senha",
                        hintText: "Digite sua senha",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.govBR,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
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
                    SizedBox(height: 40),
                    Text("Primeira vez? Realize seu cadastro."),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Cadastrar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
