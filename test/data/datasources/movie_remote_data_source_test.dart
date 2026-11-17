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
    when(
      () => client.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(body, statusCode));
  }

  Matcher throwsFetchException({Matcher cause = anything}) => throwsA(
    isA<MovieFetchException>().having((e) => e.cause, 'cause', cause),
  );

  group('sucesso', () {
    setUp(
      () => respondWith(
        json.encode({
          'results': [tmdbMovieJson()],
        }),
        200,
      ),
    );

    (Uri, Map<String, String>) capturedRequest() {
      final captured =
          verify(
            () =>
                client.get(captureAny(), headers: captureAny(named: 'headers')),
          ).captured;
      return (captured[0] as Uri, captured[1] as Map<String, String>);
    }

    test('getPopularMovies chama /movie/popular em pt-BR e converte', () async {
      final movies = await dataSource.getPopularMovies();

      expect(movies, [inception]);
      final (uri, _) = capturedRequest();
      expect(uri.path, '/3/movie/popular');
      expect(uri.queryParameters, {'language': 'pt-BR', 'region': 'BR'});
    });

    test('autentica pelo header, sem chave na URL', () async {
      await dataSource.getPopularMovies();

      final (uri, headers) = capturedRequest();
      expect(headers['Authorization'], 'Bearer test-token');
      expect(uri.queryParameters.keys, isNot(contains('api_key')));
    });

    test('getFreeToWatchMovies filtra filmes grátis no Brasil', () async {
      final movies = await dataSource.getFreeToWatchMovies();

      expect(movies, [inception]);
      final (uri, _) = capturedRequest();
      expect(uri.path, '/3/discover/movie');
      expect(uri.queryParameters, {
        'language': 'pt-BR',
        'region': 'BR',
        'watch_region': 'BR',
        'with_watch_monetization_types': 'free',
        'sort_by': 'popularity.desc',
      });
    });
  });

  group('falhas viram MovieFetchException', () {
    test('status diferente de 200', () {
      respondWith('Not Found', 404);

      expect(dataSource.getPopularMovies(), throwsFetchException());
    });

    test('timeout, preservando a causa', () {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) => Completer<http.Response>().future);

      expect(
        dataSource.getPopularMovies(),
        throwsFetchException(cause: isA<TimeoutException>()),
      );
    });

    test('falha de rede, preservando a causa', () {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenThrow(http.ClientException('sem conexão'));

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
            {'title': 42},
          ],
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
