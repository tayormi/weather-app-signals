import 'package:dio/dio.dart';
import 'package:weather_app/core/service/models/weather.dart';

import 'models/location.dart';

/// Exception thrown when locationSearch fails.
class LocationIdRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

class WeatherClient {
  final Dio _dio;
  WeatherClient({Dio? dio}) : _dio = dio ?? Dio();

  /// Finds a [Location] `/v1/search/?name=(query)`.
  Future<Location> locationSearch(String query) async {
    const url = 'https://geocoding-api.open-meteo.com/v1/search';
    final queryParamater = {'name': query, 'count': '1'};
    try {
      final response = await _dio.get(url,
          queryParameters: queryParamater, options: Options());

      final locationJson = response.data as Map;

      if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

      final results = locationJson['results'] as List;

      if (results.isEmpty) {
        throw LocationNotFoundFailure();
      }

      return Location.fromJson(results.first as Map<String, dynamic>);
    } catch (e) {
      throw LocationIdRequestFailure();
    }
  }

  /// Fetches [Weather] for a given [locationId].
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    const url = 'https://api.open-meteo.com/v1/forecast';
    final queryParamaters = {
      'latitude': latitude,
      'longitude': longitude,
      'current_weather': 'true',
    };
    try {
      final response = await _dio.get(url, queryParameters: queryParamaters);

      final bodyJson = response.data as Map<String, dynamic>;

      if (bodyJson.isEmpty) {
        throw WeatherNotFoundFailure();
      }
      if (!bodyJson.containsKey('current_weather')) {
        throw WeatherNotFoundFailure();
      }

      final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;
      return Weather.fromJson(weatherJson);
    } catch (e) {
      throw WeatherRequestFailure();
    }
  }
}
