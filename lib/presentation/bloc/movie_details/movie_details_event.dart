part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

final class MovieDetailsRequested extends MovieDetailsEvent {
  final MovieId id;

  const MovieDetailsRequested(this.id);

  @override
  List<Object> get props => [id.value];
}