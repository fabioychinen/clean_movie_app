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
      appBar: AppBar(
        title: const Text('Filmes e Séries'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 5, top: 50),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Os Mais Populares',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      _buildMovieList(state.popularMovies, context),
                      Container(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: const Text(
                          'Grátis Para Assistir',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      _buildMovieList(state.freeToWatchMovies, context),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: movie),
                ),
              );
            },
            child: CardMovieWidget(movie: movie),
          );
        },
      ),
    );
  }
}
