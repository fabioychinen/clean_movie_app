import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:flutter/material.dart';

class LoadMoreFooter extends StatelessWidget {
  final PaginatedMovies movies;
  final VoidCallback onRetry;

  const LoadMoreFooter({
    super.key,
    required this.movies,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (movies.loadMoreFailed) {
      return Center(
        child: IconButton(
          tooltip: CoreStrings.retryLoadMore,
          icon: const Icon(Icons.refresh),
          onPressed: onRetry,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}