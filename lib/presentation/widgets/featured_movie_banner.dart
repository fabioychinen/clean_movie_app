import 'dart:math';

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/layout/window_size.dart';
import 'package:clean_movie_app/presentation/widgets/movie_backdrop.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';

class FeaturedMovieBanner extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const FeaturedMovieBanner({
    super.key,
    required this.movie,
    required this.onTap,
  });

  static double heightOf(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final widthFactor =
        WindowSize.of(context) == WindowSize.compact ? 1.0 : 0.45;
    return min(size.width * widthFactor, size.height * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final year = movie.releaseDate?.year;
    return SizedBox(
      height: heightOf(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MovieBackdrop(
            imagePath: movie.backdropPath ?? movie.posterPath,
            size:
                WindowSize.of(context) == WindowSize.compact
                    ? TmdbImageSize.backdrop
                    : TmdbImageSize.backdropLarge,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CoreStrings.featuredLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBadge(voteAverage: movie.voteAverage),
                    if (year != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        '$year',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text(CoreStrings.seeDetails),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}