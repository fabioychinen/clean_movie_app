import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  static const _maxTextScale = 1.3;

  final double voteAverage;

  const RatingBadge({super.key, required this.voteAverage});

  static Color colorFor(double voteAverage) {
    if (voteAverage >= 7.0) return AppColors.ratingHigh;
    if (voteAverage >= 4.0) return AppColors.ratingMid;
    return AppColors.ratingLow;
  }

  @override
  Widget build(BuildContext context) {
    final hasRatings = voteAverage > 0;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: _maxTextScale,
      child: Semantics(
        label:
            hasRatings
                ? 'Nota ${voteAverage.toStringAsFixed(1)} de 10'
                : CoreStrings.noRatings,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.scrim,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color:
                      hasRatings ? colorFor(voteAverage) : AppColors.textMuted,
                ),
                const SizedBox(width: 3),
                Text(
                  hasRatings ? voteAverage.toStringAsFixed(1) : '–',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}