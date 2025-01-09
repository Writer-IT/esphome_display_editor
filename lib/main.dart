import 'package:esphome_display_editor/esp_home_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MaterialApp(
      title: 'ESP Home Display Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EspHomeEditor(preferences: prefs),
    ),
  );
}
