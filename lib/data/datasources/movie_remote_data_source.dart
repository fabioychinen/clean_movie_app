import 'dart:convert';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:http/http.dart' as http;

class MovieRemoteDataSource {
  final http.Client client;
  final String apiKey = '88efd5107320ab503dcd9aae2c475996';
  final String _baseUrl = "https://api.themoviedb.org/3";
  final String _key = "?api_key=88efd5107320ab503dcd9aae2c475996";
  String get fetchPopular => "$_baseUrl/movie/popular$_key";
  String get fetchFreeToWatch => "$_baseUrl/movie/now_playing$_key";

  MovieRemoteDataSource({required this.client});
  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await client.get(Uri.parse(fetchPopular));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print(
            'Failed to load popular movies - Status Code: ${response.statusCode}');
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      print('Error loading popular movies: $e');
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getFreeToWatchMovies() async {
    try {
      final response = await client.get(Uri.parse(fetchFreeToWatch));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print(
            'Failed to load free to watch movies - Status Code: ${response.statusCode}');
        throw Exception('Failed to load free to watch movies');
      }
    } catch (e) {
      print('Error loading free to watch movies: $e');
      throw Exception('Failed to load free to watch movies');
    }
  }
}
