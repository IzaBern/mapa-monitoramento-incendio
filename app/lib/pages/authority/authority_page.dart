import 'package:app/data/mock_data.dart';
import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/map_placeholder.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class AuthorityPage extends StatelessWidget {
  const AuthorityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ocorrencias = mockOccurrences
        .where(
          (o) =>
              o.status == OccurrenceStatus.verified ||
              o.status == OccurrenceStatus.mobilized,
        )
        .toList();

    return RoleScaffold(
      role: UserRole.autoridade,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MapPlaceholder(
            label: "Mapa de Goiás - Focos Verificados",
            height: 160,
          ),
          const SizedBox(height: 20),
          SectionTitle("Ocorrências em atendimento (${ocorrencias.length})"),
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
                  onPressed: () {}, // TODO: mobilizar / concluir
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
      ),
    );
  }
}