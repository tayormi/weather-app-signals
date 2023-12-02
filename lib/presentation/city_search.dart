import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CitySearchScreen extends HookWidget {
  const CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('City Search Screen'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Enter City',
                  hintText: 'Lagos',
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('searchPage_search_iconButton'),
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).pop(textController.text),
          )
        ],
      ),
    );
  }
}
