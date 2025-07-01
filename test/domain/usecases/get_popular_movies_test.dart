import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/movie_repository_test.dart';

void main() {
  late GetPopularMovies getPopularMovies;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    getPopularMovies = GetPopularMovies(mockRepository);
  });

  test('returns a list of popular movies from the repository', () async {
    final expectedMovies = [
      Movie(
        posterPath: '/poster_path_1.jpg',
        releaseDate: '2023-06-15',
        title: 'Movie 1',
        voteAverage: 8.0,
        overview: 'Overview of Movie 1',
      ),
      Movie(
        posterPath: '/poster_path_2.jpg',
        releaseDate: '2023-07-20',
        title: 'Movie 2',
        voteAverage: 7.5,
        overview: 'Overview of Movie 2',
      ),
    ];

    when(() => mockRepository.getPopularMovies())
        .thenAnswer((_) async => expectedMovies);

    final result = await getPopularMovies();

    expect(result, expectedMovies);
    verify(() => mockRepository.getPopularMovies()).called(1);
  });

  test('handles error from repository', () async {
    when(() => mockRepository.getPopularMovies())
        .thenThrow(Exception('Failed to fetch popular movies'));

    expect(() => getPopularMovies(), throwsException);
  });
}