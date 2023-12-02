import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_app/core/service/weather_client.dart';
import 'package:weather_app/core/service/models/location.dart';

class MockDioClient extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('Api client', () {
    late Dio dio;
    late WeatherClient apiClient;

    setUp(() {
      dio = MockDioClient();
      apiClient = WeatherClient(dio: dio);
    });

    group('constructor', () {
      test('does not require an dio', () {
        expect(WeatherClient(), isNotNull);
      });
    });

    group('locationSearch', () {
      const query = 'mock-query';
      test('makes correct http request', () async {
        final response = MockResponse();

        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn('[]');
        when(() => dio.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.locationSearch(query);
        } catch (_) {}
        verify(
          () => dio.get('https://www.metaweather.com/api/location/search',
              queryParameters: <String, String>{'query': query}),
        ).called(1);
      });

      test('throws LocationIdRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => dio.get(any())).thenAnswer((_) async => response);
        expect(
          () async => await apiClient.locationSearch(query),
          throwsA(isA<LocationIdRequestFailure>()),
        );
      });

      test('throws LocationNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn('[]');
        when(() => dio.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.locationSearch(query),
          throwsA(isA<LocationIdRequestFailure>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(
          '''{
  "results": [
    {
      "id": 4887398,
      "name": "Chicago",
      "latitude": 41.85003,
      "longitude": -87.65005
    }
  ]
}''',
        );
        when(() => dio.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.locationSearch(query);
        expect(
          actual,
          isA<Location>()
              .having((l) => l.name, 'name', 'Chicago')
              .having((l) => l.id, 'id', 4887398)
              .having((l) => l.latitude, 'latitude', 41.85003)
              .having((l) => l.longitude, 'longitude', -87.65005),
        );
      });
    });
  });
}
