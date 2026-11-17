/// Falha ao obter filmes (rede, timeout, HTTP ou resposta malformada).
/// [cause] preserva o erro original para diagnóstico.
class MovieFetchException implements Exception {
  final String message;
  final Object? cause;

  const MovieFetchException(this.message, {this.cause});

  @override
  String toString() => cause == null
      ? 'MovieFetchException: $message'
      : 'MovieFetchException: $message (causa: $cause)';
}
