import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:clean_movie_app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final String? posterPath;
  final double height;
  final double? width;
  final double radius;

  const MoviePoster({
    super.key,
    required this.posterPath,
    required this.height,
    this.width,
    this.radius = AppTheme.cornerRadius,
  });

  @override
  Widget build(BuildContext context) {
    final path = posterPath;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child:
            path == null
                ? _buildPlaceholder(context)
                : Image.network(
                  ImageUrlBuilder.tmdb(path),
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => _buildPlaceholder(context),
                ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: height,
      width: width ?? height * 2 / 3,
      color: colors.surfaceContainerHighest,
      child: Icon(Icons.movie_outlined, color: colors.onSurfaceVariant),
    );
  }
}