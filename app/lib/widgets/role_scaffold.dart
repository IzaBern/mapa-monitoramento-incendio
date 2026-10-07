import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class RoleScaffold extends StatelessWidget {
  final UserRole role;
  final Widget body;

  /// Opcional: usado pelo admin para exibir as abas (TabBar) na AppBar.
  final PreferredSizeWidget? bottom;

  const RoleScaffold({
    super.key,
    required this.role,
    required this.body,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(role.icon),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Painel — ${role.label}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
        bottom: bottom,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: body,
        ),
      ),
    );
  }
}