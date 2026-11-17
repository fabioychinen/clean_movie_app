import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _dataSource;

  const MovieRepositoryImpl(this._dataSource);

  @override
  Future<List<Movie>> getMovieList(MovieListType type) =>
      _dataSource.getMovieList(type);

  @override
  Future<MovieDetails> getMovieDetails(MovieId id) =>
      _dataSource.getMovieDetails(id);

  @override
  Future<List<Movie>> searchMovies(String query) =>
      _dataSource.searchMovies(query);
}