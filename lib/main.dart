import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:clean_movie_app/presentation/app/movie_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  final config = AppConfig.fromEnvironment();
  final movieRepository = MovieRepositoryImpl(
    MovieRemoteDataSource(client: http.Client(), config: config),
  );

  runApp(MovieApp(
    getPopularMovies: GetPopularMovies(movieRepository),
    getFreeToWatchMovies: GetFreeToWatchMovies(movieRepository),
  ));
}
