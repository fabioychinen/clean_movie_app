import 'dart:developer' as developer;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc({required SearchMovies searchMovies})
    : _searchMovies = searchMovies,
      super(const SearchIdle()) {
    on<SearchSubmitted>(_onSubmitted, transformer: restartable());
    on<SearchNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  Future<void> _onSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchIdle());
      return;
    }

    emit(const SearchLoading());
    try {
      final firstPage = await _searchMovies(query);
      emit(
        SearchLoaded(
          query: query,
          results: PaginatedMovies.firstPage(firstPage),
        ),
      );
    } on MovieFetchException catch (e, stackTrace) {
      _log('Falha na busca por "$query"', e, stackTrace);
      emit(const SearchError(message: CoreStrings.searchError));
    }
  }

  Future<void> _onNextPageRequested(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    if (current is! SearchLoaded || !current.results.canLoadMore) return;

    final query = current.query;
    final nextPage = current.results.nextPage;
    _updateResults(emit, query, (results) => results.loadingMore());
    try {
      final next = await _searchMovies(query, page: nextPage);
      _updateResults(emit, query, (results) => results.append(next));
    } on MovieFetchException catch (e, stackTrace) {
      _log('Falha na página $nextPage da busca por "$query"', e, stackTrace);
      _updateResults(emit, query, (results) => results.failedToLoadMore());
    }
  }

  void _updateResults(
    Emitter<SearchState> emit,
    String query,
    PaginatedMovies Function(PaginatedMovies results) update,
  ) {
    if (state case SearchLoaded(
      query: final current,
      :final results,
    ) when current == query) {
      emit(SearchLoaded(query: query, results: update(results)));
    }
  }

  void _log(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'SearchBloc',
      error: error,
      stackTrace: stackTrace,
    );
  }
}