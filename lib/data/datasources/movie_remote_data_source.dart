import 'dart:convert';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:http/http.dart' as http;
import '../../config/env.dart';

class MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSource({required this.client});

  String get _key => '?api_key=${Env.apiKey}';
  String get _baseUrl => Env.baseUrl;

  String get fetchPopular => '$_baseUrl/movie/popular$_key';
  String get fetchFreeToWatch => '$_baseUrl/movie/now_playing$_key';

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await client.get(Uri.parse(fetchPopular));
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(CoreStrings.fetchPopularMoviesError);
      }
    } catch (e) {
      throw Exception(CoreStrings.fetchPopularMoviesError);
    }
  }

  Future<List<Movie>> getFreeToWatchMovies() async {
    try {
      final response = await client.get(Uri.parse(fetchFreeToWatch));
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(CoreStrings.fetchFreeToWatchMoviesError);
      }
    } catch (e) {
      throw Exception(CoreStrings.fetchFreeToWatchMoviesError);
    }
  }
}