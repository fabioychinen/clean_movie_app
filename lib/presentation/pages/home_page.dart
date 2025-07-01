import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/presentation/bloc/bloc/movie_bloc.dart';
import 'package:clean_movie_app/presentation/pages/movie_detail_page.dart';
import 'package:clean_movie_app/presentation/widgets/card_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return _buildLoading();
          } else if (state is MovieLoaded) {
            return _buildContent(context, state);
          } else if (state is MovieError) {
            return _buildError(state);
          } else {
            return _buildUnknown();
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Filmes e Séries'),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent(BuildContext context, MovieLoaded state) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 5, top: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Os Mais Populares', leftPadding: 14),
              _buildMovieList(state.popularMovies, context),
              _buildSectionTitle('Grátis Para Assistir', leftPadding: 10, bottomPadding: 10),
              _buildMovieList(state.freeToWatchMovies, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double leftPadding = 0, double bottomPadding = 0}) {
    return Container(
      padding: EdgeInsets.only(left: leftPadding, bottom: bottomPadding),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies, BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          return MaterialButton(
            onPressed: () => _navigateToDetail(context, movie),
            child: CardMovieWidget(movie: movie),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  Widget _buildError(MovieError state) {
    return Center(child: Text(state.message));
  }

  Widget _buildUnknown() {
    return const Center(child: Text('Unknown state'));
  }
}