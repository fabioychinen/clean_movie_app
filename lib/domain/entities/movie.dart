class Movie {
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final double? voteAverage;
  final String? overview;

  Movie({
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      overview: json['overview'],
    );
  }
}
