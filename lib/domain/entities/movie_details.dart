import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class MovieDetails extends Equatable {
  final Movie movie;
  final Duration? runtime;
  final List<String> genres;
  final String? tagline;
  final List<CastMember> cast;
  final String? trailerYoutubeKey;
  final WatchProviders? watchProviders;
  final List<Movie> recommendations;

  const MovieDetails({
    required this.movie,
    required this.genres,
    required this.cast,
    required this.recommendations,
    this.runtime,
    this.tagline,
    this.trailerYoutubeKey,
    this.watchProviders,
  });

  @override
  List<Object?> get props => [
    movie,
    runtime,
    genres,
    tagline,
    cast,
    trailerYoutubeKey,
    watchProviders,
    recommendations,
  ];
}

class CastMember extends Equatable {
  final String name;
  final String? character;
  final String? profilePath;

  const CastMember({required this.name, this.character, this.profilePath});

  @override
  List<Object?> get props => [name, character, profilePath];
}

class WatchProviders extends Equatable {
  final Uri link;
  final List<WatchProvider> streaming;
  final List<WatchProvider> free;
  final List<WatchProvider> rent;
  final List<WatchProvider> buy;

  const WatchProviders({
    required this.link,
    this.streaming = const [],
    this.free = const [],
    this.rent = const [],
    this.buy = const [],
  });

  bool get isEmpty =>
      streaming.isEmpty && free.isEmpty && rent.isEmpty && buy.isEmpty;

  @override
  List<Object?> get props => [link, streaming, free, rent, buy];
}

class WatchProvider extends Equatable {
  final String name;
  final String logoPath;

  const WatchProvider({required this.name, required this.logoPath});

  @override
  List<Object?> get props => [name, logoPath];
}