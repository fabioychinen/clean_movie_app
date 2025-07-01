// ignore_for_file: use_super_parameters

import 'package:clean_movie_app/domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    String? posterPath,
    String? releaseDate,
    String? title,
    double? voteAverage,
    String? overview,
  }) : super(
          posterPath: posterPath,
          releaseDate: releaseDate,
          title: title,
          voteAverage: voteAverage,
          overview: overview,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      overview: json['overview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'vote_average': voteAverage,
      'overview': overview,
    };
  }
}