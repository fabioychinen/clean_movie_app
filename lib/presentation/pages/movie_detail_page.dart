import 'dart:math';

import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/usecases/get_movie_details.dart';
import 'package:clean_movie_app/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:clean_movie_app/presentation/layout/constrained_content.dart';
import 'package:clean_movie_app/presentation/layout/window_size.dart';
import 'package:clean_movie_app/presentation/theme/app_colors.dart';
import 'package:clean_movie_app/presentation/utils/formatters.dart';
import 'package:clean_movie_app/presentation/utils/open_external_url.dart';
import 'package:clean_movie_app/presentation/widgets/cast_list.dart';
import 'package:clean_movie_app/presentation/widgets/error_view.dart';
import 'package:clean_movie_app/presentation/widgets/movie_backdrop.dart';
import 'package:clean_movie_app/presentation/widgets/movie_carousel.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:clean_movie_app/presentation/widgets/section_header.dart';
import 'package:clean_movie_app/presentation/widgets/skeleton.dart';
import 'package:clean_movie_app/presentation/widgets/where_to_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatelessWidget {
  static const _maxContentWidth = 1000.0;

  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  static Future<void> open(BuildContext context, Movie movie) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  static double backdropHeightOf(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final minimum = kToolbarHeight + MediaQuery.paddingOf(context).top + 48;
    return max(minimum, min(size.width * 9 / 16, size.height * 0.4));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MovieDetailsBloc(getMovieDetails: context.read<GetMovieDetails>())
                ..add(MovieDetailsRequested(movie.id)),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _BackdropAppBar(movie: movie),
            SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                child: ConstrainedContent(
                  maxWidth: _maxContentWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                      builder:
                          (context, state) =>
                              _DetailBody(movie: movie, state: state),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropAppBar extends StatelessWidget {
  final Movie movie;

  const _BackdropAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final collapsedHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top + 1;
    return SliverAppBar(
      pinned: true,
      expandedHeight: MovieDetailPage.backdropHeightOf(context),
      leading: const Padding(
        padding: EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.scrim,
            shape: BoxShape.circle,
          ),
          child: BackButton(color: AppColors.textPrimary),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxHeight <= collapsedHeight;
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsetsDirectional.only(
              start: 64,
              end: 16,
              bottom: 16,
            ),
            title: AnimatedOpacity(
              opacity: isCollapsed ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            background: MovieBackdrop(
              imagePath: movie.backdropPath ?? movie.posterPath,
            ),
          );
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Movie movie;
  final MovieDetailsState state;

  const _DetailBody({required this.movie, required this.state});

  @override
  Widget build(BuildContext context) {
    final details = switch (state) {
      MovieDetailsLoaded(:final details) => details,
      _ => null,
    };
    final trailerKey = details?.trailerYoutubeKey;
    final genres = details?.genres ?? const <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(movie: movie, details: details),
        if (genres.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final genre in genres) Chip(label: Text(genre))],
          ),
        ],
        if (trailerKey != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
                  () => openExternalUrl(context, youtubeVideoUrl(trailerKey)),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(CoreStrings.watchTrailer),
            ),
          ),
        ],
        const SectionHeader(
          CoreStrings.synopsisTitle,
          padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
        ),
        Text(
          movie.overview ?? CoreStrings.noSynopsisAvailable,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        switch (state) {
          MovieDetailsLoading() => const _ExtrasSkeleton(),
          MovieDetailsLoaded(:final details) => _MovieExtras(details: details),
          MovieDetailsError(:final message) => Center(
            child: ErrorView(
              message: message,
              onRetry:
                  () => context.read<MovieDetailsBloc>().add(
                    MovieDetailsRequested(movie.id),
                  ),
            ),
          ),
        },
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Movie movie;
  final MovieDetails? details;

  const _Header({required this.movie, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final posterWidth =
        WindowSize.of(context) == WindowSize.compact ? 110.0 : 160.0;
    final releaseDate = movie.releaseDate;
    final runtime = details?.runtime;
    final tagline = details?.tagline;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MoviePoster(
          posterPath: movie.posterPath,
          width: posterWidth,
          height: posterWidth * 1.5,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movie.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RatingBadge(voteAverage: movie.voteAverage),
                  Text(
                    releaseDate == null
                        ? CoreStrings.unavailableDate
                        : formatDate(releaseDate),
                    style: mutedStyle,
                  ),
                  if (runtime != null)
                    Text(formatRuntime(runtime), style: mutedStyle),
                ],
              ),
              if (tagline != null) ...[
                const SizedBox(height: 10),
                Text(
                  tagline,
                  style: mutedStyle?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
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
    const sectionPadding = EdgeInsets.fromLTRB(0, 24, 0, 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(CoreStrings.whereToWatch, padding: sectionPadding),
        WhereToWatch(providers: details.watchProviders),
        if (details.cast.isNotEmpty) ...[
          const SectionHeader(CoreStrings.cast, padding: sectionPadding),
          CastList(cast: details.cast),
        ],
        if (details.recommendations.isNotEmpty) ...[
          const SectionHeader(
            CoreStrings.recommendations,
            padding: sectionPadding,
          ),
          MovieCarousel(
            movies: details.recommendations,
            onMovieTap: (movie) => MovieDetailPage.open(context, movie),
          ),
        ],
      ],
    );
  }
}

class _ExtrasSkeleton extends StatelessWidget {
  const _ExtrasSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Skeleton(
      child: Padding(
        padding: EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 160, height: 20, radius: 6),
            SizedBox(height: 12),
            SkeletonBox(height: 96),
            SizedBox(height: 24),
            SkeletonBox(width: 120, height: 20, radius: 6),
            SizedBox(height: 12),
            SkeletonBox(height: 120),
          ],
        ),
      ),
    );
  }
}