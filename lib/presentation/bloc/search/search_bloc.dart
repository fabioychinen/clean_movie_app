import 'dart:developer' as developer;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
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
      emit(SearchLoaded(results: await _searchMovies(query)));
    } on MovieFetchException catch (e, stackTrace) {
      developer.log(
        'Falha na busca por "$query"',
        name: 'SearchBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(const SearchError(message: CoreStrings.searchError));
    }
  }
}