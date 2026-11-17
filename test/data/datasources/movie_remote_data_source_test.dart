import 'dart:async';
import 'dart:convert';

import 'package:clean_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
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

  void respondWith(Object? body, {int statusCode = 200}) {
    when(
      () => client.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response(
        body is String ? body : json.encode(body),
        statusCode,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );
  }

  Uri capturedUri() {
    return verify(
          () => client.get(captureAny(), headers: any(named: 'headers')),
        ).captured.single
        as Uri;
  }

  Matcher throwsFetchException({Matcher cause = anything}) => throwsA(
    isA<MovieFetchException>().having((e) => e.cause, 'cause', cause),
  );

  final movieListBody = {
    'results': [tmdbMovieJson()],
  };

  group('getMovieList', () {
    const expectedPaths = {
      MovieListType.trending: '/3/trending/movie/week',
      MovieListType.popular: '/3/movie/popular',
      MovieListType.freeToWatch: '/3/discover/movie',
      MovieListType.topRated: '/3/movie/top_rated',
      MovieListType.upcoming: '/3/movie/upcoming',
    };

    for (final type in MovieListType.values) {
      test('$type chama ${expectedPaths[type]} e converte', () async {
        respondWith(movieListBody);

        expect(await dataSource.getMovieList(type), [inception]);
        final uri = capturedUri();
        expect(uri.path, expectedPaths[type]);
        expect(uri.queryParameters['language'], 'pt-BR');
        expect(uri.queryParameters['region'], 'BR');
      });
    }

    test('freeToWatch filtra filmes grátis no Brasil', () async {
      respondWith(movieListBody);

      await dataSource.getMovieList(MovieListType.freeToWatch);

      final uri = capturedUri();
      expect(uri.queryParameters, {
        'api_key': 'test-key',
        'language': 'pt-BR',
        'region': 'BR',
        'watch_region': 'BR',
        'with_watch_monetization_types': 'free',
        'sort_by': 'popularity.desc',
      });
    });
  });

  test('envia a chave da API na URL', () async {
    respondWith(movieListBody);

    await dataSource.getMovieList(MovieListType.popular);

    final uri = capturedUri();
    expect(uri.queryParameters['api_key'], 'test-key');
  });

  test('getMovieDetails pede tudo numa requisição e converte', () async {
    respondWith(tmdbMovieDetailsJson());

    expect(
      await dataSource.getMovieDetails(const MovieId(27205)),
      inceptionDetails,
    );
    final uri = capturedUri();
    expect(uri.path, '/3/movie/27205');
    expect(
      uri.queryParameters['append_to_response'],
      'credits,videos,watch/providers,recommendations',
    );
    expect(uri.queryParameters['include_video_language'], 'pt-BR,en');
  });

  test('searchMovies envia o termo e converte', () async {
    respondWith(movieListBody);

    expect(await dataSource.searchMovies('inception'), [inception]);
    final uri = capturedUri();
    expect(uri.path, '/3/search/movie');
    expect(uri.queryParameters['query'], 'inception');
  });

  group('falhas viram MovieFetchException', () {
    Future<List<Movie>> fetch() =>
        dataSource.getMovieList(MovieListType.popular);

    test('status diferente de 200', () {
      respondWith('Not Found', statusCode: 404);

      expect(fetch(), throwsFetchException());
    });

    test('timeout, preservando a causa', () {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) => Completer<http.Response>().future);

      expect(fetch(), throwsFetchException(cause: isA<TimeoutException>()));
    });

    test('falha de rede, preservando a causa', () {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenThrow(http.ClientException('sem conexão'));

      expect(
        fetch(),
        throwsFetchException(cause: isA<http.ClientException>()),
      );
    });

    test('corpo que não é JSON', () {
      respondWith('<html>');

      expect(fetch(), throwsFetchException(cause: isA<FormatException>()));
    });

    test('filme malformado dentro de "results"', () {
      respondWith({
        'results': [
          {'title': 42},
        ],
      });

      expect(fetch(), throwsFetchException(cause: isA<FormatException>()));
    });

    test('detalhes malformados', () {
      respondWith(tmdbMovieDetailsJson()..remove('videos'));

      expect(
        dataSource.getMovieDetails(const MovieId(27205)),
        throwsFetchException(cause: isA<FormatException>()),
      );
    });
  });
}