class MovieFetchException implements Exception {
  final String message;
  final Object? cause;

  const MovieFetchException(this.message, {this.cause});

  @override
  String toString() =>
      cause == null
          ? 'MovieFetchException: $message'
          : 'MovieFetchException: $message (causa: $cause)';
}
