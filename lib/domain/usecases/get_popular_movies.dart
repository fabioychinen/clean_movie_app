import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository _repository;

  const GetPopularMovies(this._repository);

  Future<List<Movie>> call() => _repository.getPopularMovies();
}
