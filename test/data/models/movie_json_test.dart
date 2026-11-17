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

  test('trata strings vazias da TMDB como ausentes', () {
    final movie = movieFromJson(
      tmdbMovieJson(posterPath: '', releaseDate: '', overview: ''),
    );

    expect(movie.posterPath, isNull);
    expect(movie.releaseDate, isNull);
    expect(movie.overview, isNull);
  });

  test('aceita campos opcionais nulos', () {
    final movie = movieFromJson(
      tmdbMovieJson(posterPath: null, releaseDate: null, overview: null),
    );

    expect(movie, const Movie(title: 'Inception', voteAverage: 8.8));
  });

  test('lança FormatException quando falta o título', () {
    final json = tmdbMovieJson()..remove('title');

    expect(() => movieFromJson(json), throwsFormatException);
  });

  test('lança FormatException quando a data é inválida', () {
    expect(
      () => movieFromJson(tmdbMovieJson(releaseDate: 'ontem')),
      throwsFormatException,
    );
  });

  test('lança FormatException quando o item não é um objeto', () {
    expect(() => movieFromJson('não sou um filme'), throwsFormatException);
  });
}
