import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:clean_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:clean_movie_app/presentation/app/movie_app.dart';
import 'package:flutter/material.dart';

void main() {
  MovieRepository movieRepository =
      MovieRepositoryImpl(MovieRemoteDataSource(client: http.Client()));

  final getPopularMovies = GetPopularMovies(movieRepository);
  final getFreeToWatchMovies = GetFreeToWatchMovies(movieRepository);

  runApp(MovieApp(
    getPopularMovies: getPopularMovies,
    getFreeToWatchMovies: getFreeToWatchMovies,
  ));
}
