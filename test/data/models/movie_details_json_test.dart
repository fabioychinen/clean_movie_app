import 'package:clean_movie_app/data/models/movie_details_json.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  MovieDetails parse(Map<String, Object?> json, {int maxCastMembers = 15}) {
    return movieDetailsFromJson(
      json,
      region: 'BR',
      maxCastMembers: maxCastMembers,
    );
  }

  test('converte a resposta completa da TMDB', () {
    expect(parse(tmdbMovieDetailsJson()), inceptionDetails);
  });

  test('prefere o trailer oficial do YouTube', () {
    final details = parse(
      tmdbMovieDetailsJson(
        videos: [
          {'site': 'Vimeo', 'type': 'Trailer', 'key': 'v', 'official': true},
          {'site': 'YouTube', 'type': 'Clip', 'key': 'c', 'official': true},
          {'site': 'YouTube', 'type': 'Trailer', 'key': 'f', 'official': false},
        ],
      ),
    );

    expect(details.trailerYoutubeKey, 'f');
  });

  test('sem trailer do YouTube, a chave é nula', () {
    expect(parse(tmdbMovieDetailsJson(videos: [])).trailerYoutubeKey, isNull);
  });

  test('sem dados para o Brasil, os provedores são nulos', () {
    final details = parse(
      tmdbMovieDetailsJson(
        providersByRegion: {
          'US': {'link': 'https://example.com'},
        },
      ),
    );

    expect(details.watchProviders, isNull);
  });

  test('junta provedores grátis e com anúncios', () {
    final details = parse(
      tmdbMovieDetailsJson(
        providersByRegion: {
          'BR': {
            'link': 'https://example.com',
            'free': [
              {'provider_name': 'Pluto', 'logo_path': '/pluto.png'},
            ],
            'ads': [
              {'provider_name': 'Tubi', 'logo_path': '/tubi.png'},
            ],
          },
        },
      ),
    );

    expect(details.watchProviders!.free.map((p) => p.name), ['Pluto', 'Tubi']);
  });

  test('limita o elenco', () {
    final cast = [
      for (var i = 0; i < 30; i++) {'name': 'Ator $i'},
    ];

    final details = parse(
      tmdbMovieDetailsJson(cast: cast),
      maxCastMembers: 15,
    );

    expect(details.cast, hasLength(15));
  });

  test('duração 0 ou nula vira ausente', () {
    expect(parse(tmdbMovieDetailsJson(runtime: 0)).runtime, isNull);
    expect(parse(tmdbMovieDetailsJson(runtime: null)).runtime, isNull);
  });

  test('lança FormatException quando falta um bloco do append_to_response', () {
    final json = tmdbMovieDetailsJson()..remove('credits');

    expect(() => parse(json), throwsFormatException);
  });
}