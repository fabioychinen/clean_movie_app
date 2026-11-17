import 'package:clean_movie_app/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromEnvironment falha alto quando TMDB_API_KEY não foi definida', () {
    // `flutter test` roda sem --dart-define, então as variáveis estão vazias.
    expect(
      AppConfig.fromEnvironment,
      throwsA(isA<StateError>().having(
        (e) => e.message,
        'message',
        contains('TMDB_API_KEY'),
      )),
    );
  });
}
