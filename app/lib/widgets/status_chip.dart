import 'package:app/models/occurrence.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final OccurrenceStatus status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight(600),
          color: status.color,
        ),
      ),
    );
  }
}