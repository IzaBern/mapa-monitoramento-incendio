import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

enum OccurrenceStatus { pending, verified, denied, mobilized, completed }

extension OccurrenceStatusX on OccurrenceStatus {
  String get label => switch (this) {
        OccurrenceStatus.pending => "Pendente",
        OccurrenceStatus.verified => "Verificada",
        OccurrenceStatus.denied => "Negada",
        OccurrenceStatus.mobilized => "Equipe mobilizada",
        OccurrenceStatus.completed => "Concluída",
      };

  Color get color => switch (this) {
        OccurrenceStatus.pending => AppColors.statusPending,
        OccurrenceStatus.verified => AppColors.statusVerified,
        OccurrenceStatus.denied => AppColors.statusDenied,
        OccurrenceStatus.mobilized => AppColors.statusMobilized,
        OccurrenceStatus.completed => AppColors.statusCompleted,
      };
}

class Occurrence {
  final int id;
  final String local;
  final String vegetacao;
  final String dataHora;
  final OccurrenceStatus status;

  const Occurrence({
    required this.id,
    required this.local,
    required this.vegetacao,
    required this.dataHora,
    required this.status,
  });
}