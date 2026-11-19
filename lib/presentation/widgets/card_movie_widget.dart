import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/layout/fixed_line_text.dart';
import 'package:clean_movie_app/presentation/layout/movie_card_metrics.dart';
import 'package:clean_movie_app/presentation/theme/app_theme.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';

class CardMovieWidget extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const CardMovieWidget({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final metrics = MovieCardMetrics.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
      child: Padding(
        padding: const EdgeInsets.all(MovieCardMetrics.padding),
        child: SizedBox(
          width: metrics.posterWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  MoviePoster(
                    posterPath: movie.posterPath,
                    height: metrics.posterHeight,
                    width: metrics.posterWidth,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: RatingBadge(voteAverage: movie.voteAverage),
                  ),
                ],
              ),
              const SizedBox(height: MovieCardMetrics.titleGap),
              SizedBox(
                height: metrics.titleHeight,
                child: FixedLineText(
                  movie.title,
                  fontSize: MovieCardMetrics.titleFontSize,
                  maxLines: MovieCardMetrics.titleMaxLines,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}