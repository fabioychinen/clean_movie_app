import 'package:clean_movie_app/data/models/movie_json.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('converte um item completo da TMDB', () {
    expect(movieFromJson(tmdbMovieJson()), inception);
  });

  test('aceita vote_average inteiro', () {
    expect(movieFromJson(tmdbMovieJson(voteAverage: 7)).voteAverage, 7.0);
  });

  test('trata strings vazias e campos nulos como ausentes', () {
    final movie = movieFromJson(
      tmdbMovieJson(posterPath: '', releaseDate: null, overview: ''),
    );

    expect(
      movie,
      const Movie(id: MovieId(27205), title: 'Inception', voteAverage: 8.8),
    );
  });

  test('aceita campos opcionais ausentes', () {
    final json = tmdbMovieJson()
      ..remove('poster_path')
      ..remove('release_date')
      ..remove('overview');

    expect(movieFromJson(json).posterPath, isNull);
  });

  test('lança FormatException quando falta um campo obrigatório', () {
    for (final key in ['id', 'title', 'vote_average']) {
      final json = tmdbMovieJson()..remove(key);
      expect(() => movieFromJson(json), throwsFormatException, reason: key);
    }
  });

  test('lança FormatException quando um opcional tem o tipo errado', () {
    final json = tmdbMovieJson()..['poster_path'] = 42;

    expect(() => movieFromJson(json), throwsFormatException);
  });

  test('lança FormatException quando a data é inválida', () {
    expect(
      () => movieFromJson(tmdbMovieJson(releaseDate: 'ontem')),
      throwsFormatException,
    );
  });

  test('movieListFromJson exige a lista "results"', () {
    expect(
      movieListFromJson({
        'results': [tmdbMovieJson()],
      }),
      [inception],
    );
    expect(() => movieListFromJson({'page': 1}), throwsFormatException);
  });
}