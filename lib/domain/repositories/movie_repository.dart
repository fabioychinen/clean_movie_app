import 'package:clean_movie_app/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getFreeToWatchMovies();
}