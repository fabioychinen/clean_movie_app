import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:clean_movie_app/presentation/pages/about_page.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:clean_movie_app/presentation/widgets/featured_movie_banner.dart';
import 'package:clean_movie_app/presentation/widgets/home_skeleton.dart';
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

  PaginatedMovies section(List<Movie> movies) =>
      PaginatedMovies.firstPage(moviePage(movies));

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

  const emptyHome = HomeLoaded(sections: {});

  testWidgets('mostra o skeleton durante o carregamento', (tester) async {
    await pumpHome(tester, const HomeLoading());

    expect(find.byType(HomeSkeleton), findsOneWidget);
  });

  testWidgets('destaca o primeiro filme em alta com imagem de fundo', (
    tester,
  ) async {
    await pumpHome(
      tester,
      HomeLoaded(
        sections: {
          MovieListType.trending: section([sparseMovie, inception]),
        },
      ),
    );

    final banner = tester.widget<FeaturedMovieBanner>(
      find.byType(FeaturedMovieBanner),
    );
    expect(banner.movie, inception);

    await tester.tap(find.text(CoreStrings.seeDetails));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  testWidgets('erro na home oferece tentar novamente', (tester) async {
    await pumpHome(tester, const HomeError(message: 'Deu ruim'));

    await tester.tap(find.text(CoreStrings.retry));

    verify(() => bloc.add(const HomeRequested())).called(1);
  });

  testWidgets('mostra uma seção por lista e omite as vazias', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpHome(
      tester,
      HomeLoaded(
        sections: {
          MovieListType.trending: section([inception, sparseMovie]),
          MovieListType.nowPlaying: section([inception]),
          MovieListType.freeToWatch: section(const []),
        },
      ),
    );

    expect(find.text(CoreStrings.trendingSection), findsOneWidget);
    expect(find.text(CoreStrings.nowPlayingSection), findsOneWidget);
    expect(find.text(CoreStrings.freeToWatchSection), findsNothing);
    expect(find.byType(CardMovieWidget), findsNWidgets(3));
  });

  testWidgets('falha ao carregar mais oferece tentar de novo', (tester) async {
    await pumpHome(
      tester,
      HomeLoaded(
        sections: {
          MovieListType.popular: section([inception]).failedToLoadMore(),
        },
      ),
    );

    await tester.tap(find.byTooltip(CoreStrings.retryLoadMore));

    verify(
      () => bloc.add(const HomeNextPageRequested(MovieListType.popular)),
    ).called(1);
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
          MovieListType.popular: section([inception]),
        },
      ),
    );

    await tester.tap(find.byType(CardMovieWidget));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  testWidgets('o botão de busca abre a página de busca', (tester) async {
    await pumpHome(tester, emptyHome);

    await tester.tap(find.byTooltip(CoreStrings.search));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('o botão Sobre abre a página Sobre', (tester) async {
    await pumpHome(tester, emptyHome);

    await tester.tap(find.byTooltip(CoreStrings.about));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);
  });
}