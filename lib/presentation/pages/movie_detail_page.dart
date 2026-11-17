import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MoviePoster(posterPath: movie.posterPath, height: 400),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildReleaseInfo()),
                  const SizedBox(width: 16),
                  RatingBadge(voteAverage: movie.voteAverage),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                CoreStrings.synopsisTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.overview ?? CoreStrings.noSynopsisAvailable,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReleaseInfo() {
    final releaseDate = movie.releaseDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          CoreStrings.releaseDate,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          releaseDate == null
              ? CoreStrings.unavailableDate
              : DateFormat('dd/MM/yyyy').format(releaseDate),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
