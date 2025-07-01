import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/movie_repository_test.dart';

void main() {
  late GetFreeToWatchMovies getFreeToWatchMovies;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    getFreeToWatchMovies = GetFreeToWatchMovies(mockRepository);
  });

  test('returns a list of free to watch movies from the repository', () async {
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

    when(() => mockRepository.getFreeToWatchMovies())
        .thenAnswer((_) async => expectedMovies);

    final result = await getFreeToWatchMovies();

    expect(result, expectedMovies);
    verify(() => mockRepository.getFreeToWatchMovies()).called(1);
  });

  test('handles error from repository', () async {
    when(() => mockRepository.getFreeToWatchMovies())
        .thenThrow(Exception('Failed to fetch free to watch movies'));

    expect(() => getFreeToWatchMovies(), throwsException);
  });
}