abstract final class ApiConstants {
  static const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  /// Sem teto, uma rede travada deixaria a tela em "carregando" para sempre.
  static const requestTimeout = Duration(seconds: 10);
}
