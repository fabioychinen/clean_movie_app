import 'package:clean_movie_app/config/app_config.dart';
import 'package:clean_movie_app/domain/entities/movie.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/domain/entities/movie_page.dart';

const testConfig = AppConfig(
  tmdbApiKey: 'test-key',
  tmdbBaseUrl: 'https://api.test/3',
);

final inception = Movie(
  id: const MovieId(27205),
  title: 'Inception',
  voteAverage: 8.8,
  posterPath: '/inception.jpg',
  backdropPath: '/inception_bg.jpg',
  releaseDate: DateTime(2010, 7, 16),
  overview: 'A mind-bending thriller.',
);

const sparseMovie = Movie(id: MovieId(1), title: 'Sem Dados', voteAverage: 3.5);

final inceptionDetails = MovieDetails(
  movie: inception,
  runtime: const Duration(minutes: 148),
  genres: const ['Ação', 'Ficção científica'],
  tagline: 'Sua mente é a cena do crime.',
  cast: const [
    CastMember(
      name: 'Leonardo DiCaprio',
      character: 'Dom Cobb',
      profilePath: '/leo.jpg',
    ),
  ],
  trailerYoutubeKey: 'official-key',
  watchProviders: WatchProviders(
    link: Uri.parse('https://www.themoviedb.org/movie/27205/watch?locale=BR'),
    streaming: const [WatchProvider(name: 'Max', logoPath: '/max.png')],
    rent: const [WatchProvider(name: 'Apple TV', logoPath: '/apple.png')],
  ),
  recommendations: const [sparseMovie],
);

Map<String, Object?> tmdbMovieJson({
  int id = 27205,
  String title = 'Inception',
  num voteAverage = 8.8,
  String? posterPath = '/inception.jpg',
  String? backdropPath = '/inception_bg.jpg',
  String? releaseDate = '2010-07-16',
  String? overview = 'A mind-bending thriller.',
}) {
  return {
    'id': id,
    'title': title,
    'vote_average': voteAverage,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'release_date': releaseDate,
    'overview': overview,
  };
}

Map<String, Object?> tmdbMoviePageJson({
  required List<Object?> results,
  int page = 1,
  int totalPages = 3,
}) {
  return {'page': page, 'total_pages': totalPages, 'results': results};
}

MoviePage moviePage(List<Movie> movies, {int page = 1, int totalPages = 3}) {
  return MoviePage(movies: movies, page: page, totalPages: totalPages);
}

Map<String, Object?> tmdbMovieDetailsJson({
  Object? runtime = 148,
  List<Object?>? cast,
  List<Object?>? videos,
  Map<String, Object?>? providersByRegion,
}) {
  return {
    ...tmdbMovieJson(),
    'runtime': runtime,
    'tagline': 'Sua mente é a cena do crime.',
    'genres': [
      {'id': 28, 'name': 'Ação'},
      {'id': 878, 'name': 'Ficção científica'},
    ],
    'credits': {
      'cast':
          cast ??
          [
            {
              'name': 'Leonardo DiCaprio',
              'character': 'Dom Cobb',
              'profile_path': '/leo.jpg',
            },
          ],
    },
    'videos': {
      'results':
          videos ??
          [
            {
              'site': 'YouTube',
              'type': 'Trailer',
              'key': 'fan-key',
              'official': false,
            },
            {
              'site': 'YouTube',
              'type': 'Trailer',
              'key': 'official-key',
              'official': true,
            },
          ],
    },
    'watch/providers': {
      'results':
          providersByRegion ??
          {
            'BR': {
              'link': 'https://www.themoviedb.org/movie/27205/watch?locale=BR',
              'flatrate': [
                {'provider_name': 'Max', 'logo_path': '/max.png'},
              ],
              'rent': [
                {'provider_name': 'Apple TV', 'logo_path': '/apple.png'},
              ],
            },
          },
    },
    'recommendations': {
      'results': [
        tmdbMovieJson(
          id: 1,
          title: 'Sem Dados',
          voteAverage: 3.5,
          posterPath: null,
          backdropPath: null,
          releaseDate: null,
          overview: null,
        ),
      ],
    },
  };
}