import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';
import 'package:clean_movie_app/domain/usecases/get_free_to_watch_movies.dart';
import 'package:clean_movie_app/domain/usecases/get_popular_movies.dart';
import 'package:clean_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockMovieRepository extends Mock implements MovieRepository {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetFreeToWatchMovies extends Mock implements GetFreeToWatchMovies {}

class MockMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieBloc {}
