import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/services/api_service.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/occurrences_loader.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class VerifierPage extends StatelessWidget {
  const VerifierPage({super.key});

  Future<void> _mudarStatus(
    BuildContext context,
    int id,
    OccurrenceStatus status,
    Future<void> Function() recarregar,
  ) async {
    try {
      await ApiService.alterarStatus(id, status);
      await recarregar();
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: UserRole.verificador,
      body: OccurrencesLoader(
        builder: (context, todas, recarregar) {
          final pendentes =
              todas.where((o) => o.status == OccurrenceStatus.pending).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: SectionTitle("Ocorrências pendentes (${pendentes.length})"),
                  ),
                  IconButton(
                    tooltip: 'Atualizar',
                    onPressed: recarregar,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              ...pendentes.map(
                (o) => OccurrenceCard(
                  occurrence: o,
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _mudarStatus(
                          context, o.id, OccurrenceStatus.denied, recarregar),
                      icon: const Icon(Icons.close),
                      label: const Text('Negar'),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () => _mudarStatus(
                          context, o.id, OccurrenceStatus.verified, recarregar),
                      icon: const Icon(Icons.check),
                      label: const Text('Verificar'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
