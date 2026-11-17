import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
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

  test('getPopularMovies delega ao data source', () async {
    when(() => dataSource.getPopularMovies()).thenAnswer((_) async => [inception]);

    expect(await repository.getPopularMovies(), [inception]);
  });

  test('getFreeToWatchMovies delega ao data source', () async {
    when(() => dataSource.getFreeToWatchMovies())
        .thenAnswer((_) async => [inception]);

    expect(await repository.getFreeToWatchMovies(), [inception]);
  });
}
