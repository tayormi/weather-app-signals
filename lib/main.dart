import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/presentation/ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: FlexColorScheme.light(scheme: FlexScheme.wasabi).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.wasabi).toTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
