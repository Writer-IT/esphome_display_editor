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
        final red = parseColorPercentage(colorYaml['red']);
        final green = parseColorPercentage(colorYaml['green']);
        final blue = parseColorPercentage(colorYaml['blue']);

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

/// Parses an [input] for color if it's thought to be a percentage, but can be a
/// double or a string.
// ignore: avoid_annotating_with_dynamic
int parseColorPercentage(dynamic input) {
  final doublePercentage = double.tryParse(input.toString());

  if (doublePercentage != null) {
    return (doublePercentage * 100).toInt();
  } else {
    return int.parse((input as String).replaceFirst('%', '').trim());
  }
}
