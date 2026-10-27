import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/services/api_service.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/occurrence_map.dart';
import 'package:app/widgets/occurrences_loader.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class AuthorityPage extends StatelessWidget {
  const AuthorityPage({super.key});

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
      role: UserRole.autoridade,
      body: OccurrencesLoader(
        builder: (context, todas, recarregar) {
          final ocorrencias = todas
              .where(
                (o) =>
                    o.status == OccurrenceStatus.verified ||
                    o.status == OccurrenceStatus.mobilized,
              )
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              OccurrenceMap(ocorrencias: ocorrencias, height: 220),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SectionTitle(
                      "Ocorrências em atendimento (${ocorrencias.length})",
                    ),
                  ),
                  IconButton(
                    tooltip: 'Atualizar',
                    onPressed: recarregar,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              ...ocorrencias.map((o) {
                final mobilizada = o.status == OccurrenceStatus.mobilized;
                return OccurrenceCard(
                  occurrence: o,
                  actions: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: mobilizada
                            ? AppColors.statusCompleted
                            : AppColors.statusMobilized,
                      ),
                      onPressed: () => _mudarStatus(
                        context,
                        o.id,
                        mobilizada
                            ? OccurrenceStatus.completed
                            : OccurrenceStatus.mobilized,
                        recarregar,
                      ),
                      icon: Icon(
                        mobilizada ? Icons.task_alt : Icons.local_fire_department,
                      ),
                      label: Text(
                        mobilizada ? 'Marcar como concluída' : 'Mobilizar equipe',
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
