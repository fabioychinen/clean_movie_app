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
        child: path == null
            ? _buildPlaceholder()
            : Image.network(
                ImageUrlBuilder.tmdb(path, size: 'w185'),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildPlaceholder(),
              ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const ColoredBox(
      color: Colors.black12,
      child: Icon(Icons.person, color: Colors.black38),
    );
  }
}