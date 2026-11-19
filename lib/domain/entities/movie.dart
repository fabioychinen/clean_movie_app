import 'package:equatable/equatable.dart';

extension type const MovieId(int value) {}

class Movie extends Equatable {
  final MovieId id;
  final String title;
  final double voteAverage;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final String? overview;

  const Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.overview,
  });

  bool get hasRatings => voteAverage > 0;

  @override
  List<Object?> get props => [
    id,
    title,
    voteAverage,
    posterPath,
    backdropPath,
    releaseDate,
    overview,
  ];
}