import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(CoreStrings.movieAndSeries)),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) => switch (state) {
          MovieLoading() => const Center(child: CircularProgressIndicator()),
          MovieLoaded() => _buildContent(context, state),
          MovieError(:final message) => Center(child: Text(message)),
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieLoaded state) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 5, top: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(CoreStrings.popularMoviesSection,
                  leftPadding: 14),
              _buildMovieList(context, state.popularMovies),
              _buildSectionTitle(CoreStrings.freeToWatchSection,
                  leftPadding: 10, bottomPadding: 10),
              _buildMovieList(context, state.freeToWatchMovies),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    double leftPadding = 0,
    double bottomPadding = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: bottomPadding),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildMovieList(BuildContext context, List<Movie> movies) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CardMovieWidget(
              movie: movie,
              onTap: () => _navigateToDetail(context, movie),
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }
}
