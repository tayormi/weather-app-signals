import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('🙈', style: TextStyle(fontSize: 64)),
        Text(
          'Something went wrong!',
          style: theme.textTheme.headlineSmall,
        ),
        ElevatedButton(onPressed: onPressed, child: const Text('Retry'))
      ],
    );
  }
}
