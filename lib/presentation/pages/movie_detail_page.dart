import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:clean_movie_app/presentation/utils/formatters.dart';
import 'package:clean_movie_app/presentation/utils/open_external_url.dart';
import 'package:clean_movie_app/presentation/widgets/cast_list.dart';
import 'package:clean_movie_app/presentation/widgets/movie_carousel.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:clean_movie_app/presentation/widgets/where_to_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  static Future<void> open(BuildContext context, Movie movie) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsBloc(
        getMovieDetails: context.read<GetMovieDetails>(),
      )..add(MovieDetailsRequested(movie.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(movie.title)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
              const _SectionTitle(CoreStrings.synopsisTitle),
              Text(
                movie.overview ?? CoreStrings.noSynopsisAvailable,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                builder: (context, state) => switch (state) {
                  MovieDetailsLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  MovieDetailsLoaded(:final details) => _MovieExtras(
                    details: details,
                  ),
                  MovieDetailsError(:final message) => Text(message),
                },
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
              : formatDate(releaseDate),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _MovieExtras extends StatelessWidget {
  final MovieDetails details;

  const _MovieExtras({required this.details});

  @override
  Widget build(BuildContext context) {
    final tagline = details.tagline;
    final runtime = details.runtime;
    final trailerKey = details.trailerYoutubeKey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tagline != null) ...[
          Text(tagline, style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (runtime != null) Text(formatRuntime(runtime)),
            for (final genre in details.genres) Chip(label: Text(genre)),
          ],
        ),
        if (trailerKey != null) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () =>
                openExternalUrl(context, youtubeVideoUrl(trailerKey)),
            icon: const Icon(Icons.play_arrow),
            label: const Text(CoreStrings.watchTrailer),
          ),
        ],
        const SizedBox(height: 24),
        WhereToWatch(providers: details.watchProviders),
        if (details.cast.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle(CoreStrings.cast),
          CastList(cast: details.cast),
        ],
        if (details.recommendations.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle(CoreStrings.recommendations),
          MovieCarousel(
            movies: details.recommendations,
            onMovieTap: (movie) => MovieDetailPage.open(context, movie),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}