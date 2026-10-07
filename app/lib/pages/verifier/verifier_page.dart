import 'package:app/data/mock_data.dart';
import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class VerifierPage extends StatelessWidget {
  const VerifierPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendentes = mockOccurrences
        .where((o) => o.status == OccurrenceStatus.pending)
        .toList();

    return RoleScaffold(
      role: UserRole.verificador,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionTitle("Ocorrências pendentes (${pendentes.length})"),
          ...pendentes.map(
            (o) => OccurrenceCard(
              occurrence: o,
              actions: [
                OutlinedButton.icon(
                  onPressed: () {}, // TODO: marcar como negada
                  icon: const Icon(Icons.close),
                  label: const Text('Negar'),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {}, // TODO: marcar como verificada
                  icon: const Icon(Icons.check),
                  label: const Text('Verificar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}