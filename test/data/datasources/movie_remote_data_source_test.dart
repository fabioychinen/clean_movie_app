import 'dart:async';
import 'dart:convert';

import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHttpClient client;
  late MovieRemoteDataSource dataSource;

  setUpAll(() => registerFallbackValue(Uri()));

  setUp(() {
    client = MockHttpClient();
    dataSource = MovieRemoteDataSource(
      client: client,
      config: testConfig,
      timeout: const Duration(milliseconds: 50),
    );
  });

  void respondWith(String body, int statusCode) {
    when(() => client.get(any()))
        .thenAnswer((_) async => http.Response(body, statusCode));
  }

  Matcher throwsFetchException({Matcher cause = anything}) => throwsA(
        isA<MovieFetchException>().having((e) => e.cause, 'cause', cause),
      );

  group('sucesso', () {
    setUp(() => respondWith(
          json.encode({
            'results': [tmdbMovieJson()]
          }),
          200,
        ));

    test('getPopularMovies chama /movie/popular com a chave e converte', () async {
      final movies = await dataSource.getPopularMovies();

      expect(movies, [inception]);
      final uri = verify(() => client.get(captureAny())).captured.single as Uri;
      expect(uri.toString(),
          'https://api.test/3/movie/popular?api_key=test-key');
    });

    test('getFreeToWatchMovies chama /movie/now_playing', () async {
      final movies = await dataSource.getFreeToWatchMovies();

      expect(movies, [inception]);
      final uri = verify(() => client.get(captureAny())).captured.single as Uri;
      expect(uri.path, '/3/movie/now_playing');
    });
  });

  group('falhas viram MovieFetchException', () {
    test('status diferente de 200', () {
      respondWith('Not Found', 404);

      expect(dataSource.getPopularMovies(), throwsFetchException());
    });

    test('timeout, preservando a causa', () {
      when(() => client.get(any()))
          .thenAnswer((_) => Completer<http.Response>().future);

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<TimeoutException>()),
      );
    });

    test('falha de rede, preservando a causa', () {
      when(() => client.get(any()))
          .thenThrow(http.ClientException('sem conexão'));

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<http.ClientException>()),
      );
    });

    test('corpo que não é JSON', () {
      respondWith('<html>', 200);

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<FormatException>()),
      );
    });

    test('JSON sem "results"', () {
      respondWith(json.encode({'page': 1}), 200);

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<FormatException>()),
      );
    });

    test('filme malformado dentro de "results"', () {
      respondWith(
        json.encode({
          'results': [
            {'title': 42}
          ]
        }),
        200,
      );

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<FormatException>()),
      );
    });
  });
}
