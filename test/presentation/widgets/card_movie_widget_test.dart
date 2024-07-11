import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';

class MockMovie extends Mock implements Movie {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockMovie());
  });

  group('CardMovieWidget', () {
    testWidgets('displays the movie title', (WidgetTester tester) async {
      final movie = MockMovie();
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.voteAverage).thenReturn(8.8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardMovieWidget(movie: movie),
          ),
        ),
      );

      expect(find.text('Inception'), findsOneWidget);
    });

    testWidgets('displays the movie poster', (WidgetTester tester) async {
      final movie = MockMovie();
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.voteAverage).thenReturn(8.8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardMovieWidget(movie: movie),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays the correct vote percentage',
        (WidgetTester tester) async {
      final movie = MockMovie();
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.voteAverage).thenReturn(8.8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardMovieWidget(movie: movie),
          ),
        ),
      );

      expect(find.text('88%'), findsOneWidget);
    });

    testWidgets('displays the correct vote color based on vote average',
        (WidgetTester tester) async {
      final movie = MockMovie();
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.voteAverage).thenReturn(8.8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardMovieWidget(movie: movie),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator));
      expect(progressIndicator.valueColor,
          const AlwaysStoppedAnimation<Color>(Colors.green));
    });

    testWidgets('navigates to details page on tap',
        (WidgetTester tester) async {
      final movie = MockMovie();
      when(() => movie.title).thenReturn('Inception');
      when(() => movie.posterPath).thenReturn('/poster_path.jpg');
      when(() => movie.voteAverage).thenReturn(8.8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardMovieWidget(movie: movie),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
    });
  });
}
