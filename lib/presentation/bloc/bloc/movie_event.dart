part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends MovieEvent {}

class FetchFreeToWatchMovies extends MovieEvent {}