import 'package:flutter/material.dart';
import 'package:weather_app/core/repository/models/weather.dart' hide Weather;
import 'package:weather_app/presentation/models/weather.dart';

class WeatherAvailable extends StatelessWidget {
  const WeatherAvailable({
    super.key,
    required this.onRefresh,
    required this.weather,
    required this.units,
  });

  final Weather weather;
  final ValueGetter<Future<void>> onRefresh;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: OrientationBuilder(
                builder: (context, orientation) =>
                    orientation == Orientation.portrait
                        ? PortraitView(
                            units: units,
                            weather: weather,
                          )
                        : LandScapeView(
                            units: units,
                            weather: weather,
                          ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LandScapeView extends StatelessWidget {
  const LandScapeView({
    super.key,
    required this.weather,
    required this.units,
  });

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather.condition.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            weather.formattedTemperature(units),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
        ),
      ],
    );
  }
}

class PortraitView extends StatelessWidget {
  const PortraitView({
    super.key,
    required this.weather,
    required this.units,
  });

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        _WeatherIcon(condition: weather.condition),
        Text(
          weather.location,
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          weather.condition.toEmoji,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            weather.formattedTemperature(units),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.25, 0.75, 0.90, 1.0],
          colors: [
            color,
            color.brighten(10),
            color.brighten(33),
            color.brighten(50),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition});

  static const _iconSize = 75.0;

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(fontSize: _iconSize),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}
