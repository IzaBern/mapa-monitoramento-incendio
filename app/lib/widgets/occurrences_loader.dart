import 'package:app/models/occurrence.dart';
import 'package:app/services/api_service.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Busca as ocorrências na API e entrega a lista para o [builder].
/// Mostra "carregando" e uma mensagem de erro com botão de tentar de novo.
class OccurrencesLoader extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    List<Occurrence> ocorrencias,
    Future<void> Function() recarregar,
  ) builder;

  const OccurrencesLoader({super.key, required this.builder});

  @override
  State<OccurrencesLoader> createState() => _OccurrencesLoaderState();
}

class _OccurrencesLoaderState extends State<OccurrencesLoader> {
  List<Occurrence>? _ocorrencias;
  String? _erro;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final lista = await ApiService.listarOcorrencias();
      if (!mounted) return;
      setState(() => _ocorrencias = lista);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.message);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando && _ocorrencias == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null && _ocorrencias == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppColors.accent),
              const SizedBox(height: 12),
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    return widget.builder(context, _ocorrencias ?? [], _carregar);
  }
}
