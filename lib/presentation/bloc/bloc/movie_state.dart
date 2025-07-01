part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> popularMovies;
  final List<Movie> freeToWatchMovies;

  MovieLoaded({required this.popularMovies, required this.freeToWatchMovies});

  @override
  List<Object> get props => [popularMovies, freeToWatchMovies];
}

class MovieError extends MovieState {
  final String message;

  MovieError({required this.message});

  @override
  List<Object> get props => [message];
}