import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/search/search_bloc.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockSearchMovies searchMovies;

  setUp(() => searchMovies = MockSearchMovies());

  SearchBloc buildBloc() => SearchBloc(searchMovies: searchMovies);

  final firstPage = moviePage([inception]);
  final firstResults = PaginatedMovies.firstPage(firstPage);

  test('estado inicial é SearchIdle', () {
    expect(buildBloc().state, const SearchIdle());
  });

  blocTest<SearchBloc, SearchState>(
    'busca o termo sem espaços nas pontas',
    setUp: () {
      when(() => searchMovies('inception')).thenAnswer((_) async => firstPage);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const SearchSubmitted('  inception ')),
    expect:
        () => [
          const SearchLoading(),
          SearchLoaded(query: 'inception', results: firstResults),
        ],
  );

  blocTest<SearchBloc, SearchState>(
    'termo em branco volta para SearchIdle sem chamar a API',
    build: buildBloc,
    seed: () => SearchLoaded(query: 'x', results: firstResults),
    act: (bloc) => bloc.add(const SearchSubmitted('   ')),
    expect: () => [const SearchIdle()],
    verify: (_) => verifyNever(() => searchMovies(any())),
  );

  blocTest<SearchBloc, SearchState>(
    'emite erro quando a busca falha',
    setUp: () {
      when(
        () => searchMovies(any()),
      ).thenThrow(const MovieFetchException('HTTP 500'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const SearchSubmitted('matrix')),
    expect:
        () => [
          const SearchLoading(),
          const SearchError(message: CoreStrings.searchError),
        ],
  );

  blocTest<SearchBloc, SearchState>(
    'uma busca nova descarta o resultado atrasado da anterior',
    setUp: () {
      final slowSearch = Completer<MoviePage>();
      when(() => searchMovies('lenta')).thenAnswer((_) => slowSearch.future);
      when(() => searchMovies('rápida')).thenAnswer((_) async {
        slowSearch.complete(moviePage([sparseMovie]));
        return firstPage;
      });
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchSubmitted('lenta'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchSubmitted('rápida'));
    },
    expect:
        () => [
          const SearchLoading(),
          SearchLoaded(query: 'rápida', results: firstResults),
        ],
  );

  group('SearchNextPageRequested', () {
    final secondPage = moviePage([sparseMovie], page: 2);

    blocTest<SearchBloc, SearchState>(
      'anexa a próxima página da mesma busca',
      setUp: () {
        when(
          () => searchMovies('matrix', page: 2),
        ).thenAnswer((_) async => secondPage);
      },
      build: buildBloc,
      seed: () => SearchLoaded(query: 'matrix', results: firstResults),
      act: (bloc) => bloc.add(const SearchNextPageRequested()),
      expect:
          () => [
            SearchLoaded(query: 'matrix', results: firstResults.loadingMore()),
            SearchLoaded(
              query: 'matrix',
              results: firstResults.append(secondPage),
            ),
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'falha permite tentar de novo sem perder os resultados',
      setUp: () {
        when(
          () => searchMovies('matrix', page: 2),
        ).thenThrow(const MovieFetchException('HTTP 500'));
      },
      build: buildBloc,
      seed: () => SearchLoaded(query: 'matrix', results: firstResults),
      act: (bloc) => bloc.add(const SearchNextPageRequested()),
      expect:
          () => [
            SearchLoaded(query: 'matrix', results: firstResults.loadingMore()),
            SearchLoaded(
              query: 'matrix',
              results: firstResults.failedToLoadMore(),
            ),
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'página atrasada de uma busca antiga não entra na busca nova',
      setUp: () {
        final slowPage = Completer<MoviePage>();
        when(
          () => searchMovies('matrix', page: 2),
        ).thenAnswer((_) => slowPage.future);
        when(() => searchMovies('alien')).thenAnswer((_) async {
          slowPage.complete(secondPage);
          return firstPage;
        });
      },
      build: buildBloc,
      seed: () => SearchLoaded(query: 'matrix', results: firstResults),
      act: (bloc) async {
        bloc.add(const SearchNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchSubmitted('alien'));
      },
      expect:
          () => [
            SearchLoaded(query: 'matrix', results: firstResults.loadingMore()),
            const SearchLoading(),
            SearchLoaded(query: 'alien', results: firstResults),
          ],
    );
  });
}