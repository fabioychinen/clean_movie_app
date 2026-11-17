import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/app/movie_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  final config = AppConfig.fromEnvironment();
  final movieRepository = MovieRepositoryImpl(
    MovieRemoteDataSource(client: http.Client(), config: config),
  );

  runApp(
    MovieApp(
      getMovieList: GetMovieList(movieRepository),
      getMovieDetails: GetMovieDetails(movieRepository),
      searchMovies: SearchMovies(movieRepository),
    ),
  );
}