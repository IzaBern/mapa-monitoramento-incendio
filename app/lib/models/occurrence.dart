import 'dart:convert';
import 'dart:typed_data';

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

  /// Valor gravado na coluna `status` do PostgreSQL.
  String get apiValue => switch (this) {
        OccurrenceStatus.pending => 'pendente',
        OccurrenceStatus.verified => 'verificado',
        OccurrenceStatus.denied => 'negado',
        OccurrenceStatus.mobilized => 'mobilizada',
        OccurrenceStatus.completed => 'concluida',
      };

  static OccurrenceStatus fromApi(String? value) => switch (value) {
        'verificado' => OccurrenceStatus.verified,
        'negado' => OccurrenceStatus.denied,
        'mobilizada' => OccurrenceStatus.mobilized,
        'concluida' => OccurrenceStatus.completed,
        _ => OccurrenceStatus.pending,
      };
}

class Occurrence {
  final int id;
  final String local;
  final String vegetacao;
  final String dataHora;
  final OccurrenceStatus status;

  // Campos que só existem nos dados reais (vindos da API).
  final double? latitude;
  final double? longitude;
  final String? fotoBase64;
  final int? usuarioId;

  const Occurrence({
    required this.id,
    required this.local,
    required this.vegetacao,
    required this.dataHora,
    required this.status,
    this.latitude,
    this.longitude,
    this.fotoBase64,
    this.usuarioId,
  });

  /// Converte o JSON da API (GET /api/ocorrencias) em [Occurrence].
  factory Occurrence.fromJson(Map<String, dynamic> json) {
    // O PostgreSQL devolve DECIMAL como texto, por isso o toString().
    final lat = double.tryParse(json['latitude'].toString());
    final lng = double.tryParse(json['longitude'].toString());
    final data = DateTime.tryParse(json['data_hora']?.toString() ?? '')?.toLocal();

    String dois(int n) => n.toString().padLeft(2, '0');
    final dataFormatada = data == null
        ? '-'
        : '${dois(data.day)}/${dois(data.month)}/${data.year} '
            '${dois(data.hour)}:${dois(data.minute)}';

    return Occurrence(
      id: json['id'] as int,
      local: (lat != null && lng != null)
          ? '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}'
          : 'Local não informado',
      vegetacao: (json['tipo_vegetacao'] ?? '-').toString(),
      dataHora: dataFormatada,
      status: OccurrenceStatusX.fromApi(json['status']?.toString()),
      latitude: lat,
      longitude: lng,
      fotoBase64: json['foto_url']?.toString(),
      usuarioId: json['usuario_id'] as int?,
    );
  }

  /// Bytes da foto (a API devolve "data:image/jpeg;base64,XXXX").
  Uint8List? get fotoBytes {
    final f = fotoBase64;
    if (f == null || f.isEmpty) return null;
    try {
      final base64Puro = f.contains(',') ? f.split(',').last : f;
      return base64Decode(base64Puro);
    } catch (_) {
      return null;
    }
  }
}
