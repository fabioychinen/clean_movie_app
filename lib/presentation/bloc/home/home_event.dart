part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeRequested extends HomeEvent {
  const HomeRequested();
}

final class HomeNextPageRequested extends HomeEvent {
  final MovieListType type;

  const HomeNextPageRequested(this.type);

  @override
  List<Object> get props => [type];
}