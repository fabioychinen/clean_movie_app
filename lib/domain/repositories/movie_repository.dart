import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getMovieList(MovieListType type);
  Future<MovieDetails> getMovieDetails(MovieId id);
  Future<List<Movie>> searchMovies(String query);
}