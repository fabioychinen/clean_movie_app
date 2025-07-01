import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:clean_movie_app/presentation/bloc/bloc/movie_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetFreeToWatchMovies extends Mock implements GetFreeToWatchMovies {}

void main() {
  late MovieBloc movieBloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetFreeToWatchMovies mockGetFreeToWatchMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetFreeToWatchMovies = MockGetFreeToWatchMovies();
    movieBloc = MovieBloc(
      getPopularMovies: mockGetPopularMovies,
      getFreeToWatchMovies: mockGetFreeToWatchMovies,
    );
  });

  tearDown(() {
    movieBloc.close();
  });

  test('initial state should be MovieLoading', () {
    expect(movieBloc.state, MovieLoading());
  });

  group('FetchPopularMovies event', () {
    final popularMovies = [
      Movie(
        posterPath: '/poster_path_1.jpg',
        releaseDate: '2023-06-15',
        title: 'Movie 1',
        voteAverage: 8.0,
        overview: 'Overview of Movie 1',
      ),
    ];

    test('emits [MovieLoading, MovieLoaded] when successful', () async {
      when(() => mockGetPopularMovies()).thenAnswer((_) async => popularMovies);

      movieBloc.add(FetchPopularMovies());
      await untilCalled(() => mockGetPopularMovies());

      verify(() => mockGetPopularMovies()).called(1);
      expect(
        movieBloc.stream,
        emitsInOrder([
          MovieLoading(),
          MovieLoaded(
              popularMovies: popularMovies, freeToWatchMovies: const []),
          emitsDone
        ]),
      );
    });

    test('emits [MovieLoading, MovieError] when unsuccessful', () async {
      const errorMessage = 'Failed to load popular movies';
      when(() => mockGetPopularMovies()).thenThrow(Exception(errorMessage));

      movieBloc.add(FetchPopularMovies());
      await untilCalled(() => mockGetPopularMovies());

      verify(() => mockGetPopularMovies()).called(1);
      expect(
        movieBloc.stream,
        emitsInOrder(
            [MovieLoading(), MovieError(message: errorMessage), emitsDone]),
      );
    });
  });

  group('FetchFreeToWatchMovies event', () {
    final freeToWatchMovies = [
      Movie(
        posterPath: '/poster_path_2.jpg',
        releaseDate: '2023-07-20',
        title: 'Movie 2',
        voteAverage: 7.5,
        overview: 'Overview of Movie 2',
      ),
    ];

    test('emits [MovieLoading, MovieLoaded] when successful', () async {
      when(() => mockGetFreeToWatchMovies())
          .thenAnswer((_) async => freeToWatchMovies);

      movieBloc.add(FetchFreeToWatchMovies());
      await untilCalled(() => mockGetFreeToWatchMovies());

      verify(() => mockGetFreeToWatchMovies()).called(1);
      expect(
        movieBloc.stream,
        emitsInOrder([
          MovieLoading(),
          MovieLoaded(
              popularMovies: const [], freeToWatchMovies: freeToWatchMovies),
          emitsDone
        ]),
      );
    });

    test('emits [MovieLoading, MovieError] when unsuccessful', () async {
      const errorMessage = 'Failed to load free to watch movies';
      when(() => mockGetFreeToWatchMovies()).thenThrow(Exception(errorMessage));

      movieBloc.add(FetchFreeToWatchMovies());
      await untilCalled(() => mockGetFreeToWatchMovies());

      verify(() => mockGetFreeToWatchMovies()).called(1);
      expect(
        movieBloc.stream,
        emitsInOrder(
            [MovieLoading(), MovieError(message: errorMessage), emitsDone]),
      );
    });
  });
}