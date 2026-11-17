import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository _repository;

  const GetMovieDetails(this._repository);

  Future<MovieDetails> call(MovieId id) => _repository.getMovieDetails(id);
}