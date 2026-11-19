import 'package:clean_movie_app/data/models/json_fields.dart';
import 'package:clean_movie_app/data/models/movie_json.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';

MovieDetails movieDetailsFromJson(
  Object? json, {
  required String region,
  required int maxCastMembers,
}) {
  if (json
      case {
            'genres': final List<Object?> genres,
            'credits': {'cast': final List<Object?> cast},
            'videos': {'results': final List<Object?> videos},
            'watch/providers': {
              'results': final Map<Object?, Object?> providersByRegion,
            },
            'recommendations': {'results': final List<Object?> recommendations},
          } &&
          final Map<Object?, Object?> fields) {
    return MovieDetails(
      movie: movieFromJson(json),
      runtime: _runtimeFromJson(fields['runtime']),
      genres: genres.map(_genreFromJson).toList(),
      tagline: optionalString(fields, 'tagline'),
      cast: cast.take(maxCastMembers).map(_castMemberFromJson).toList(),
      trailerYoutubeKey: _trailerYoutubeKey(videos),
      watchProviders: _watchProvidersFromJson(providersByRegion[region]),
      recommendations: recommendations.map(movieFromJson).toList(),
    );
  }
  throw FormatException('Detalhes do filme em formato inesperado', json);
}

Duration? _runtimeFromJson(Object? json) {
  return switch (json) {
    final int minutes when minutes > 0 => Duration(minutes: minutes),
    null || int() => null,
    _ => throw FormatException('Duração inválida', json),
  };
}

String _genreFromJson(Object? json) {
  return switch (json) {
    {'name': final String name} => name,
    _ => throw FormatException('Gênero inválido', json),
  };
}

CastMember _castMemberFromJson(Object? json) {
  if (json
      case {'name': final String name} && final Map<Object?, Object?> fields) {
    return CastMember(
      name: name,
      character: optionalString(fields, 'character'),
      profilePath: optionalString(fields, 'profile_path'),
    );
  }
  throw FormatException('Membro do elenco inválido', json);
}

String? _trailerYoutubeKey(List<Object?> videos) {
  final trailers = [
    for (final video in videos)
      if (video case {
        'site': 'YouTube',
        'type': 'Trailer',
        'key': final String key,
        'official': final bool official,
      })
        (key: key, official: official),
  ];
  if (trailers.isEmpty) return null;
  return trailers
      .firstWhere((trailer) => trailer.official, orElse: () => trailers.first)
      .key;
}

WatchProviders? _watchProvidersFromJson(Object? json) {
  if (json == null) return null;
  if (json
      case {'link': final String link} && final Map<Object?, Object?> fields) {
    return WatchProviders(
      link: Uri.parse(link),
      streaming: _providersFromJson(fields['flatrate']),
      free: [
        ..._providersFromJson(fields['free']),
        ..._providersFromJson(fields['ads']),
      ],
      rent: _providersFromJson(fields['rent']),
      buy: _providersFromJson(fields['buy']),
    );
  }
  throw FormatException('Provedores em formato inesperado', json);
}

List<WatchProvider> _providersFromJson(Object? json) {
  return switch (json) {
    null => const [],
    final List<Object?> items => items.map(_providerFromJson).toList(),
    _ => throw FormatException('Lista de provedores inválida', json),
  };
}

WatchProvider _providerFromJson(Object? json) {
  return switch (json) {
    {'provider_name': final String name, 'logo_path': final String logoPath} =>
      WatchProvider(name: name, logoPath: logoPath),
    _ => throw FormatException('Provedor inválido', json),
  };
}