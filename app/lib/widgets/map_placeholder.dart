import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Espaço reservado para o mapa até a integração real.
class MapPlaceholder extends StatelessWidget {
  final String label;
  final double height;

  const MapPlaceholder({super.key, required this.label, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Center(child: Text(label)),
    );
  }
}