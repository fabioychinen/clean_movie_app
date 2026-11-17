import 'package:clean_movie_app/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromEnvironment falha alto quando a chave da API não foi definida', () {
    expect(
      AppConfig.fromEnvironment,
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('TMDB_API_KEY'),
        ),
      ),
    );
  });
}