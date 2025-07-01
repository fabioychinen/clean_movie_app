import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';
import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

void main() {
  late MovieRepository repository;
  late MockMovieRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(mockDataSource);
  });

  group('MovieRepositoryImpl', () {
    final moviesList = [
      Movie(
        title: 'Filme Teste',
        posterPath: '/poster.png',
        overview: 'Descrição',
        releaseDate: '2024-07-01',
        voteAverage: 8.0,
      ),
    ];

    test('deve retornar uma lista de filmes populares', () async {
      when(() => mockDataSource.getPopularMovies())
          .thenAnswer((_) async => moviesList);

      final result = await repository.getPopularMovies();

      expect(result, moviesList);
      verify(() => mockDataSource.getPopularMovies()).called(1);
    });

    test('deve retornar uma lista de filmes grátis para assistir', () async {
      when(() => mockDataSource.getFreeToWatchMovies())
          .thenAnswer((_) async => moviesList);

      final result = await repository.getFreeToWatchMovies();

      expect(result, moviesList);
      verify(() => mockDataSource.getFreeToWatchMovies()).called(1);
    });
  });
}