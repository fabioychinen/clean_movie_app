import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource dataSource;

  MovieRepositoryImpl(this.dataSource);

  @override
  Future<List<Movie>> getPopularMovies() async {
    return await dataSource.getPopularMovies();
  }

  @override
  Future<List<Movie>> getFreeToWatchMovies() async {
    return await dataSource.getFreeToWatchMovies();
  }
}
