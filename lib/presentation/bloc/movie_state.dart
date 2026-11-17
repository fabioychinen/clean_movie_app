part of 'movie_bloc.dart';

sealed class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

final class MovieLoading extends MovieState {
  const MovieLoading();
}

final class MovieLoaded extends MovieState {
  final List<Movie> popularMovies;
  final List<Movie> freeToWatchMovies;

  const MovieLoaded({
    required this.popularMovies,
    required this.freeToWatchMovies,
  });

  @override
  List<Object> get props => [popularMovies, freeToWatchMovies];
}

final class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  @override
  List<Object> get props => [message];
}
