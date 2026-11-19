import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:flutter/material.dart';

class MovieBackdrop extends StatelessWidget {
  final String? imagePath;
  final TmdbImageSize size;

  const MovieBackdrop({
    super.key,
    required this.imagePath,
    this.size = TmdbImageSize.backdrop,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (path == null)
          _buildPlaceholder(context)
        else
          Image.network(
            ImageUrlBuilder.tmdb(path, size: size),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, _, _) => _buildPlaceholder(context),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                surface.withValues(alpha: 0.15),
                surface.withValues(alpha: 0),
                surface.withValues(alpha: 0.75),
                surface,
              ],
              stops: const [0, 0.35, 0.8, 1],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.surfaceContainerHighest, colors.surface],
        ),
      ),
    );
  }
}