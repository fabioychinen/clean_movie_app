import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovie extends Mock implements Movie {}

void main() {
  group('MovieDetailPage', () {
    late MockMovie movie;

    setUp(() {
      movie = MockMovie();
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.releaseDate).thenReturn('2023-06-15');
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.voteAverage).thenReturn(8.8);
      when(() => movie.overview)
          .thenReturn('A mind-bending thriller by Christopher Nolan.');
    });

    testWidgets('displays movie details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetailPage(movie: movie),
        ),
      );

      expect(find.text('Inception'), findsOneWidget);
      expect(find.text('Data de Lançamento: 15/06/2023'), findsOneWidget);
      expect(find.text('A mind-bending thriller by Christopher Nolan.'),
          findsOneWidget);
      expect(find.text('Nota: 8.8'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays "Data não disponível" when releaseDate is null',
        (WidgetTester tester) async {
      when(() => movie.releaseDate).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetailPage(movie: movie),
        ),
      );

      expect(
          find.text('Data de Lançamento: Data não disponível'), findsOneWidget);
    });

    testWidgets('displays "Título não disponível" when title is null',
        (WidgetTester tester) async {
      when(() => movie.title).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetailPage(movie: movie),
        ),
      );

      expect(find.text('Título não disponível'), findsOneWidget);
    });

    testWidgets('displays "Sinopse não disponível" when overview is null',
        (WidgetTester tester) async {
      when(() => movie.overview).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetailPage(movie: movie),
        ),
      );

      expect(find.text('Sinopse não disponível'), findsOneWidget);
    });

    testWidgets('displays "Nota: N/A" when voteAverage is null',
        (WidgetTester tester) async {
      when(() => movie.voteAverage).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: MovieDetailPage(movie: movie),
        ),
      );

      expect(find.text('Nota: N/A'), findsOneWidget);
    });
  });
}
