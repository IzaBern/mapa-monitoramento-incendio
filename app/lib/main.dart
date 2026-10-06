import 'package:app/pages/home_page.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Focos de incêndio em Goiás",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: AppColors.primary),
      home: HomePage(),
    ),
  );
}
