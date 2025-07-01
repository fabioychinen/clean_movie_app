import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:clean_movie_app/presentation/bloc/bloc/movie_bloc.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieApp extends StatelessWidget {
  final GetPopularMovies getPopularMovies;
  final GetFreeToWatchMovies getFreeToWatchMovies;

  const MovieApp({
    super.key,
    required this.getPopularMovies,
    required this.getFreeToWatchMovies,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieBloc>(
      create: (context) => MovieBloc(
        getPopularMovies: getPopularMovies,
        getFreeToWatchMovies: getFreeToWatchMovies,
      )..add(FetchPopularMovies()),
      child: _buildMaterialApp(),
    );
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: _buildThemeData(),
      home: const HomePage(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}