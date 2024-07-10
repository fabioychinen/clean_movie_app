import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class CardMovieWidget extends StatelessWidget {
  final Movie movie;

  const CardMovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double voteAverage = movie.voteAverage ?? 0;

    return Container(
      padding: const EdgeInsets.all(7),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        focusColor: const Color.fromARGB(24, 158, 158, 158),
        highlightColor: const Color.fromARGB(24, 158, 158, 158),
        onTap: () {},
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: voteAverage / 10,
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getVoteColor(voteAverage),
                            ),
                          ),
                        ),
                        Text(
                          '${(voteAverage * 10).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                movie.title ?? 'Título não disponível',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getVoteColor(double vote) {
    if (vote >= 7.0) {
      return Colors.green;
    } else if (vote >= 4.0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
