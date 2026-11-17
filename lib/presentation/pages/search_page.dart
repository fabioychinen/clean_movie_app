import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/usecases/search_movies.dart';
import 'package:clean_movie_app/presentation/bloc/search/search_bloc.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
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
      create: (context) =>
          SearchBloc(searchMovies: context.read<SearchMovies>()),
      child: Scaffold(
        appBar: AppBar(title: const _SearchField()),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) => switch (state) {
            SearchIdle() => const SizedBox.shrink(),
            SearchLoading() => const Center(child: CircularProgressIndicator()),
            SearchLoaded(results: []) => const Center(
              child: Text(CoreStrings.noSearchResults),
            ),
            SearchLoaded(:final results) => ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _SearchResultTile(movie: results[index]),
            ),
            SearchError(:final message) => Center(child: Text(message)),
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: CoreStrings.searchHint,
        border: InputBorder.none,
      ),
      onSubmitted: (query) =>
          context.read<SearchBloc>().add(SearchSubmitted(query)),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Movie movie;

  const _SearchResultTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    final year = movie.releaseDate?.year;
    return ListTile(
      leading: MoviePoster(
        posterPath: movie.posterPath,
        height: 75,
        width: 50,
        borderRadius: BorderRadius.circular(4),
      ),
      title: Text(movie.title),
      subtitle: year == null ? null : Text('$year'),
      trailing: RatingBadge(voteAverage: movie.voteAverage),
      onTap: () => MovieDetailPage.open(context, movie),
    );
  }
}