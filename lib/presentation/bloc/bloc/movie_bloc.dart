import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies getPopularMovies;
  final GetFreeToWatchMovies getFreeToWatchMovies;

  MovieBloc({
    required this.getPopularMovies,
    required this.getFreeToWatchMovies,
  }) : super(MovieLoading()) {
    on<FetchPopularMovies>(_onFetchMovies);
    on<FetchFreeToWatchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(MovieEvent event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final popularMovies = await getPopularMovies();
      final freeToWatchMovies = await getFreeToWatchMovies();
      emit(MovieLoaded(
        popularMovies: popularMovies,
        freeToWatchMovies: freeToWatchMovies,
      ));
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }
}