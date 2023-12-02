import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:weather_app/presentation/models/weather.dart';
import 'package:weather_app/presentation/stores/weather_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Watch((context) {
        return ListTile(
          title: const Text('Temperature Units'),
          isThreeLine: true,
          subtitle: const Text(
            'Use metric measurements for temperature units.',
          ),
          trailing: Switch(
            value: weatherStore.weatherState.temperatureUnits.isCelsius,
            onChanged: (_) => weatherStore.toggleTemperatureUnits(),
          ),
        );
      }),
    );
  }
}
