import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String title;

  /// Nota de 0 a 10, como a TMDB publica.
  final double voteAverage;

  /// Os campos abaixo podem faltar na TMDB; `null` significa "não informado".
  final String? posterPath;
  final DateTime? releaseDate;
  final String? overview;

  const Movie({
    required this.title,
    required this.voteAverage,
    this.posterPath,
    this.releaseDate,
    this.overview,
  });

  @override
  List<Object?> get props =>
      [title, voteAverage, posterPath, releaseDate, overview];
}
