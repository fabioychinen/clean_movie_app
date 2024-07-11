import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    String formattedReleaseDate = '';
    if (movie.releaseDate != null) {
      final dateFormat = DateFormat('dd/MM/yyyy');
      formattedReleaseDate =
          dateFormat.format(DateTime.parse(movie.releaseDate!));
    } else {
      formattedReleaseDate = 'Data não disponível';
    }

    double voteAverage = movie.voteAverage ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title ?? 'Detalhes do Filme'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                Center(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 400,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Positioned(
                    bottom: -20,
                    left: 8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Sinopse:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.overview ?? 'Sinopse não disponível',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
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
