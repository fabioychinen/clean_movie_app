import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockMovieRepository repository;
  late GetPopularMovies getPopularMovies;

  setUp(() {
    repository = MockMovieRepository();
    getPopularMovies = GetPopularMovies(repository);
  });

  test('retorna os filmes populares do repositório', () async {
    when(() => repository.getPopularMovies()).thenAnswer((_) async => [inception]);

    expect(await getPopularMovies(), [inception]);
  });

  test('propaga MovieFetchException', () {
    when(() => repository.getPopularMovies())
        .thenThrow(const MovieFetchException('falhou'));

    expect(() => getPopularMovies(), throwsA(isA<MovieFetchException>()));
  });
}
