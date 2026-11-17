import 'package:clean_movie_app/config/core/constants/api_constants.dart';

abstract final class ImageUrlBuilder {
  static String tmdb(String imagePath, {String size = 'w500'}) {
    return '${ApiConstants.tmdbImageBaseUrl}/$size$imagePath';
  }
}