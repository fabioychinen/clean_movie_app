import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';

abstract interface class MovieRepository {
  Future<MoviePage> getMovieList(MovieListType type, {required int page});
  Future<MovieDetails> getMovieDetails(MovieId id);
  Future<MoviePage> searchMovies(String query, {required int page});
}