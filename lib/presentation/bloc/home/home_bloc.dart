import 'dart:developer' as developer;

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
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
    on<HomeNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final pages = await Future.wait(
        MovieListType.values.map((type) => _getMovieList(type)),
      );
      emit(
        HomeLoaded(
          sections: Map.fromIterables(
            MovieListType.values,
            pages.map(PaginatedMovies.firstPage),
          ),
        ),
      );
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

  Future<void> _onNextPageRequested(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    final section = _sectionOf(event.type);
    if (section == null || !section.canLoadMore) return;

    _updateSection(emit, event.type, (section) => section.loadingMore());
    try {
      final next = await _getMovieList(event.type, page: section.nextPage);
      _updateSection(emit, event.type, (section) => section.append(next));
    } on MovieFetchException catch (e, stackTrace) {
      developer.log(
        'Falha ao carregar a página ${section.nextPage} de ${event.type.name}',
        name: 'HomeBloc',
        error: e,
        stackTrace: stackTrace,
      );
      _updateSection(emit, event.type, (section) => section.failedToLoadMore());
    }
  }

  PaginatedMovies? _sectionOf(MovieListType type) {
    return switch (state) {
      HomeLoaded(:final sections) => sections[type],
      _ => null,
    };
  }

  void _updateSection(
    Emitter<HomeState> emit,
    MovieListType type,
    PaginatedMovies Function(PaginatedMovies section) update,
  ) {
    if (state case HomeLoaded(:final sections)) {
      if (sections[type] case final section?) {
        emit(HomeLoaded(sections: {...sections, type: update(section)}));
      }
    }
  }
}