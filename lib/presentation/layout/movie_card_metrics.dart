import 'package:clean_movie_app/presentation/layout/fixed_line_text.dart';
import 'package:clean_movie_app/presentation/layout/window_size.dart';
import 'package:flutter/widgets.dart';

class MovieCardMetrics {
  static const padding = 6.0;
  static const titleGap = 8.0;
  static const titleFontSize = 13.0;
  static const titleMaxLines = 2;
  static const _posterAspectRatio = 1.5;

  final double posterWidth;
  final double titleHeight;

  const MovieCardMetrics._({
    required this.posterWidth,
    required this.titleHeight,
  });

  factory MovieCardMetrics.of(BuildContext context) {
    final posterWidth = switch (WindowSize.of(context)) {
      WindowSize.compact => 124.0,
      WindowSize.medium => 144.0,
      WindowSize.expanded => 164.0,
    };
    return MovieCardMetrics._(
      posterWidth: posterWidth,
      titleHeight: FixedLineText.heightOf(
        context,
        fontSize: titleFontSize,
        lines: titleMaxLines,
      ),
    );
  }

  double get posterHeight => posterWidth * _posterAspectRatio;

  double get cardWidth => posterWidth + padding * 2;

  double get cardHeight => padding * 2 + posterHeight + titleGap + titleHeight;
}