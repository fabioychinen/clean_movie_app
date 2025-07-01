import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String formattedReleaseDate = _getFormattedReleaseDate(movie.releaseDate);
    final double voteAverage = movie.voteAverage ?? 0;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPosterImage(),
              const SizedBox(height: 16),
              _buildReleaseAndRating(formattedReleaseDate, voteAverage),
              const SizedBox(height: 16),
              _buildSynopsisTitle(),
              const SizedBox(height: 8),
              _buildSynopsis(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(movie.title ?? 'Detalhes do Filme'),
    );
  }

  Widget _buildPosterImage() {
    if (movie.posterPath == null) return const SizedBox.shrink();

    return Center(
      child: Image.network(
        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
        height: 400,
      ),
    );
  }

  Widget _buildReleaseAndRating(String formattedReleaseDate, double voteAverage) {
    return Row(
      children: [
        Expanded(
          child: _buildReleaseInfo(formattedReleaseDate),
        ),
        const SizedBox(width: 16),
        _buildRatingBadge(voteAverage),
      ],
    );
  }

  Widget _buildReleaseInfo(String formattedReleaseDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data de Lançamento:',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          formattedReleaseDate,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildRatingBadge(double voteAverage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6 * 255),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            value: voteAverage / 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getVoteColor(voteAverage),
            ),
          ),
        ),
        Text(
          '${(voteAverage * 10).toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSynopsisTitle() {
    return const Text(
      'Sinopse:',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSynopsis() {
    return Text(
      movie.overview ?? 'Sinopse não disponível',
      style: const TextStyle(fontSize: 16),
    );
  }

  String _getFormattedReleaseDate(String? releaseDate) {
    if (releaseDate == null) {
      return 'Data não disponível';
    }
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.format(DateTime.parse(releaseDate));
    } catch (_) {
      return 'Data inválida';
    }
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