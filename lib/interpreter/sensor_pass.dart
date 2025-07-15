// ignore_for_file: avoid_dynamic_calls
import 'package:yaml/yaml.dart';

/// Parses the [input] and reterns a mapping for configurable sensor
/// variables.
Map<String, String> parseSensors(YamlMap input) {
  final variableToValueMapping = <String, String>{};
  if (input.containsKey('sensor')) {
    final sensorSection = input['sensor'] as YamlList;
    for (final sensor in sensorSection) {
      variableToValueMapping['id(${sensor['id'] as String})'] =
          'Placeholder';
    }
  }

  return variableToValueMapping;
}
