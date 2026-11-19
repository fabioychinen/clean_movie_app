import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String? profilePath;
  final double size;

  const ProfilePhoto({super.key, required this.profilePath, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final path = profilePath;
    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child:
            path == null
                ? _buildPlaceholder(context)
                : Image.network(
                  ImageUrlBuilder.tmdb(path, size: TmdbImageSize.profile),
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => _buildPlaceholder(context),
                ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Icon(Icons.person_outline, color: colors.onSurfaceVariant),
    );
  }
}