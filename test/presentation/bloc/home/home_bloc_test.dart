import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetMovieList getMovieList;

  setUpAll(() => registerFallbackValue(MovieListType.popular));

  setUp(() => getMovieList = MockGetMovieList());

  HomeBloc buildBloc() => HomeBloc(getMovieList: getMovieList);

  test('estado inicial é HomeLoading', () {
    expect(buildBloc().state, const HomeLoading());
  });

  blocTest<HomeBloc, HomeState>(
    'HomeRequested carrega uma seção por tipo de lista',
    setUp: () {
      when(() => getMovieList(any())).thenAnswer((_) async => [sparseMovie]);
      when(
        () => getMovieList(MovieListType.trending),
      ).thenAnswer((_) async => [inception]);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect: () => [
      const HomeLoading(),
      HomeLoaded(
        sections: {
          for (final type in MovieListType.values)
            type: type == MovieListType.trending ? [inception] : [sparseMovie],
        },
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'HomeRequested emite HomeError quando alguma lista falha',
    setUp: () {
      when(() => getMovieList(any())).thenAnswer((_) async => [inception]);
      when(
        () => getMovieList(MovieListType.upcoming),
      ).thenThrow(const MovieFetchException('HTTP 500'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect: () => [
      const HomeLoading(),
      const HomeError(message: CoreStrings.fetchMoviesError),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'erro inesperado (bug) não vira estado de erro: explode pelo onError',
    setUp: () {
      when(() => getMovieList(any())).thenThrow(StateError('bug'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect: () => [const HomeLoading()],
    errors: () => [isA<StateError>()],
  );
}