import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';

class CardMovieWidget extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const CardMovieWidget({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              _buildPosterWithRating(),
              const SizedBox(height: 25),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterWithRating() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MoviePoster(
          posterPath: movie.posterPath,
          height: 180,
          width: 120,
          borderRadius: BorderRadius.circular(6),
        ),
        Positioned(
          bottom: -20,
          left: 8,
          child: RatingBadge(voteAverage: movie.voteAverage),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      movie.title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
