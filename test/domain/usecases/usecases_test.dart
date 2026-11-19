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

  test('GetMovieList pede a primeira página por padrão', () async {
    final page = moviePage([inception]);
    when(
      () => repository.getMovieList(MovieListType.upcoming, page: 1),
    ).thenAnswer((_) async => page);

    expect(await GetMovieList(repository)(MovieListType.upcoming), page);
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

  test('SearchMovies repassa termo e página', () async {
    final page = moviePage([inception], page: 2);
    when(
      () => repository.searchMovies('matrix', page: 2),
    ).thenAnswer((_) async => page);

    expect(await SearchMovies(repository)('matrix', page: 2), page);
  });

  test('os casos de uso propagam MovieFetchException', () {
    when(
      () => repository.searchMovies(any(), page: any(named: 'page')),
    ).thenThrow(const MovieFetchException('falhou'));

    expect(
      () => SearchMovies(repository)('matrix'),
      throwsA(isA<MovieFetchException>()),
    );
  });
}