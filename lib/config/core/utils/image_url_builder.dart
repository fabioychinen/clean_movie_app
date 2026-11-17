import 'package:clean_movie_app/config/core/constants/api_constants.dart';

abstract final class ImageUrlBuilder {
  static String tmdb(String posterPath, {String size = 'w500'}) {
    return '${ApiConstants.tmdbImageBaseUrl}/$size$posterPath';
  }
}
