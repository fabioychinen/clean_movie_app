import 'package:clean_movie_app/presentation/layout/movie_card_metrics.dart';
import 'package:clean_movie_app/presentation/widgets/featured_movie_banner.dart';
import 'package:clean_movie_app/presentation/widgets/skeleton.dart';
import 'package:flutter/material.dart';

class HomeSkeleton extends StatelessWidget {
  static const _sections = 2;
  static const _cardsPerSection = 6;

  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = MovieCardMetrics.of(context);
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SkeletonBox(height: FeaturedMovieBanner.heightOf(context), radius: 0),
          for (var section = 0; section < _sections; section++) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SkeletonBox(width: 160, height: 20, radius: 6),
              ),
            ),
            SizedBox(
              height: metrics.posterHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _cardsPerSection,
                separatorBuilder:
                    (_, _) =>
                        const SizedBox(width: MovieCardMetrics.padding * 2),
                itemBuilder:
                    (_, _) => SkeletonBox(
                      width: metrics.posterWidth,
                      height: metrics.posterHeight,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}