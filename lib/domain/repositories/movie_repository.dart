import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';

/// Ambos os métodos lançam [MovieFetchException] em qualquer falha de obtenção.
abstract interface class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getFreeToWatchMovies();
}
