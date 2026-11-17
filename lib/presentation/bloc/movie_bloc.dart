import 'dart:developer' as developer;

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;
  final GetFreeToWatchMovies _getFreeToWatchMovies;

  MovieBloc({
    required GetPopularMovies getPopularMovies,
    required GetFreeToWatchMovies getFreeToWatchMovies,
  }) : _getPopularMovies = getPopularMovies,
       _getFreeToWatchMovies = getFreeToWatchMovies,
       super(const MovieLoading()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    try {
      final popularMovies = await _getPopularMovies();
      final freeToWatchMovies = await _getFreeToWatchMovies();
      emit(
        MovieLoaded(
          popularMovies: popularMovies,
          freeToWatchMovies: freeToWatchMovies,
        ),
      );
    } on MovieFetchException catch (e, stackTrace) {
      developer.log(
        'Falha ao buscar filmes',
        name: 'MovieBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(const MovieError(message: CoreStrings.fetchMoviesError));
    }
  }
}
