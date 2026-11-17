import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockMovieRepository repository;
  late GetFreeToWatchMovies getFreeToWatchMovies;

  setUp(() {
    repository = MockMovieRepository();
    getFreeToWatchMovies = GetFreeToWatchMovies(repository);
  });

  test('retorna os filmes grátis do repositório', () async {
    when(
      () => repository.getFreeToWatchMovies(),
    ).thenAnswer((_) async => [inception]);

    expect(await getFreeToWatchMovies(), [inception]);
  });

  test('propaga MovieFetchException', () {
    when(
      () => repository.getFreeToWatchMovies(),
    ).thenThrow(const MovieFetchException('falhou'));

    expect(() => getFreeToWatchMovies(), throwsA(isA<MovieFetchException>()));
  });
}
