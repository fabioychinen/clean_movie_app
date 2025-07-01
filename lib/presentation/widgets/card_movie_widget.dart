import 'package:flutter/material.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';

class CardMovieWidget extends StatelessWidget {
  final Movie movie;

  const CardMovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final double voteAverage = movie.voteAverage ?? 0;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        padding: const EdgeInsets.all(7),
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              _buildPosterWithRating(voteAverage),
              const SizedBox(height: 25),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie),
      ),
    );
  }

  Widget _buildPosterWithRating(double voteAverage) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildPosterImage(),
        _buildRatingBadge(voteAverage),
      ],
    );
  }

  Widget _buildPosterImage() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRatingBadge(double voteAverage) {
    return Positioned(
      bottom: -20,
      left: 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildRatingCircleBackground(),
          _buildRatingProgress(voteAverage),
          _buildRatingText(voteAverage),
        ],
      ),
    );
  }

  Widget _buildRatingCircleBackground() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildRatingProgress(double voteAverage) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        value: voteAverage / 10,
        backgroundColor: Colors.black12,
        valueColor: AlwaysStoppedAnimation<Color>(
          _getVoteColor(voteAverage),
        ),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildRatingText(double voteAverage) {
    return Text(
      '${(voteAverage * 10).toStringAsFixed(0)}%',
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      movie.title ?? 'Título não disponível',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Color _getVoteColor(double vote) {
    if (vote >= 7.0) {
      return Colors.green;
    } else if (vote >= 4.0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}