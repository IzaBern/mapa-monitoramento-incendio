import 'package:app/models/occurrence.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Mapa real (OpenStreetMap, sem chave de API) com um marcador por ocorrência.
/// Toque no marcador para ver foto, data/hora, vegetação e status.
class OccurrenceMap extends StatelessWidget {
  final List<Occurrence> ocorrencias;
  final double height;

  const OccurrenceMap({super.key, required this.ocorrencias, this.height = 280});

  @override
  Widget build(BuildContext context) {
    final comLocal = ocorrencias
        .where((o) => o.latitude != null && o.longitude != null)
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-16.0, -49.6), // centro de Goiás
            initialZoom: 6,
          ),
          children: [
            TileLayer(
  urlTemplate:
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
  userAgentPackageName: 'br.edu.projetointegrador.monitoramentoincendio',
),
RichAttributionWidget(
  attributions: [TextSourceAttribution('Tiles © Esri')],
),
            MarkerLayer(
              markers: comLocal
                  .map(
                    (o) => Marker(
                      point: LatLng(o.latitude!, o.longitude!),
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => mostrarDetalhesOcorrencia(context, o),
                        child: Icon(Icons.location_on, size: 44, color: o.status.color),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void mostrarDetalhesOcorrencia(BuildContext context, Occurrence o) {
  final foto = o.fotoBytes;
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Ocorrência #${o.id}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(foto, fit: BoxFit.cover),
              )
            else
              const Text('Sem foto'),
            const SizedBox(height: 12),
            Text('Local: ${o.local}'),
            Text('Data/hora: ${o.dataHora}'),
            Text('Vegetação: ${o.vegetacao}'),
            const SizedBox(height: 8),
            StatusChip(o.status),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    ),
  );
}
