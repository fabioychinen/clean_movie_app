import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHomeBloc bloc;
  late MockGetMovieDetails getMovieDetails;

  setUp(() {
    bloc = MockHomeBloc();
    getMovieDetails = MockGetMovieDetails();
    when(
      () => getMovieDetails(inception.id),
    ).thenAnswer((_) async => inceptionDetails);
  });

  Future<void> pumpHome(WidgetTester tester, HomeState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GetMovieDetails>.value(value: getMovieDetails),
          RepositoryProvider<SearchMovies>.value(value: MockSearchMovies()),
        ],
        child: MaterialApp(
          home: BlocProvider<HomeBloc>.value(
            value: bloc,
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra o indicador durante o carregamento', (tester) async {
    await pumpHome(tester, const HomeLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('mostra uma seção por lista e omite as vazias', (tester) async {
    await pumpHome(
      tester,
      HomeLoaded(
        sections: {
          MovieListType.trending: [inception, sparseMovie],
          MovieListType.popular: [inception],
          MovieListType.freeToWatch: const [],
        },
      ),
    );

    expect(find.text(CoreStrings.trendingSection), findsOneWidget);
    expect(find.text(CoreStrings.popularMoviesSection), findsOneWidget);
    expect(find.text(CoreStrings.freeToWatchSection), findsNothing);
    expect(find.byType(CardMovieWidget), findsNWidgets(3));
  });

  testWidgets('mostra a mensagem do estado de erro', (tester) async {
    await pumpHome(tester, const HomeError(message: 'Deu ruim'));

    expect(find.text('Deu ruim'), findsOneWidget);
  });

  testWidgets('tocar no card abre a página de detalhes', (tester) async {
    await pumpHome(
      tester,
      HomeLoaded(
        sections: {
          MovieListType.popular: [inception],
        },
      ),
    );

    await tester.tap(find.byType(CardMovieWidget));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  testWidgets('o botão de busca abre a página de busca', (tester) async {
    await pumpHome(tester, const HomeLoading());

    await tester.tap(find.byTooltip(CoreStrings.search));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });
}