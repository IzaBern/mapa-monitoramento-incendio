import 'dart:convert';
import 'dart:typed_data';

import 'package:app/services/api_service.dart';
import 'package:app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterOccurrencePage extends StatefulWidget {
  final int? usuarioId;
  const RegisterOccurrencePage({super.key, this.usuarioId});

  @override
  State<RegisterOccurrencePage> createState() => _RegisterOccurrencePageState();
}

class _RegisterOccurrencePageState extends State<RegisterOccurrencePage> {
  static const _vegetacoes = ['Cerrado', 'Pastagem', 'Lavoura', 'Mata'];

  // Começa em Rio Verde-GO. Troque pelos dados reais do local do foco.
  final _lat = TextEditingController(text: '-17.7923');
  final _lng = TextEditingController(text: '-50.9192');
  String _vegetacao = _vegetacoes.first;
  Uint8List? _foto;
  bool _enviando = false;

  @override
  void dispose() {
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  void _aviso(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _escolherFoto() async {
    final arquivo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (arquivo == null) return;
    final bytes = await arquivo.readAsBytes();
    if (!mounted) return;
    setState(() => _foto = bytes);
  }

  Future<void> _enviar() async {
    final lat = double.tryParse(_lat.text.trim().replaceAll(',', '.'));
    final lng = double.tryParse(_lng.text.trim().replaceAll(',', '.'));
    if (lat == null || lng == null) {
      _aviso('Latitude e longitude inválidas.');
      return;
    }
    if (_foto == null) {
      _aviso('Escolha uma foto do foco.');
      return;
    }

    setState(() => _enviando = true);
    try {
      await ApiService.criarOcorrencia(
        usuarioId: widget.usuarioId,
        latitude: lat,
        longitude: lng,
        vegetacao: _vegetacao,
        fotoBase64: 'data:image/jpeg;base64,${base64Encode(_foto!)}',
      );
      if (!mounted) return;
      Navigator.pop(context, true); // true = cadastrou; a tela anterior recarrega
    } on ApiException catch (e) {
      _aviso(e.message);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: const Text('Registrar ocorrência'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InkWell(
                onTap: _escolherFoto,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _foto == null
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera, size: 40),
                              SizedBox(height: 8),
                              Text('Toque para escolher a foto do foco'),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            _foto!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownMenu<String>(
                initialSelection: _vegetacao,
                label: const Text('Tipo de vegetação'),
                expandedInsets: EdgeInsets.zero,
                dropdownMenuEntries: _vegetacoes
                    .map((v) => DropdownMenuEntry(value: v, label: v))
                    .toList(),
                onSelected: (v) {
                  if (v != null) setState(() => _vegetacao = v);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lat,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  prefixIcon: Icon(Icons.my_location),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lng,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  prefixIcon: Icon(Icons.my_location),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: _enviando ? null : _enviar,
                icon: _enviando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_enviando ? 'Enviando...' : 'Enviar ocorrência'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
