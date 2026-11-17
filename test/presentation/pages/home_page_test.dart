import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockMovieBloc bloc;

  setUp(() => bloc = MockMovieBloc());

  Future<void> pumpHome(WidgetTester tester, MovieState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpWidget(MaterialApp(
      home: BlocProvider<MovieBloc>.value(
        value: bloc,
        child: const HomePage(),
      ),
    ));
  }

  testWidgets('mostra o indicador durante o carregamento', (tester) async {
    await pumpHome(tester, const MovieLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('mostra as duas seções quando carregado', (tester) async {
    await pumpHome(
      tester,
      MovieLoaded(
        popularMovies: [inception, sparseMovie],
        freeToWatchMovies: [inception],
      ),
    );

    expect(find.text(CoreStrings.popularMoviesSection), findsOneWidget);
    expect(find.text(CoreStrings.freeToWatchSection), findsOneWidget);
    expect(find.byType(CardMovieWidget), findsNWidgets(3));
  });

  testWidgets('mostra a mensagem do estado de erro', (tester) async {
    await pumpHome(tester, const MovieError(message: 'Deu ruim'));

    expect(find.text('Deu ruim'), findsOneWidget);
  });

  testWidgets('tocar no card abre a página de detalhes', (tester) async {
    await pumpHome(
      tester,
      MovieLoaded(popularMovies: [inception], freeToWatchMovies: const []),
    );

    await tester.tap(find.byType(CardMovieWidget));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });
}
