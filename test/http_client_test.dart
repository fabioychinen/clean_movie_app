import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:clean_movie_app/config/env.dart';

class MockHttpClient extends Mock implements http.Client {}

String get fetchPopular => "${Env.baseUrl}/movie/popular?api_key=${Env.apiKey}";

void main() {
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
  });

  test('Exemplo de teste com solicitação HTTP mockada', () async {
    when(() => mockClient.get(Uri.parse(fetchPopular)))
        .thenAnswer((_) async => http.Response('{"key": "value"}', 200));

    final response = await mockClient.get(Uri.parse(fetchPopular));
    expect(response.statusCode, 200);
    expect(response.body, '{"key": "value"}');
  });
}