import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _dataSource;

  const MovieRepositoryImpl(this._dataSource);

  @override
  Future<MoviePage> getMovieList(MovieListType type, {required int page}) =>
      _dataSource.getMovieList(type, page: page);

  @override
  Future<MovieDetails> getMovieDetails(MovieId id) =>
      _dataSource.getMovieDetails(id);

  @override
  Future<MoviePage> searchMovies(String query, {required int page}) =>
      _dataSource.searchMovies(query, page: page);
}