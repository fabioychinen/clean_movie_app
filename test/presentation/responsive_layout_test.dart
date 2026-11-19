import 'dart:math';

import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/layout/movie_card_metrics.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:clean_movie_app/presentation/widgets/featured_movie_banner.dart';
import 'package:clean_movie_app/presentation/widgets/movie_backdrop.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fixtures.dart';
import '../helpers/mocks.dart';

class _Screen {
  final String name;
  final Size size;
  final double textScale;

  const _Screen(this.name, this.size, {this.textScale = 1});
}

const _screens = [
  _Screen('celular pequeno com fonte 200%', Size(320, 568), textScale: 2),
  _Screen('celular', Size(390, 844)),
  _Screen('celular na horizontal', Size(844, 390)),
  _Screen('tablet', Size(1024, 1366)),
];

void main() {
  late MockHomeBloc homeBloc;
  late MockGetMovieDetails getMovieDetails;
  late MockSearchMovies searchMovies;

  setUp(() {
    homeBloc = MockHomeBloc();
    getMovieDetails = MockGetMovieDetails();
    searchMovies = MockSearchMovies();
    when(() => homeBloc.state).thenReturn(
      HomeLoaded(
        sections: {
          for (final type in MovieListType.values)
            type:
                PaginatedMovies.firstPage(
                  moviePage([inception, sparseMovie, inception]),
                ).loadingMore(),
        },
      ),
    );
    when(
      () => getMovieDetails(inception.id),
    ).thenAnswer((_) async => inceptionDetails);
    when(
      () => searchMovies(any()),
    ).thenAnswer((_) async => moviePage([inception, sparseMovie]));
  });

  Future<void> pumpOn(WidgetTester tester, _Screen screen, Widget page) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = screen.size;
    tester.platformDispatcher.textScaleFactorTestValue = screen.textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GetMovieDetails>.value(value: getMovieDetails),
          RepositoryProvider<SearchMovies>.value(value: searchMovies),
        ],
        child: BlocProvider<HomeBloc>.value(
          value: homeBloc,
          child: MaterialApp(home: page),
        ),
      ),
    );
    await tester.pump();
  }

  for (final screen in _screens) {
    group(screen.name, () {
      testWidgets('home sem estouro de layout', (tester) async {
        await pumpOn(tester, screen, const HomePage());

        expect(tester.takeException(), isNull);
        expect(find.byType(CardMovieWidget), findsWidgets);
      });

      testWidgets('detalhe sem estouro de layout', (tester) async {
        await pumpOn(tester, screen, MovieDetailPage(movie: inception));
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('busca sem estouro de layout', (tester) async {
        await pumpOn(tester, screen, const SearchPage());
        await tester.enterText(find.byType(TextField), 'inception');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text('Inception'), findsOneWidget);
      });
    });
  }

  for (final screen in _screens) {
    testWidgets('${screen.name}: fundo do detalhe ocupa no máximo 40% '
        'da altura, com o pôster ao lado do título', (tester) async {
      await pumpOn(tester, screen, MovieDetailPage(movie: inception));

      final backdrop = tester.getRect(find.byType(MovieBackdrop));
      expect(
        backdrop.height,
        lessThanOrEqualTo(max(screen.size.height * 0.4, kToolbarHeight + 48)),
      );
      final poster = tester.getRect(find.byType(MoviePoster).first);
      final title = tester.getRect(find.text('Inception').last);
      expect(title.left, greaterThan(poster.right));
    });
  }

  testWidgets('destaque da home cabe na tela na horizontal', (tester) async {
    await pumpOn(tester, _screens[2], const HomePage());

    final banner = tester.getRect(find.byType(FeaturedMovieBanner));
    expect(banner.height, lessThanOrEqualTo(_screens[2].size.height * 0.6));
  });

  testWidgets('cards crescem no tablet', (tester) async {
    late MovieCardMetrics phone;
    late MovieCardMetrics tablet;

    await pumpOn(
      tester,
      _screens[1],
      Builder(
        builder: (context) {
          phone = MovieCardMetrics.of(context);
          return const SizedBox.shrink();
        },
      ),
    );
    await pumpOn(
      tester,
      _screens[3],
      Builder(
        builder: (context) {
          tablet = MovieCardMetrics.of(context);
          return const SizedBox.shrink();
        },
      ),
    );

    expect(tablet.posterWidth, greaterThan(phone.posterWidth));
  });
}