import 'package:clean_movie_app/data/models/json_fields.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';

Movie movieFromJson(Object? json) {
  if (json case {
        'id': final int id,
        'title': final String title,
        'vote_average': final num voteAverage,
      } &&
      final Map<Object?, Object?> fields) {
    return Movie(
      id: MovieId(id),
      title: title,
      voteAverage: voteAverage.toDouble(),
      posterPath: optionalString(fields, 'poster_path'),
      releaseDate: switch (optionalString(fields, 'release_date')) {
        final String date => DateTime.parse(date),
        null => null,
      },
      overview: optionalString(fields, 'overview'),
    );
  }
  throw FormatException('Filme da TMDB em formato inesperado', json);
}

List<Movie> movieListFromJson(Object? json) {
  if (json case {'results': final List<Object?> results}) {
    return results.map(movieFromJson).toList();
  }
  throw FormatException('Resposta sem a lista "results"', json);
}