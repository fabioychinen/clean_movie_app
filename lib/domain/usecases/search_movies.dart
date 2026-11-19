import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository _repository;

  const SearchMovies(this._repository);

  Future<MoviePage> call(String query, {int page = 1}) =>
      _repository.searchMovies(query, page: page);
}