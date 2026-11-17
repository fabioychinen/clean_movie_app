import 'dart:async';
import 'dart:convert';

import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/config/core/constants/api_constants.dart';
import 'package:clean_movie_app/data/models/movie_details_json.dart';
import 'package:clean_movie_app/data/models/movie_json.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
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

  Future<List<Movie>> getMovieList(MovieListType type) {
    final (path, query) = switch (type) {
      MovieListType.trending => ('/trending/movie/week', _noQuery),
      MovieListType.popular => ('/movie/popular', _noQuery),
      MovieListType.freeToWatch => (
        '/discover/movie',
        const {
          'watch_region': ApiConstants.tmdbRegion,
          'with_watch_monetization_types': 'free',
          'sort_by': 'popularity.desc',
        },
      ),
      MovieListType.topRated => ('/movie/top_rated', _noQuery),
      MovieListType.upcoming => ('/movie/upcoming', _noQuery),
    };
    return _get(path, movieListFromJson, query: query);
  }

  Future<MovieDetails> getMovieDetails(MovieId id) {
    return _get(
      '/movie/${id.value}',
      (body) => movieDetailsFromJson(
        body,
        region: ApiConstants.tmdbRegion,
        maxCastMembers: ApiConstants.maxCastMembers,
      ),
      query: const {
        'append_to_response': 'credits,videos,watch/providers,recommendations',
        'include_video_language': 'pt-BR,en',
      },
    );
  }

  Future<List<Movie>> searchMovies(String query) {
    return _get('/search/movie', movieListFromJson, query: {'query': query});
  }

  static const _noQuery = <String, String>{};

  Future<T> _get<T>(
    String path,
    T Function(Object? body) parse, {
    required Map<String, String> query,
  }) async {
    final uri = Uri.parse('${_config.tmdbBaseUrl}$path').replace(
      queryParameters: {
        'api_key': _config.tmdbApiKey,
        'language': ApiConstants.tmdbLanguage,
        'region': ApiConstants.tmdbRegion,
        ...query,
      },
    );

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
      return parse(json.decode(response.body));
    } on FormatException catch (e) {
      throw MovieFetchException('Resposta inválida em $path', cause: e);
    }
  }
}