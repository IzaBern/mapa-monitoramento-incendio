import 'package:app/pages/login_page.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          "Focos de incêndio em Goiás",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight(500),
          ),
        ),
        centerTitle: true,
      ),
      body: LoginPage(),
    );
  }
}
