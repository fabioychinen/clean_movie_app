import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetMovieList getMovieList;

  setUpAll(() => registerFallbackValue(MovieListType.popular));

  setUp(() => getMovieList = MockGetMovieList());

  HomeBloc buildBloc() => HomeBloc(getMovieList: getMovieList);

  final firstPage = moviePage([inception]);
  final loadedHome = HomeLoaded(
    sections: {
      for (final type in MovieListType.values)
        type: PaginatedMovies.firstPage(firstPage),
    },
  );

  HomeLoaded withSection(MovieListType type, PaginatedMovies section) {
    return HomeLoaded(sections: {...loadedHome.sections, type: section});
  }

  void listReturns(MoviePage page, {MovieListType? type, int? pageNumber}) {
    when(
      () => getMovieList(type ?? any(), page: pageNumber ?? any(named: 'page')),
    ).thenAnswer((_) async => page);
  }

  test('estado inicial é HomeLoading', () {
    expect(buildBloc().state, const HomeLoading());
  });

  blocTest<HomeBloc, HomeState>(
    'HomeRequested carrega a primeira página de cada lista',
    setUp: () => listReturns(firstPage),
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect: () => [const HomeLoading(), loadedHome],
  );

  blocTest<HomeBloc, HomeState>(
    'HomeRequested emite HomeError quando alguma lista falha',
    setUp: () {
      listReturns(firstPage);
      when(
        () => getMovieList(MovieListType.upcoming, page: any(named: 'page')),
      ).thenThrow(const MovieFetchException('HTTP 500'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect:
        () => [
          const HomeLoading(),
          const HomeError(message: CoreStrings.fetchMoviesError),
        ],
  );

  blocTest<HomeBloc, HomeState>(
    'erro inesperado (bug) não vira estado de erro: explode pelo onError',
    setUp: () {
      when(
        () => getMovieList(any(), page: any(named: 'page')),
      ).thenThrow(StateError('bug'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeRequested()),
    expect: () => [const HomeLoading()],
    errors: () => [isA<StateError>()],
  );

  group('HomeNextPageRequested', () {
    final secondPage = moviePage([sparseMovie], page: 2);
    final section = PaginatedMovies.firstPage(firstPage);

    blocTest<HomeBloc, HomeState>(
      'anexa a próxima página só na seção pedida',
      setUp:
          () => listReturns(
            secondPage,
            type: MovieListType.popular,
            pageNumber: 2,
          ),
      build: buildBloc,
      seed: () => loadedHome,
      act:
          (bloc) =>
              bloc.add(const HomeNextPageRequested(MovieListType.popular)),
      expect:
          () => [
            withSection(MovieListType.popular, section.loadingMore()),
            withSection(MovieListType.popular, section.append(secondPage)),
          ],
    );

    blocTest<HomeBloc, HomeState>(
      'falha marca a seção para tentar de novo sem perder os filmes',
      setUp: () {
        when(
          () => getMovieList(MovieListType.popular, page: 2),
        ).thenThrow(const MovieFetchException('HTTP 500'));
      },
      build: buildBloc,
      seed: () => loadedHome,
      act:
          (bloc) =>
              bloc.add(const HomeNextPageRequested(MovieListType.popular)),
      expect:
          () => [
            withSection(MovieListType.popular, section.loadingMore()),
            withSection(MovieListType.popular, section.failedToLoadMore()),
          ],
    );

    blocTest<HomeBloc, HomeState>(
      'pedidos repetidos durante a carga geram uma única requisição',
      setUp: () {
        final pending = Completer<MoviePage>();
        when(
          () => getMovieList(MovieListType.popular, page: 2),
        ).thenAnswer((_) => pending.future);
      },
      build: buildBloc,
      seed: () => loadedHome,
      act: (bloc) {
        bloc
          ..add(const HomeNextPageRequested(MovieListType.popular))
          ..add(const HomeNextPageRequested(MovieListType.popular));
      },
      expect: () => [withSection(MovieListType.popular, section.loadingMore())],
      verify:
          (_) => verify(
            () => getMovieList(MovieListType.popular, page: 2),
          ).called(1),
    );

    blocTest<HomeBloc, HomeState>(
      'não pede mais nada na última página',
      build: buildBloc,
      seed:
          () => withSection(
            MovieListType.popular,
            PaginatedMovies.firstPage(moviePage([inception], totalPages: 1)),
          ),
      act:
          (bloc) =>
              bloc.add(const HomeNextPageRequested(MovieListType.popular)),
      expect: () => <HomeState>[],
      verify:
          (_) =>
              verifyNever(() => getMovieList(any(), page: any(named: 'page'))),
    );
  });
}