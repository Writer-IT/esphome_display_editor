import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

/// Parses the [input] and returns a mapping from variable to [Color]
Map<String, Color> parseColorVariables(YamlMap input) {
  final variableToColorMapping = <String, Color>{};
  if (input.containsKey('color')) {
    final colorSection = input['color'] as YamlList;
    for (final (colorYaml as YamlMap) in colorSection) {
      Color? color;
      if (colorYaml.containsKey('hex')) {
        final colorHex = (colorYaml['hex'] as String).trim();
        color = Color(int.parse('0xff$colorHex'));
      } else if (colorYaml.containsKey('red') &&
          colorYaml.containsKey('green') &&
          colorYaml.containsKey('blue')) {
        final red = int.parse(
          (colorYaml['red'] as String).replaceFirst('%', '').trim(),
        );
        final green = int.parse(
          (colorYaml['green'] as String).replaceFirst('%', '').trim(),
        );
        final blue = int.parse(
          (colorYaml['blue'] as String).replaceFirst('%', '').trim(),
        );

        color = Color.fromRGBO(
          (red / 100 * 255).round(),
          (green / 100 * 255).round(),
          (blue / 100 * 255).round(),
          1,
        );
      } else if (colorYaml.containsKey('red_int') &&
          colorYaml.containsKey('green_int') &&
          colorYaml.containsKey('blue_int')) {
        final red = colorYaml['red_int'] as int;
        final green = colorYaml['green_int'] as int;
        final blue = colorYaml['blue_int'] as int;

        color = Color.fromRGBO(red, green, blue, 1);
      }
      if (color != null && colorYaml.containsKey('id')) {
        final idString = (colorYaml['id'] as String).trim();
        variableToColorMapping['id($idString)'] = color;
      }
    }
  }

  return variableToColorMapping;
}
