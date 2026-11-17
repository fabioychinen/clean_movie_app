import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  Future<void> pumpCard(
    WidgetTester tester,
    Movie movie, {
    VoidCallback? onTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardMovieWidget(movie: movie, onTap: onTap ?? () {}),
        ),
      ),
    );
  }

  testWidgets('mostra título, pôster e nota', (tester) async {
    await pumpCard(tester, inception);

    expect(find.text('Inception'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('88%'), findsOneWidget);
  });

  testWidgets('mostra placeholder quando não há pôster', (tester) async {
    await pumpCard(tester, sparseMovie);

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.movie), findsOneWidget);
  });

  testWidgets('chama onTap ao ser tocado', (tester) async {
    var taps = 0;
    await pumpCard(tester, inception, onTap: () => taps++);

    await tester.tap(find.byType(CardMovieWidget));

    expect(taps, 1);
  });

  group('RatingBadge escolhe a cor pela nota', () {
    Future<Color?> colorFor(WidgetTester tester, double vote) async {
      await tester.pumpWidget(
        MaterialApp(home: RatingBadge(voteAverage: vote)),
      );
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      return (indicator.valueColor! as AlwaysStoppedAnimation<Color>).value;
    }

    testWidgets('>= 7 é verde', (tester) async {
      expect(await colorFor(tester, 7.0), Colors.green);
    });

    testWidgets('>= 4 e < 7 é amarelo', (tester) async {
      expect(await colorFor(tester, 4.0), Colors.yellow);
    });

    testWidgets('< 4 é vermelho', (tester) async {
      expect(await colorFor(tester, 3.9), Colors.red);
    });
  });
}