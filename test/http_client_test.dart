import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

const String apiKey = '88efd5107320ab503dcd9aae2c475996';
const String _baseUrl = "https://api.themoviedb.org/3";
const String _key = "?api_key=$apiKey";
String get fetchPopular => "$_baseUrl/movie/popular$_key";

class MockHttpClient extends Mock implements http.Client {}

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
