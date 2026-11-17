import 'dart:developer' as developer;

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails _getMovieDetails;

  MovieDetailsBloc({required GetMovieDetails getMovieDetails})
    : _getMovieDetails = getMovieDetails,
      super(const MovieDetailsLoading()) {
    on<MovieDetailsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    MovieDetailsRequested event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(const MovieDetailsLoading());
    try {
      emit(MovieDetailsLoaded(details: await _getMovieDetails(event.id)));
    } on MovieFetchException catch (e, stackTrace) {
      developer.log(
        'Falha ao carregar detalhes do filme ${event.id.value}',
        name: 'MovieDetailsBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(const MovieDetailsError(message: CoreStrings.fetchDetailsError));
    }
  }
}