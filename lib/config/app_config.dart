class AppConfig {
  final String tmdbReadAccessToken;
  final String tmdbBaseUrl;

  const AppConfig({
    required this.tmdbReadAccessToken,
    required this.tmdbBaseUrl,
  });

  factory AppConfig.fromEnvironment() {
    return AppConfig(
      tmdbReadAccessToken: _require(
        'TMDB_READ_ACCESS_TOKEN',
        const String.fromEnvironment('TMDB_READ_ACCESS_TOKEN'),
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
