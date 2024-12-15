// ignore_for_file: avoid_dynamic_calls
import 'package:yaml/yaml.dart';

/// Parses the [input] and reterns a mapping for configurable text_sensor
/// variables.
Map<String, String> parseTextSensors(YamlMap input) {
  final variableToValueMapping = <String, String>{};
  if (input.containsKey('text_sensor')) {
    final textSensorSection = input['text_sensor'] as YamlList;
    for (final textSensor in textSensorSection) {
      variableToValueMapping['id(${textSensor['id'] as String})'] =
          'Placeholder';
    }
  }

  return variableToValueMapping;
}
