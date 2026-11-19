import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockMovieRemoteDataSource dataSource;
  late MovieRepositoryImpl repository;

  setUp(() {
    dataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(dataSource);
  });

  test('getMovieList delega ao data source com a página', () async {
    final page = moviePage([inception], page: 2);
    when(
      () => dataSource.getMovieList(MovieListType.topRated, page: 2),
    ).thenAnswer((_) async => page);

    expect(
      await repository.getMovieList(MovieListType.topRated, page: 2),
      page,
    );
  });

  test('getMovieDetails delega ao data source', () async {
    when(
      () => dataSource.getMovieDetails(const MovieId(27205)),
    ).thenAnswer((_) async => inceptionDetails);

    expect(
      await repository.getMovieDetails(const MovieId(27205)),
      inceptionDetails,
    );
  });

  test('searchMovies delega ao data source com a página', () async {
    final page = moviePage([inception], page: 3);
    when(
      () => dataSource.searchMovies('inception', page: 3),
    ).thenAnswer((_) async => page);

    expect(await repository.searchMovies('inception', page: 3), page);
  });
}