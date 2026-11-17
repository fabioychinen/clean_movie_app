part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

/// Carrega as duas vitrines da home (populares e grátis).
final class FetchMovies extends MovieEvent {
  const FetchMovies();
}
