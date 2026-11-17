import 'dart:developer' as developer;

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMovieList _getMovieList;

  HomeBloc({required GetMovieList getMovieList})
    : _getMovieList = getMovieList,
      super(const HomeLoading()) {
    on<HomeRequested>(_onRequested);
  }

  Future<void> _onRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final lists = await Future.wait(
        MovieListType.values.map(_getMovieList.call),
      );
      emit(HomeLoaded(sections: Map.fromIterables(MovieListType.values, lists)));
    } on MovieFetchException catch (e, stackTrace) {
      developer.log(
        'Falha ao carregar a home',
        name: 'HomeBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(const HomeError(message: CoreStrings.fetchMoviesError));
    }
  }
}