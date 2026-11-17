import 'dart:async';
import 'dart:convert';

import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/config/core/constants/api_constants.dart';
import 'package:clean_movie_app/data/models/movie_json.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/errors/movie_fetch_exception.dart';
import 'package:http/http.dart' as http;

class MovieRemoteDataSource {
  final http.Client _client;
  final AppConfig _config;
  final Duration _timeout;

  MovieRemoteDataSource({
    required http.Client client,
    required AppConfig config,
    Duration timeout = ApiConstants.requestTimeout,
  }) : _client = client,
       _config = config,
       _timeout = timeout;

  Future<List<Movie>> getPopularMovies() => _fetchMovies('/movie/popular');

  Future<List<Movie>> getFreeToWatchMovies() => _fetchMovies(
    '/discover/movie',
    query: {
      'watch_region': ApiConstants.tmdbRegion,
      'with_watch_monetization_types': 'free',
      'sort_by': 'popularity.desc',
    },
  );

  Future<List<Movie>> _fetchMovies(
    String path, {
    Map<String, String> query = const {},
  }) async {
    final uri = Uri.parse('${_config.tmdbBaseUrl}$path').replace(
      queryParameters: {
        'language': ApiConstants.tmdbLanguage,
        'region': ApiConstants.tmdbRegion,
        ...query,
      },
    );

    final http.Response response;
    try {
      response = await _client
          .get(
            uri,
            headers: {'Authorization': 'Bearer ${_config.tmdbReadAccessToken}'},
          )
          .timeout(_timeout);
    } on TimeoutException catch (e) {
      throw MovieFetchException('Timeout em $path', cause: e);
    } on http.ClientException catch (e) {
      throw MovieFetchException('Falha de rede em $path', cause: e);
    }

    if (response.statusCode != 200) {
      throw MovieFetchException('HTTP ${response.statusCode} em $path');
    }

    try {
      final Object? body = json.decode(response.body);
      if (body case {'results': final List<Object?> results}) {
        return results.map(movieFromJson).toList();
      }
      throw const FormatException('Resposta sem a lista "results"');
    } on FormatException catch (e) {
      throw MovieFetchException('Resposta inválida em $path', cause: e);
    }
  }
}
