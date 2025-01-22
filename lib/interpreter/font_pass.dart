// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

/// Parses the [input] and returns a mapping from variable to [TextStyle].
Map<String, TextStyle> parseFontVariables(YamlMap input) {
  final variableToTextStyleMapping = <String, TextStyle>{};
  if (input.containsKey('font')) {
    final fontSection = input['font'] as YamlList;
    for (final font in fontSection) {
      final fontPath = (font['file'] as String).toLowerCase();
      var fontName = 'Roboto';
      for (final each in availableFonts) {
        if (fontPath.contains(each.toLowerCase())) {
          fontName = each;
          break;
        }
      }
      print('selecting font: $fontName');

      variableToTextStyleMapping['id(${font['id'] as String})'] = TextStyle(
        fontFamily: fontName,
        fontSize: (font['size'] as int).toDouble(),
      );
    }
  }
  return variableToTextStyleMapping;
}

/// List of fonts that are loaded
List<String> availableFonts = [
  'roboto',
  'jetbrains',
  'Arial',
];
