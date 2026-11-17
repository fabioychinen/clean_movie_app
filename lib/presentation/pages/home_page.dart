import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie_list_type.dart';
import 'package:clean_movie_app/presentation/bloc/home/home_bloc.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/pages/search_page.dart';
import 'package:clean_movie_app/presentation/widgets/movie_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CoreStrings.movieAndSeries),
        actions: [
          IconButton(
            tooltip: CoreStrings.search,
            icon: const Icon(Icons.search),
            onPressed: () => SearchPage.open(context),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => switch (state) {
          HomeLoading() => const Center(child: CircularProgressIndicator()),
          HomeLoaded() => _buildSections(context, state),
          HomeError(:final message) => Center(child: Text(message)),
        },
      ),
    );
  }

  Widget _buildSections(BuildContext context, HomeLoaded state) {
    final sections = [
      for (final type in MovieListType.values)
        if (state.sections[type] case final movies? when movies.isNotEmpty)
          (type, movies),
    ];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final (type, movies) = sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                _titleFor(type),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            MovieCarousel(
              movies: movies,
              onMovieTap: (movie) => MovieDetailPage.open(context, movie),
            ),
          ],
        );
      },
    );
  }

  String _titleFor(MovieListType type) {
    return switch (type) {
      MovieListType.trending => CoreStrings.trendingSection,
      MovieListType.popular => CoreStrings.popularMoviesSection,
      MovieListType.freeToWatch => CoreStrings.freeToWatchSection,
      MovieListType.topRated => CoreStrings.topRatedSection,
      MovieListType.upcoming => CoreStrings.upcomingSection,
    };
  }
}