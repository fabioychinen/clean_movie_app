import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String title;

  final double voteAverage;

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
  List<Object?> get props => [
    title,
    voteAverage,
    posterPath,
    releaseDate,
    overview,
  ];
}
