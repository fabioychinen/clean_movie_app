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
      tmdbMovieJson(
        posterPath: '',
        backdropPath: null,
        releaseDate: null,
        overview: '',
      ),
    );

    expect(
      movie,
      const Movie(id: MovieId(27205), title: 'Inception', voteAverage: 8.8),
    );
  });

  test('aceita campos opcionais ausentes', () {
    final json =
        tmdbMovieJson()
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

  test('moviePageFromJson converte a página e limita o total', () {
    final page = moviePageFromJson(
      tmdbMoviePageJson(results: [tmdbMovieJson()], page: 2, totalPages: 500),
      maxPages: 20,
    );

    expect(page, moviePage([inception], page: 2, totalPages: 20));
  });

  test('moviePageFromJson exige results, page e total_pages', () {
    for (final key in ['results', 'page', 'total_pages']) {
      final json = tmdbMoviePageJson(results: const [])..remove(key);
      expect(
        () => moviePageFromJson(json, maxPages: 20),
        throwsFormatException,
        reason: key,
      );
    }
  });
}