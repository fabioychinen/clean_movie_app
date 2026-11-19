import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockSearchMovies searchMovies;

  setUp(() => searchMovies = MockSearchMovies());

  Future<void> pumpAndSearch(WidgetTester tester, String query) async {
    await tester.pumpWidget(
      RepositoryProvider<SearchMovies>.value(
        value: searchMovies,
        child: const MaterialApp(home: SearchPage()),
      ),
    );
    await tester.enterText(find.byType(TextField), query);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
  }

  testWidgets('mostra os resultados com o ano de lançamento', (tester) async {
    when(
      () => searchMovies('inception'),
    ).thenAnswer((_) async => moviePage([inception, sparseMovie]));

    await pumpAndSearch(tester, 'inception');

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('2010'), findsOneWidget);
    expect(find.text('Sem Dados'), findsOneWidget);
  });

  testWidgets('avisa quando não há resultados', (tester) async {
    when(
      () => searchMovies('xyz'),
    ).thenAnswer((_) async => moviePage(const [], totalPages: 1));

    await pumpAndSearch(tester, 'xyz');

    expect(find.text(CoreStrings.noSearchResults), findsOneWidget);
  });
}