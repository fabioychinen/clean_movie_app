import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, Movie movie) {
    return tester.pumpWidget(MaterialApp(home: MovieDetailPage(movie: movie)));
  }

  testWidgets('mostra os detalhes do filme', (tester) async {
    await pumpPage(tester, inception);

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('16/07/2010'), findsOneWidget);
    expect(find.text('A mind-bending thriller.'), findsOneWidget);
    expect(find.text('88%'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('mostra os textos de ausência para campos opcionais', (
    tester,
  ) async {
    await pumpPage(tester, sparseMovie);

    expect(find.text(CoreStrings.unavailableDate), findsOneWidget);
    expect(find.text(CoreStrings.noSynopsisAvailable), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.movie), findsOneWidget);
  });
}
