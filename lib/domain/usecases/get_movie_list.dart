import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetMovieList {
  final MovieRepository _repository;

  const GetMovieList(this._repository);

  Future<MoviePage> call(MovieListType type, {int page = 1}) =>
      _repository.getMovieList(type, page: page);
}