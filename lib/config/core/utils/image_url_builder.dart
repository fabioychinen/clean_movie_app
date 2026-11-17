class ImageUrlBuilder {
  static String tmdb(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) {
      return '';
    }

    return 'https://image.tmdb.org/t/p/$size$path';
  }
}