import 'package:equatable/equatable.dart';

extension type const MovieId(int value) {}

class Movie extends Equatable {
  final MovieId id;
  final String title;
  final double voteAverage;
  final String? posterPath;
  final DateTime? releaseDate;
  final String? overview;

  const Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    this.posterPath,
    this.releaseDate,
    this.overview,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    voteAverage,
    posterPath,
    releaseDate,
    overview,
  ];
}