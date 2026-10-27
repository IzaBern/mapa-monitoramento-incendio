import 'dart:convert';

import 'package:app/config/api_config.dart';
import 'package:app/models/occurrence.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class LoginResult {
  final int usuarioId;
  final String nome;
  const LoginResult({required this.usuarioId, required this.nome});
}

/// Única classe que conversa com o backend. As telas só chamam estes métodos.
class ApiService {
  static const _timeout = Duration(seconds: 10);
  static const _headers = {'Content-Type': 'application/json'};

  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  static dynamic _decode(http.Response res) {
    final corpo = utf8.decode(res.bodyBytes);
    final json = corpo.isEmpty ? <String, dynamic>{} : jsonDecode(corpo);
    if (res.statusCode >= 400) {
      final msg = (json is Map && json['erro'] != null)
          ? json['erro'].toString()
          : 'Erro ${res.statusCode}';
      throw ApiException(msg);
    }
    return json;
  }

  static ApiException _semConexao() => ApiException(
        'Não foi possível conectar à API (${ApiConfig.baseUrl}). '
        'Ela está rodando? O endereço está certo?',
      );

  /// POST /api/usuarios/login  (acha o usuário pelo e-mail ou cria na hora)
  static Future<LoginResult> login({required String email, String? nome}) async {
    try {
      final res = await http
          .post(
            _uri('/api/usuarios/login'),
            headers: _headers,
            body: jsonEncode({'email': email, 'nome': nome}),
          )
          .timeout(_timeout);
      final json = _decode(res) as Map<String, dynamic>;
      return LoginResult(
        usuarioId: json['usuario_id'] as int,
        nome: (json['nome'] ?? 'Usuário').toString(),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw _semConexao();
    }
  }

  /// GET /api/ocorrencias
  static Future<List<Occurrence>> listarOcorrencias() async {
    try {
      final res = await http.get(_uri('/api/ocorrencias')).timeout(_timeout);
      final json = _decode(res) as Map<String, dynamic>;
      final lista = (json['focos'] as List).cast<Map<String, dynamic>>();
      return lista.map(Occurrence.fromJson).toList();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw _semConexao();
    }
  }

  /// POST /api/ocorrencias
  static Future<void> criarOcorrencia({
    required int? usuarioId,
    required double latitude,
    required double longitude,
    required String vegetacao,
    String? fotoBase64,
  }) async {
    try {
      final res = await http
          .post(
            _uri('/api/ocorrencias'),
            headers: _headers,
            body: jsonEncode({
              'usuario_id': usuarioId,
              'latitude': latitude,
              'longitude': longitude,
              'tipo_vegetacao': vegetacao,
              'foto_base64': fotoBase64,
            }),
          )
          .timeout(const Duration(seconds: 30));
      _decode(res);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw _semConexao();
    }
  }

  /// PATCH /api/ocorrencias/:id/status
  static Future<void> alterarStatus(int id, OccurrenceStatus status) async {
    try {
      final res = await http
          .patch(
            _uri('/api/ocorrencias/$id/status'),
            headers: _headers,
            body: jsonEncode({'status': status.apiValue}),
          )
          .timeout(_timeout);
      _decode(res);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw _semConexao();
    }
  }
}
