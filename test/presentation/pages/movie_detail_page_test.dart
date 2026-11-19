import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockGetMovieDetails getMovieDetails;

  setUp(() => getMovieDetails = MockGetMovieDetails());

  Future<void> pumpPage(WidgetTester tester, Movie movie) async {
    await tester.pumpWidget(
      RepositoryProvider<GetMovieDetails>.value(
        value: getMovieDetails,
        child: MaterialApp(home: MovieDetailPage(movie: movie)),
      ),
    );
    await tester.pump();
  }

  void detailsReturn(MovieDetails details) {
    when(
      () => getMovieDetails(details.movie.id),
    ).thenAnswer((_) async => details);
  }

  testWidgets('mostra os dados básicos do filme', (tester) async {
    detailsReturn(inceptionDetails);

    await pumpPage(tester, inception);

    expect(find.text('Inception'), findsWidgets);
    expect(find.text('16/07/2010'), findsOneWidget);
    expect(find.text('A mind-bending thriller.'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
  });

  testWidgets('mostra gêneros, duração, elenco, trailer e onde assistir', (
    tester,
  ) async {
    detailsReturn(inceptionDetails);

    await pumpPage(tester, inception);

    expect(find.text('Sua mente é a cena do crime.'), findsOneWidget);
    expect(find.text('2h 28min'), findsOneWidget);
    expect(find.text('Ação'), findsOneWidget);
    expect(find.text(CoreStrings.watchTrailer), findsOneWidget);
    expect(find.text(CoreStrings.streaming), findsOneWidget);
    expect(find.byTooltip('Max'), findsOneWidget);
    expect(find.text(CoreStrings.rent), findsOneWidget);
    expect(find.text(CoreStrings.buy), findsNothing);
    expect(find.text('Leonardo DiCaprio'), findsOneWidget);
    expect(find.text(CoreStrings.recommendations), findsOneWidget);
  });

  testWidgets('avisa quando não há onde assistir no Brasil', (tester) async {
    detailsReturn(
      MovieDetails(
        movie: sparseMovie,
        genres: const [],
        cast: const [],
        recommendations: const [],
      ),
    );

    await pumpPage(tester, sparseMovie);

    expect(find.text(CoreStrings.notAvailableToWatch), findsOneWidget);
    expect(find.text(CoreStrings.watchTrailer), findsNothing);
    expect(find.text(CoreStrings.cast), findsNothing);
    expect(find.text(CoreStrings.unavailableDate), findsOneWidget);
    expect(find.text(CoreStrings.noSynopsisAvailable), findsOneWidget);
  });

  testWidgets('falha nos detalhes mantém os dados básicos na tela', (
    tester,
  ) async {
    when(
      () => getMovieDetails(inception.id),
    ).thenThrow(const MovieFetchException('HTTP 500'));

    await pumpPage(tester, inception);

    expect(find.text(CoreStrings.fetchDetailsError), findsOneWidget);
    expect(find.text('A mind-bending thriller.'), findsOneWidget);
  });
}