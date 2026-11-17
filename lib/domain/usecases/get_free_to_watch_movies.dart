import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetFreeToWatchMovies {
  final MovieRepository _repository;

  const GetFreeToWatchMovies(this._repository);

  Future<List<Movie>> call() => _repository.getFreeToWatchMovies();
}
