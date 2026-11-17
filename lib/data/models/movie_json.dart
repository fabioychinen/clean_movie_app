import 'package:clean_movie_app/domain/entities/movie.dart';

Movie movieFromJson(Object? json) {
  if (json case {
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
