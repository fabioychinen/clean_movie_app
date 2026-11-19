import 'dart:math';

import 'package:clean_movie_app/data/models/json_fields.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';

Movie movieFromJson(Object? json) {
  if (json
      case {
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
      backdropPath: optionalString(fields, 'backdrop_path'),
      releaseDate: switch (optionalString(fields, 'release_date')) {
        final String date => DateTime.parse(date),
        null => null,
      },
      overview: optionalString(fields, 'overview'),
    );
  }
  throw FormatException('Filme da TMDB em formato inesperado', json);
}

MoviePage moviePageFromJson(Object? json, {required int maxPages}) {
  if (json case {
    'results': final List<Object?> results,
    'page': final int page,
    'total_pages': final int totalPages,
  }) {
    return MoviePage(
      movies: results.map(movieFromJson).toList(),
      page: page,
      totalPages: min(totalPages, maxPages),
    );
  }
  throw FormatException('Página de filmes em formato inesperado', json);
}