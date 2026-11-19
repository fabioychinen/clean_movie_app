import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:clean_movie_app/presentation/theme/app_colors.dart';
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
    expect(find.text('8.8'), findsOneWidget);
  });

  testWidgets('mostra placeholder quando não há pôster', (tester) async {
    await pumpCard(tester, sparseMovie);

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
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
      return tester.widget<Icon>(find.byIcon(Icons.star_rounded)).color;
    }

    testWidgets('>= 7 é verde', (tester) async {
      expect(await colorFor(tester, 7.0), AppColors.ratingHigh);
    });

    testWidgets('>= 4 e < 7 é amarelo', (tester) async {
      expect(await colorFor(tester, 4.0), AppColors.ratingMid);
    });

    testWidgets('< 4 é vermelho', (tester) async {
      expect(await colorFor(tester, 3.9), AppColors.ratingLow);
    });

    testWidgets('sem votos mostra traço e cor neutra', (tester) async {
      expect(await colorFor(tester, 0), AppColors.textMuted);
      expect(find.text('–'), findsOneWidget);
    });
  });
}