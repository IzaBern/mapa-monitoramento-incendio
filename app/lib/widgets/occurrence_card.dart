import 'package:app/models/occurrence.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class OccurrenceCard extends StatelessWidget {
  final Occurrence occurrence;

  /// Widget opcional à direita do card (ex.: menu de status do admin).
  final Widget? trailing;

  /// Botões opcionais abaixo do card (ex.: Verificar/Negar do verificador).
  final List<Widget> actions;

  const OccurrenceCard({
    super.key,
    required this.occurrence,
    this.trailing,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Text("Foto")),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        occurrence.local,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${occurrence.dataHora} · ${occurrence.vegetacao}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      StatusChip(occurrence.status),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(spacing: 8, runSpacing: 8, children: actions),
              ),
            ],
          ],
        ),
      ),
    );
  }
}