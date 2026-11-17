import 'package:bloc_test/bloc_test.dart';
import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/repositories/movie_repository.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_list.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockMovieRepository extends Mock implements MovieRepository {}

class MockGetMovieList extends Mock implements GetMovieList {}

class MockGetMovieDetails extends Mock implements GetMovieDetails {}

class MockSearchMovies extends Mock implements SearchMovies {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}