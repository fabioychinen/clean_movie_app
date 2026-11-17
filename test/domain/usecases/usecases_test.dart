import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockMovieRepository repository;

  setUp(() => repository = MockMovieRepository());

  test('GetMovieList devolve a lista pedida', () async {
    when(
      () => repository.getMovieList(MovieListType.upcoming),
    ).thenAnswer((_) async => [inception]);

    expect(await GetMovieList(repository)(MovieListType.upcoming), [inception]);
  });

  test('GetMovieDetails devolve os detalhes do filme', () async {
    when(
      () => repository.getMovieDetails(const MovieId(27205)),
    ).thenAnswer((_) async => inceptionDetails);

    expect(
      await GetMovieDetails(repository)(const MovieId(27205)),
      inceptionDetails,
    );
  });

  test('SearchMovies devolve os resultados da busca', () async {
    when(
      () => repository.searchMovies('matrix'),
    ).thenAnswer((_) async => [inception]);

    expect(await SearchMovies(repository)('matrix'), [inception]);
  });

  test('os casos de uso propagam MovieFetchException', () {
    when(
      () => repository.searchMovies(any()),
    ).thenThrow(const MovieFetchException('falhou'));

    expect(
      () => SearchMovies(repository)('matrix'),
      throwsA(isA<MovieFetchException>()),
    );
  });
}