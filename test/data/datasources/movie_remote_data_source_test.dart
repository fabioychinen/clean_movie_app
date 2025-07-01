import 'dart:convert';
import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MovieRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSource(client: mockHttpClient);
  });

  group('getPopularMovies', () {
    test(
        'returns a list of popular movies if the http call completes successfully',
        () async {
      final mockResponse = {
        'results': [
          {
            'poster_path': '/poster_path_1.jpg',
            'release_date': '2023-06-15',
            'title': 'Movie 1',
            'vote_average': 8.0,
            'overview': 'Overview of Movie 1',
          },
          {
            'poster_path': '/poster_path_2.jpg',
            'release_date': '2023-07-20',
            'title': 'Movie 2',
            'vote_average': 7.5,
            'overview': 'Overview of Movie 2',
          },
        ]
      };

      when(() => mockHttpClient
              .get(Uri.parse(any(that: contains('/movie/popular')))))
          .thenAnswer(
              (_) async => http.Response(json.encode(mockResponse), 200));

      final result = await dataSource.getPopularMovies();

      expect(
          result.map((movie) => movie.title), equals(['Movie 1', 'Movie 2']));
      verify(() => mockHttpClient
          .get(Uri.parse(any(that: contains('/movie/popular'))))).called(1);
    });

    test('throws an exception if the http call completes with an error',
        () async {
      when(() => mockHttpClient
              .get(Uri.parse(any(that: contains('/movie/popular')))))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => dataSource.getPopularMovies(), throwsException);
      verify(() => mockHttpClient
          .get(Uri.parse(any(that: contains('/movie/popular'))))).called(1);
    });
  });

  group('getFreeToWatchMovies', () {
    test(
        'returns a list of free to watch movies if the http call completes successfully',
        () async {
      final mockResponse = {
        'results': [
          {
            'poster_path': '/poster_path_1.jpg',
            'release_date': '2023-06-15',
            'title': 'Movie 1',
            'vote_average': 8.0,
            'overview': 'Overview of Movie 1',
          },
          {
            'poster_path': '/poster_path_2.jpg',
            'release_date': '2023-07-20',
            'title': 'Movie 2',
            'vote_average': 7.5,
            'overview': 'Overview of Movie 2',
          },
        ]
      };

      when(() => mockHttpClient
              .get(Uri.parse(any(that: contains('/movie/now_playing')))))
          .thenAnswer(
              (_) async => http.Response(json.encode(mockResponse), 200));

      final result = await dataSource.getFreeToWatchMovies();

      expect(
          result.map((movie) => movie.title), equals(['Movie 1', 'Movie 2']));
      verify(() => mockHttpClient
          .get(Uri.parse(any(that: contains('/movie/now_playing'))))).called(1);
    });

    test('throws an exception if the http call completes with an error',
        () async {
      when(() => mockHttpClient
              .get(Uri.parse(any(that: contains('/movie/now_playing')))))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => dataSource.getFreeToWatchMovies(), throwsException);
      verify(() => mockHttpClient
          .get(Uri.parse(any(that: contains('/movie/now_playing'))))).called(1);
    });
  });
}