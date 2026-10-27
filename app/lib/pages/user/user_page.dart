import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/pages/user/register_occurrence_page.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/occurrence_map.dart';
import 'package:app/widgets/occurrences_loader.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final int? usuarioId;
  final String? nome;

  const UserPage({super.key, this.usuarioId, this.nome});

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: UserRole.user,
      body: OccurrencesLoader(
        builder: (context, todas, recarregar) {
          // Regras do projeto: o mapa mostra só verificadas/mobilizadas;
          // "Minhas ocorrências" mostra só as que este usuário cadastrou.
          final noMapa = todas
              .where(
                (o) =>
                    o.status == OccurrenceStatus.verified ||
                    o.status == OccurrenceStatus.mobilized,
              )
              .toList();
          final minhas = todas.where((o) => o.usuarioId == usuarioId).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (nome != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('Olá, $nome'),
                ),
              OccurrenceMap(ocorrencias: noMapa),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () async {
                    final cadastrou = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterOccurrencePage(usuarioId: usuarioId),
                      ),
                    );
                    if (cadastrou == true) {
                      await recarregar();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ocorrência enviada! Aguardando verificação.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.photo_camera),
                  label: const Text(
                    'Registrar ocorrência',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: SectionTitle("Minhas ocorrências")),
                  IconButton(
                    tooltip: 'Atualizar',
                    onPressed: recarregar,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              if (minhas.isEmpty)
                const Text('Você ainda não registrou nenhuma ocorrência.'),
              ...minhas.map((o) => OccurrenceCard(occurrence: o)),
            ],
          );
        },
      ),
    );
  }
}
