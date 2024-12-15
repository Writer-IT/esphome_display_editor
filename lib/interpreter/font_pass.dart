// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

/// Parses the [input] and returns a mapping from variable to [TextStyle].
Map<String, TextStyle> parseFontVariables(YamlMap input) {
  final variableToTextStyleMapping = <String, TextStyle>{};
  if (input.containsKey('font')) {
    final fontSection = input['font'] as YamlList;
    for (final font in fontSection) {
      variableToTextStyleMapping['id(${font['id'] as String})'] =
          TextStyle(fontSize: (font['size'] as int).toDouble());
    }
  }
  return variableToTextStyleMapping;
}
