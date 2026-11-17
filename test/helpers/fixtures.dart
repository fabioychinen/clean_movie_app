import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';

const testConfig = AppConfig(
  tmdbApiKey: 'test-key',
  tmdbBaseUrl: 'https://api.test/3',
);

final inception = Movie(
  title: 'Inception',
  voteAverage: 8.8,
  posterPath: '/inception.jpg',
  releaseDate: DateTime(2010, 7, 16),
  overview: 'A mind-bending thriller.',
);

/// Filme só com os campos obrigatórios (pôster, data e sinopse ausentes).
const sparseMovie = Movie(title: 'Sem Dados', voteAverage: 3.5);

/// Item de `results` exatamente como a TMDB devolve.
Map<String, Object?> tmdbMovieJson({
  String title = 'Inception',
  num voteAverage = 8.8,
  String? posterPath = '/inception.jpg',
  String? releaseDate = '2010-07-16',
  String? overview = 'A mind-bending thriller.',
}) {
  return {
    'title': title,
    'vote_average': voteAverage,
    'poster_path': posterPath,
    'release_date': releaseDate,
    'overview': overview,
  };
}
