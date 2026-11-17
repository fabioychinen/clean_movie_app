import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:flutter/material.dart';

/// Pôster da TMDB; mostra um placeholder quando não há imagem ou ela falha.
class MoviePoster extends StatelessWidget {
  final String? posterPath;
  final double height;
  final double? width;
  final BorderRadius borderRadius;

  const MoviePoster({
    super.key,
    required this.posterPath,
    required this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    final path = posterPath;
    return ClipRRect(
      borderRadius: borderRadius,
      child: path == null
          ? _buildPlaceholder()
          : Image.network(
              ImageUrlBuilder.tmdb(path),
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      // Pôsteres da TMDB têm proporção 2:3.
      width: width ?? height * 2 / 3,
      color: Colors.black12,
      child: const Icon(Icons.movie, color: Colors.black38),
    );
  }
}
