import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetFreeToWatchMovies {
  final MovieRepository repository;

  GetFreeToWatchMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getFreeToWatchMovies();
  }
}
