import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:clean_movie_app/presentation/pages/about_page.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:clean_movie_app/presentation/widgets/error_view.dart';
import 'package:clean_movie_app/presentation/widgets/featured_movie_banner.dart';
import 'package:clean_movie_app/presentation/widgets/home_skeleton.dart';
import 'package:clean_movie_app/presentation/widgets/load_more_footer.dart';
import 'package:clean_movie_app/presentation/widgets/movie_carousel.dart';
import 'package:clean_movie_app/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.movie_filter_rounded, color: colors.primary),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                CoreStrings.movieAndSeries,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: CoreStrings.search,
            icon: const Icon(Icons.search_rounded),
            onPressed: () => SearchPage.open(context),
          ),
          IconButton(
            tooltip: CoreStrings.about,
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => AboutPage.open(context),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder:
              (context, state) => switch (state) {
                HomeLoading() => const HomeSkeleton(),
                HomeLoaded() => _HomeContent(state: state),
                HomeError(:final message) => Center(
                  child: ErrorView(
                    message: message,
                    onRetry:
                        () =>
                            context.read<HomeBloc>().add(const HomeRequested()),
                  ),
                ),
              },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeLoaded state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final featured = _featuredMovie();
    final sections = [
      for (final type in MovieListType.values)
        if (state.sections[type] case final movies?
            when movies.movies.isNotEmpty)
          (type, movies),
    ];
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sections.length + (featured == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (featured != null) {
          if (index == 0) {
            return FeaturedMovieBanner(
              movie: featured,
              onTap: () => MovieDetailPage.open(context, featured),
            );
          }
          index--;
        }
        final (type, movies) = sections[index];
        return _HomeSection(type: type, movies: movies);
      },
    );
  }

  Movie? _featuredMovie() {
    final trending = state.sections[MovieListType.trending]?.movies ?? [];
    return trending.where((movie) => movie.backdropPath != null).firstOrNull;
  }
}

class _HomeSection extends StatelessWidget {
  final MovieListType type;
  final PaginatedMovies movies;

  const _HomeSection({required this.type, required this.movies});

  @override
  Widget build(BuildContext context) {
    void requestNextPage() =>
        context.read<HomeBloc>().add(HomeNextPageRequested(type));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(_titleFor(type)),
        MovieCarousel(
          movies: movies.movies,
          onMovieTap: (movie) => MovieDetailPage.open(context, movie),
          onEndReached: movies.loadMoreFailed ? null : requestNextPage,
          footer: LoadMoreFooter(movies: movies, onRetry: requestNextPage),
        ),
      ],
    );
  }

  String _titleFor(MovieListType type) {
    return switch (type) {
      MovieListType.trending => CoreStrings.trendingSection,
      MovieListType.nowPlaying => CoreStrings.nowPlayingSection,
      MovieListType.popular => CoreStrings.popularMoviesSection,
      MovieListType.freeToWatch => CoreStrings.freeToWatchSection,
      MovieListType.topRated => CoreStrings.topRatedSection,
      MovieListType.upcoming => CoreStrings.upcomingSection,
    };
  }
}