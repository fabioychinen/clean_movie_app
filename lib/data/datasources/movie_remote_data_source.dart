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
  })  : _client = client,
        _config = config,
        _timeout = timeout;

  /// Lança [MovieFetchException].
  Future<List<Movie>> getPopularMovies() => _fetchMovies('/movie/popular');

  /// Lança [MovieFetchException].
  Future<List<Movie>> getFreeToWatchMovies() =>
      _fetchMovies('/movie/now_playing');

  Future<List<Movie>> _fetchMovies(String path) async {
    final uri = Uri.parse('${_config.tmdbBaseUrl}$path')
        .replace(queryParameters: {'api_key': _config.tmdbApiKey});

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
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
