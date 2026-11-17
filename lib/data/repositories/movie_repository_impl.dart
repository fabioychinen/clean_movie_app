import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _dataSource;

  const MovieRepositoryImpl(this._dataSource);

  @override
  Future<List<Movie>> getPopularMovies() => _dataSource.getPopularMovies();

  @override
  Future<List<Movie>> getFreeToWatchMovies() =>
      _dataSource.getFreeToWatchMovies();
}
