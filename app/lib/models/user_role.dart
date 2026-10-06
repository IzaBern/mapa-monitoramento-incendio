import 'package:flutter/material.dart';

enum UserRole { user, verificador, autoridade, admin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.user => 'Usuário',
        UserRole.verificador => 'Verificador',
        UserRole.autoridade => 'Autoridade',
        UserRole.admin => 'Administrador',
      };

  IconData get icon => switch (this) {
        UserRole.user => Icons.person,
        UserRole.verificador => Icons.fact_check,
        UserRole.autoridade => Icons.local_fire_department,
        UserRole.admin => Icons.admin_panel_settings,
      };
}