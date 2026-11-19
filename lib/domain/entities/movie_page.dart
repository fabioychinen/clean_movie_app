import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class MoviePage extends Equatable {
  final List<Movie> movies;
  final int page;
  final int totalPages;

  const MoviePage({
    required this.movies,
    required this.page,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;

  @override
  List<Object> get props => [movies, page, totalPages];
}