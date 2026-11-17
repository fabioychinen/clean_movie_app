import 'package:clean_movie_app/domain/entities/movie.dart';

/// Converte um item de `results` da TMDB em [Movie].
/// Lança [FormatException] se o formato não for o esperado — um filme sem
/// título ou nota é dado corrompido, não algo a mascarar com valor padrão.
Movie movieFromJson(Object? json) {
  if (json
      case {
        'title': final String title,
        'vote_average': final num voteAverage,
        'poster_path': final String? posterPath,
        'release_date': final String? releaseDate,
        'overview': final String? overview,
      }) {
    return Movie(
      title: title,
      voteAverage: voteAverage.toDouble(),
      posterPath: _nullIfEmpty(posterPath),
      // A TMDB manda "" para filmes sem data; data não vazia e inválida
      // faz DateTime.parse lançar FormatException.
      releaseDate: switch (_nullIfEmpty(releaseDate)) {
        final String date => DateTime.parse(date),
        null => null,
      },
      overview: _nullIfEmpty(overview),
    );
  }
  throw FormatException('Filme da TMDB em formato inesperado', json);
}

String? _nullIfEmpty(String? value) =>
    (value == null || value.isEmpty) ? null : value;
