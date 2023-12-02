import 'package:signals/signals_flutter.dart';
import 'package:weather_app/core/repository/weather_repository.dart';
import 'package:weather_app/presentation/models/weather.dart';
import 'package:weather_app/presentation/stores/weather_state.dart';

final weatherStore = WeatherStore(weatherRepository: WeatherRepository());

class WeatherStore {
  final WeatherRepository _weatherRepository;

  WeatherStore({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository;

  final Signal<WeatherState> _weatherState = signal(WeatherState());

  WeatherState get weatherState => _weatherState.value;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    _weatherState.value = _weatherState.value.copyWith(
      status: WeatherStatus.loading,
    );

    try {
      final weather =
          Weather.fromRepository(await _weatherRepository.getWeather(city));

      final units = _weatherState.value.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value
          : weather.temperature.value;

      _weatherState.value = _weatherState.value.copyWith(
        weather: weather.copyWith(
          temperature: Temperature(value: value),
        ),
        status: WeatherStatus.success,
        temperatureUnits: units,
      );
    } on Exception catch (e) {
      _weatherState.value = _weatherState.value.copyWith(
        status: WeatherStatus.failure,
      );
    }
  }

  Future<void> refreshWeather() async {
    if (!weatherState.status.isSuccess) return;
    if (weatherState.weather == Weather.empty) return;
    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(weatherState.weather.location),
      );
      final units = weatherState.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      _weatherState.value = _weatherState.value.copyWith(
        weather: weather.copyWith(
          temperature: Temperature(value: value),
        ),
        status: WeatherStatus.success,
        temperatureUnits: units,
      );
    } on Exception {
      _weatherState.value = _weatherState.value;
    }
  }

  void toggleTemperatureUnits() {
    final units = _weatherState.value.temperatureUnits;
    final value = units.isFahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;

    if (!weatherState.status.isSuccess) {
      _weatherState.value = _weatherState.value.copyWith(
        temperatureUnits: value,
      );
      return;
    }

    final weather = _weatherState.value.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value = units.isCelsius
          ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();

      _weatherState.value = _weatherState.value.copyWith(
        weather: weather.copyWith(
          temperature: Temperature(value: value),
        ),
        temperatureUnits: units,
      );
    }
  }
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
