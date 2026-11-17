import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockGetPopularMovies getPopularMovies;
  late MockGetFreeToWatchMovies getFreeToWatchMovies;

  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    getFreeToWatchMovies = MockGetFreeToWatchMovies();
  });

  MovieBloc buildBloc() => MovieBloc(
        getPopularMovies: getPopularMovies,
        getFreeToWatchMovies: getFreeToWatchMovies,
      );

  test('estado inicial é MovieLoading', () {
    expect(buildBloc().state, const MovieLoading());
  });

  blocTest<MovieBloc, MovieState>(
    'FetchMovies emite [Loading, Loaded] com as duas listas',
    setUp: () {
      when(() => getPopularMovies()).thenAnswer((_) async => [inception]);
      when(() => getFreeToWatchMovies()).thenAnswer((_) async => [sparseMovie]);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchMovies()),
    expect: () => [
      const MovieLoading(),
      MovieLoaded(popularMovies: [inception], freeToWatchMovies: [sparseMovie]),
    ],
  );

  blocTest<MovieBloc, MovieState>(
    'FetchMovies emite [Loading, Error] quando a busca falha',
    setUp: () {
      when(() => getPopularMovies())
          .thenThrow(const MovieFetchException('HTTP 500'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchMovies()),
    expect: () => [
      const MovieLoading(),
      const MovieError(message: CoreStrings.fetchMoviesError),
    ],
  );

  blocTest<MovieBloc, MovieState>(
    'erro inesperado (bug) não vira estado de erro: explode pelo onError',
    setUp: () {
      when(() => getPopularMovies()).thenThrow(StateError('bug'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchMovies()),
    expect: () => [const MovieLoading()],
    errors: () => [isA<StateError>()],
  );
}
