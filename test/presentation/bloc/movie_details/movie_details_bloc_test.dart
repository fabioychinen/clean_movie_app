import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetMovieDetails getMovieDetails;

  setUp(() => getMovieDetails = MockGetMovieDetails());

  MovieDetailsBloc buildBloc() =>
      MovieDetailsBloc(getMovieDetails: getMovieDetails);

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'MovieDetailsRequested emite os detalhes do filme',
    setUp: () {
      when(
        () => getMovieDetails(const MovieId(27205)),
      ).thenAnswer((_) async => inceptionDetails);
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieDetailsRequested(MovieId(27205))),
    expect: () => [
      const MovieDetailsLoading(),
      MovieDetailsLoaded(details: inceptionDetails),
    ],
  );

  blocTest<MovieDetailsBloc, MovieDetailsState>(
    'MovieDetailsRequested emite erro quando a busca falha',
    setUp: () {
      when(
        () => getMovieDetails(const MovieId(27205)),
      ).thenThrow(const MovieFetchException('HTTP 404'));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const MovieDetailsRequested(MovieId(27205))),
    expect: () => [
      const MovieDetailsLoading(),
      const MovieDetailsError(message: CoreStrings.fetchDetailsError),
    ],
  );
}