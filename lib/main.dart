import 'package:esphome_display_editor/esp_home_editor.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      title: 'ESP Home Display Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EspHomeEditor(),
    ),
  );
}
