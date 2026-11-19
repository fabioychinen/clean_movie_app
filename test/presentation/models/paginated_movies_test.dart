import 'package:clean_movie_app/presentation/models/paginated_movies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  final first = PaginatedMovies.firstPage(moviePage([inception]));

  test('a primeira página permite carregar mais quando há próximas', () {
    expect(first.canLoadMore, isTrue);
    expect(first.nextPage, 2);
  });

  test('não permite carregar mais na última página', () {
    final last = PaginatedMovies.firstPage(
      moviePage([inception], totalPages: 1),
    );

    expect(last.canLoadMore, isFalse);
  });

  test('não permite duas cargas ao mesmo tempo', () {
    expect(first.loadingMore().canLoadMore, isFalse);
  });

  test('append junta a próxima página e encerra o carregamento', () {
    final next = first.loadingMore().append(moviePage([sparseMovie], page: 2));

    expect(next.movies, [inception, sparseMovie]);
    expect(next.page, 2);
    expect(next.isLoadingMore, isFalse);
  });

  test('append ignora uma página fora de ordem', () {
    final stale = first.append(moviePage([sparseMovie], page: 5));

    expect(stale, first);
  });

  test('falha ao carregar mais permite tentar de novo', () {
    final failed = first.loadingMore().failedToLoadMore();

    expect(failed.loadMoreFailed, isTrue);
    expect(failed.canLoadMore, isTrue);
  });
}