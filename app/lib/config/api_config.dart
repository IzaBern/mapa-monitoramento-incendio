/// Endereço da API (backend Node/Express).
///
/// Não precisa editar o código: passe o endereço ao rodar o app.
///   Windows/Web:        flutter run -d windows
///   Emulador Android:   flutter run --dart-define=API_URL=http://10.0.2.2:3000
///   Celular físico:     flutter run --dart-define=API_URL=http://SEU_IP:3000
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );
}
