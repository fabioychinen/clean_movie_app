import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';

class MovieCarousel extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie movie) onMovieTap;

  const MovieCarousel({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CardMovieWidget(
              movie: movie,
              onTap: () => onMovieTap(movie),
            ),
          );
        },
      ),
    );
  }
}