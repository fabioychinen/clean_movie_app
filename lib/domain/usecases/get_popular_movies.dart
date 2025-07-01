import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getPopularMovies();
  }
}