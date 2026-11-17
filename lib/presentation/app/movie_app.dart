import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieApp extends StatelessWidget {
  final GetMovieList getMovieList;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;

  const MovieApp({
    super.key,
    required this.getMovieList,
    required this.getMovieDetails,
    required this.searchMovies,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetMovieDetails>.value(value: getMovieDetails),
        RepositoryProvider<SearchMovies>.value(value: searchMovies),
      ],
      child: BlocProvider<HomeBloc>(
        create: (context) =>
            HomeBloc(getMovieList: getMovieList)..add(const HomeRequested()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: CoreStrings.movieApp,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}