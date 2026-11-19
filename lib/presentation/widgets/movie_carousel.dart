import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/layout/movie_card_metrics.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:clean_movie_app/presentation/widgets/end_of_scroll_listener.dart';
import 'package:flutter/material.dart';

class MovieCarousel extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie movie) onMovieTap;
  final VoidCallback? onEndReached;
  final Widget? footer;

  const MovieCarousel({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.onEndReached,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;
    final metrics = MovieCardMetrics.of(context);
    return SizedBox(
      height: metrics.cardHeight,
      child: EndOfScrollListener(
        onEndReached: onEndReached,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: movies.length + (footer == null ? 0 : 1),
          itemBuilder: (context, index) {
            if (index == movies.length && footer != null) {
              return SizedBox(width: metrics.cardWidth, child: footer);
            }
            final movie = movies[index];
            return CardMovieWidget(
              movie: movie,
              onTap: () => onMovieTap(movie),
            );
          },
        ),
      ),
    );
  }
}