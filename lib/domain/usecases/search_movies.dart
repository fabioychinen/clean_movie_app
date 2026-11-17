import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository _repository;

  const SearchMovies(this._repository);

  Future<List<Movie>> call(String query) => _repository.searchMovies(query);
}