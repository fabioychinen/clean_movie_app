import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetMovieList {
  final MovieRepository _repository;

  const GetMovieList(this._repository);

  Future<List<Movie>> call(MovieListType type) =>
      _repository.getMovieList(type);
}