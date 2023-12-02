import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals/signals_flutter.dart';
import 'package:weather_app/presentation/city_search.dart';
import 'package:weather_app/presentation/stores/weather_state.dart';
import 'package:weather_app/presentation/stores/weather_store.dart';
import 'package:weather_app/presentation/ui/setting_screen.dart';
import 'package:weather_app/presentation/ui/widgets/weather_available.dart';

import 'widgets/weather_empty.dart';
import 'widgets/weather_error.dart';
import 'widgets/weather_loading.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final xCity = useState('');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Weather'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                  child: const Icon(Icons.settings)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                  onTap: () async {
                    final city = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CitySearchScreen()));
                    xCity.value = city;
                    weatherStore.fetchWeather(xCity.value);
                  },
                  child: const Icon(Icons.search)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () async {
            final city = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CitySearchScreen()));
            xCity.value = city;
            weatherStore.fetchWeather(xCity.value);
          },
        ),
        body: Center(
          child: Watch((BuildContext context) {
            final state = weatherStore.weatherState;
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                return WeatherAvailable(
                  onRefresh: () {
                    return weatherStore.refreshWeather();
                  },
                  weather: state.weather,
                  units: state.temperatureUnits,
                );
              case WeatherStatus.failure:
              default:
                return WeatherError(
                  onPressed: () {
                    weatherStore.fetchWeather(xCity.value);
                  },
                );
            }
          }),
        ));
  }
}
