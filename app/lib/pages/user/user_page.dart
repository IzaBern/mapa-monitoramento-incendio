import 'package:app/data/mock_data.dart';
import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/map_placeholder.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: UserRole.user,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MapPlaceholder(label: "Mapa de Goiás - Focos Verificados"),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {},
              icon: const Icon(Icons.photo_camera),
              label: const Text(
                'Registrar ocorrência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle("Minhas ocorrências"),
          ...mockMyOccurrences.map((o) => OccurrenceCard(occurrence: o)),
        ],
      ),
    );
  }
}