import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';
import 'package:equatable/equatable.dart';

class PaginatedMovies extends Equatable {
  final List<Movie> movies;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  const PaginatedMovies({
    required this.movies,
    required this.page,
    required this.hasNextPage,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  PaginatedMovies.firstPage(MoviePage firstPage)
    : this(
        movies: firstPage.movies,
        page: firstPage.page,
        hasNextPage: firstPage.hasNextPage,
      );

  bool get canLoadMore => hasNextPage && !isLoadingMore;

  int get nextPage => page + 1;

  PaginatedMovies loadingMore() => PaginatedMovies(
    movies: movies,
    page: page,
    hasNextPage: hasNextPage,
    isLoadingMore: true,
  );

  PaginatedMovies failedToLoadMore() => PaginatedMovies(
    movies: movies,
    page: page,
    hasNextPage: hasNextPage,
    loadMoreFailed: true,
  );

  PaginatedMovies append(MoviePage next) {
    if (next.page != nextPage) return this;
    return PaginatedMovies(
      movies: [...movies, ...next.movies],
      page: next.page,
      hasNextPage: next.hasNextPage,
    );
  }

  @override
  List<Object> get props => [
    movies,
    page,
    hasNextPage,
    isLoadingMore,
    loadMoreFailed,
  ];
}