import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockSearchMovies searchMovies;

  setUp(() => searchMovies = MockSearchMovies());

  SearchBloc buildBloc() => SearchBloc(searchMovies: searchMovies);

  test('estado inicial é SearchIdle', () {
    expect(buildBloc().state, const SearchIdle());
  });

  blocTest<SearchBloc, SearchState>(
    'busca o termo sem espaços nas pontas',
    setUp: () {
      when(
        () => searchMovies('inception'),
      ).thenAnswer((_) async => [inception]);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const SearchSubmitted('  inception ')),
    expect: () => [
      const SearchLoading(),
      SearchLoaded(results: [inception]),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'termo em branco volta para SearchIdle sem chamar a API',
    build: buildBloc,
    seed: () => SearchLoaded(results: [inception]),
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
    expect: () => [
      const SearchLoading(),
      const SearchError(message: CoreStrings.searchError),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'uma busca nova descarta o resultado atrasado da anterior',
    setUp: () {
      final slowSearch = Completer<List<Movie>>();
      when(() => searchMovies('lenta')).thenAnswer((_) => slowSearch.future);
      when(() => searchMovies('rápida')).thenAnswer((_) async {
        slowSearch.complete([sparseMovie]);
        return [inception];
      });
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchSubmitted('lenta'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchSubmitted('rápida'));
    },
    expect: () => [
      const SearchLoading(),
      SearchLoaded(results: [inception]),
    ],
  );
}