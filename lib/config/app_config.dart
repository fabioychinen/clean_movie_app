/// Configuração injetada no build via `--dart-define-from-file=env.json`
/// (Twelve-Factor: a config vive fora do código-fonte e nunca é commitada).
class AppConfig {
  final String tmdbApiKey;
  final String tmdbBaseUrl;

  const AppConfig({required this.tmdbApiKey, required this.tmdbBaseUrl});

  /// Lança [StateError] se alguma variável estiver ausente: melhor o app
  /// não abrir do que abrir e falhar em silêncio em cada requisição.
  factory AppConfig.fromEnvironment() {
    return AppConfig(
      tmdbApiKey: _require(
        'TMDB_API_KEY',
        const String.fromEnvironment('TMDB_API_KEY'),
      ),
      tmdbBaseUrl: _require(
        'TMDB_BASE_URL',
        const String.fromEnvironment('TMDB_BASE_URL'),
      ),
    );
  }

  static String _require(String name, String value) {
    if (value.isEmpty) {
      throw StateError(
        '$name não definida. Rode com --dart-define-from-file=env.json '
        '(veja env.example.json).',
      );
    }
    return value;
  }
}
