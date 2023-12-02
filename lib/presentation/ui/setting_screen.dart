import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:weather_app/presentation/models/weather.dart';
import 'package:weather_app/presentation/stores/weather_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final state = ref.watch(weatherNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListTile(
        title: const Text('Temperature Units'),
        trailing: Watch((context) {
          final state = weatherStore.weatherState;
          return Switch(
            value: state.temperatureUnits.isCelsius,
            onChanged: (_) {},
          );
        }),
      ),
    );
  }
}
