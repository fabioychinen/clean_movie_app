import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/bloc/bloc/movie_bloc.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieBloc extends Mock implements MovieBloc {}

void main() {
  late MockMovieBloc movieBloc;

  setUp(() {
    movieBloc = MockMovieBloc();
  });

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: BlocProvider.value(
        value: movieBloc,
        child: child,
      ),
    );
  }

  testWidgets('HomePage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(MovieLoading());

    await tester.pumpWidget(makeTestableWidget(child: const HomePage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomePage displays movie lists when loaded',
      (WidgetTester tester) async {
    final movies = [
      Movie(
        posterPath: '/poster_path_1.jpg',
        releaseDate: '2023-06-15',
        title: 'Movie 1',
        voteAverage: 8.0,
        overview: 'Overview of Movie 1',
      ),
      Movie(
        posterPath: '/poster_path_2.jpg',
        releaseDate: '2023-07-20',
        title: 'Movie 2',
        voteAverage: 7.5,
        overview: 'Overview of Movie 2',
      ),
    ];

    when(() => movieBloc.state).thenReturn(MovieLoaded(
      popularMovies: movies,
      freeToWatchMovies: movies,
    ));

    await tester.pumpWidget(makeTestableWidget(child: const HomePage()));

    expect(find.text('Os Mais Populares'), findsOneWidget);
    expect(find.text('Grátis Para Assistir'), findsOneWidget);
    expect(find.byType(CardMovieWidget), findsNWidgets(movies.length * 2));
  });

  testWidgets('HomePage displays error message on error state',
      (WidgetTester tester) async {
    when(() => movieBloc.state)
        .thenReturn(MovieError(message: 'Failed to load movies'));

    await tester.pumpWidget(makeTestableWidget(child: const HomePage()));

    expect(find.text('Failed to load movies'), findsOneWidget);
  });

  testWidgets('Tapping movie navigates to MovieDetailPage',
      (WidgetTester tester) async {
    final movie = Movie(
      posterPath: '/poster_path_1.jpg',
      releaseDate: '2023-06-15',
      title: 'Movie 1',
      voteAverage: 8.0,
      overview: 'Overview of Movie 1',
    );

    when(() => movieBloc.state).thenReturn(MovieLoaded(
      popularMovies: [movie],
      freeToWatchMovies: [movie],
    ));

    await tester.pumpWidget(makeTestableWidget(child: const HomePage()));

    await tester.tap(find.byType(CardMovieWidget).first);

    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });
}