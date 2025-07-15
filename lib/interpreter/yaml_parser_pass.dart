import 'package:esphome_display_editor/interpreter/color_pass.dart';
import 'package:esphome_display_editor/interpreter/display_object_pass.dart';
import 'package:esphome_display_editor/interpreter/display_parser_pass.dart';
import 'package:esphome_display_editor/interpreter/font_pass.dart';
import 'package:esphome_display_editor/interpreter/sensor_pass.dart';
import 'package:esphome_display_editor/interpreter/text_sensor_pass.dart';
import 'package:esphome_display_editor/interpreter/variable_pass.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:yaml/yaml.dart';

/// Pass that parsers the yaml and decides what exactly we're going to do.
/// Handles variable parsing and intepreting, as well as passing this context to
/// the render object pass.

/// Parses the code given in [yaml] and the given [configurableVariables].
(List<DisplayObject>, List<Error>) parseDisplayObjects(
  YamlMap? yaml,
  Map<String, String> configurableVariables,
) {
  if (yaml != null && verifyDisplayComponent(yaml)) {
    final codeLines = extractCode(yaml);

    final variableToTextStyleMapping = parseFontVariables(yaml);
    final variableToColorMapping = parseColorVariables(yaml);

    // Extract variables from code
    final (variableToObjectMapping, passedCodeLines) =
        VariablePass().processDisplayCode(codeLines);

    final parsedDisplayObjects = DisplayParserPass(
      {
        ...variableToObjectMapping,
        ...variableToTextStyleMapping,
        ...variableToColorMapping,
        ...configurableVariables,
      },
    ).parseDisplayCode(passedCodeLines);

    return DisplayObjectPass().transformObjects(
      parsedDisplayObjects,
      variableToObjectMapping,
    );
  } else {
    throw const FormatException('This was not valid yaml');
  }
}

/// Parses variables from the yaml map that can be configured by the user.
Map<String, String> parseConfigurableVariables(YamlMap yaml) {
  final variableToSensor = parseSensors(yaml);
  final variableToTextSensor = parseTextSensors(yaml);

  final result = <String, String>{}
    ..addAll(variableToSensor)
    ..addAll(variableToTextSensor);

  return result;
}

/// Parses the given [input] into a [YamlMap]
YamlMap? parseYamlFromString(String? input) {
  if (input != null && input.trim() != '') {
    final cleanedInput = input.replaceAll('!secret', '');
    return loadYaml(cleanedInput, recover: true) as YamlMap;
  } else {
    return null;
  }
}

/// Check if we have a valid display component with a lambda to render.
bool verifyDisplayComponent(YamlMap yaml) {
  if (yaml.containsKey('display')) {
    final display = yaml['display'];
    if (display is YamlMap && display.containsKey('lambda')) {
      return true;
    } else if (display is List && display.isNotEmpty) {
      final firstDisplay = display[0];
      if (firstDisplay is YamlMap && firstDisplay.containsKey('lambda')) {
        return true;
      }
    }
  }
  return false;
}

/// Extract the code section for the display, and returns them as codelines.
List<String> extractCode(YamlMap yaml) {
  late YamlMap display;
  final displayYaml = yaml['display'];
  if (displayYaml is YamlMap) {
    display = displayYaml;
  } else if (displayYaml is List) {
    display = displayYaml[0] as YamlMap;
  }
  return (display['lambda'] as String).split('\n');
}
