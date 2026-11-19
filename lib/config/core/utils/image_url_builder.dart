import 'package:clean_movie_app/config/core/constants/api_constants.dart';

enum TmdbImageSize {
  logo('w92'),
  profile('w185'),
  thumbnail('w185'),
  poster('w500'),
  backdrop('w780'),
  backdropLarge('w1280');

  final String path;

  const TmdbImageSize(this.path);
}

abstract final class ImageUrlBuilder {
  static String tmdb(
    String imagePath, {
    TmdbImageSize size = TmdbImageSize.poster,
  }) {
    return '${ApiConstants.tmdbImageBaseUrl}/${size.path}$imagePath';
  }
}