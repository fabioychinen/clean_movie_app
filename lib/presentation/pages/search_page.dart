import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/search/search_bloc.dart';
import 'package:clean_movie_app/presentation/layout/constrained_content.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/theme/app_theme.dart';
import 'package:clean_movie_app/presentation/widgets/end_of_scroll_listener.dart';
import 'package:clean_movie_app/presentation/widgets/error_view.dart';
import 'package:clean_movie_app/presentation/widgets/load_more_footer.dart';
import 'package:clean_movie_app/presentation/widgets/movie_poster.dart';
import 'package:clean_movie_app/presentation/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SearchBloc(searchMovies: context.read<SearchMovies>()),
      child: Scaffold(
        appBar: AppBar(titleSpacing: 0, title: const _SearchField()),
        body: SafeArea(
          top: false,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder:
                (context, state) => switch (state) {
                  SearchIdle() => const _Hint(
                    icon: Icons.movie_filter_outlined,
                    text: CoreStrings.searchIdleHint,
                  ),
                  SearchLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SearchLoaded(results: PaginatedMovies(movies: [])) =>
                    const _Hint(
                      icon: Icons.search_off_rounded,
                      text: CoreStrings.noSearchResults,
                    ),
                  SearchLoaded(:final results) => ConstrainedContent(
                    child: _SearchResults(results: results),
                  ),
                  SearchError(:final message) => Center(
                    child: ErrorView(message: message),
                  ),
                },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField();

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<SearchBloc>().add(const SearchSubmitted(''));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: SizedBox(
        height: 48,
        child: ValueListenableBuilder(
          valueListenable: _controller,
          builder:
              (context, value, _) => TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: CoreStrings.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon:
                      value.text.isEmpty
                          ? null
                          : IconButton(
                            tooltip: CoreStrings.clearSearch,
                            icon: const Icon(Icons.close_rounded),
                            onPressed: _clear,
                          ),
                ),
                onSubmitted:
                    (query) =>
                        context.read<SearchBloc>().add(SearchSubmitted(query)),
              ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Hint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final PaginatedMovies results;

  const _SearchResults({required this.results});

  @override
  Widget build(BuildContext context) {
    void requestNextPage() =>
        context.read<SearchBloc>().add(const SearchNextPageRequested());

    final movies = results.movies;
    return EndOfScrollListener(
      onEndReached: results.loadMoreFailed ? null : requestNextPage,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: movies.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder:
            (context, index) =>
                index == movies.length
                    ? LoadMoreFooter(movies: results, onRetry: requestNextPage)
                    : _SearchResultTile(movie: movies[index]),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Movie movie;

  const _SearchResultTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final year = movie.releaseDate?.year;
    final overview = movie.overview;
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        onTap: () => MovieDetailPage.open(context, movie),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoviePoster(
                posterPath: movie.posterPath,
                width: 60,
                height: 90,
                radius: 8,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        RatingBadge(voteAverage: movie.voteAverage),
                        if (year != null)
                          Text(
                            '$year',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    if (overview != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}