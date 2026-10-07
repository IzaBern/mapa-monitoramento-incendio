import 'package:app/data/mock_data.dart';
import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/role_scaffold.dart';
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
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),

            child: Center(child: Text("Mapa de Goiás - Focos Verificados")),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {},
              icon: Icon(Icons.photo_camera),
              label: Text(
                'Registrar ocorrência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Minhas ocorrências",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          ...mockOccurrences.map((o)=>OccurrenceCard(occurrence: o)),
        ],
      ),
    );
  }
}