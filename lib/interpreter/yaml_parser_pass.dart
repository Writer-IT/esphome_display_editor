import 'package:esphome_display_editor/interpreter/display_object_pass.dart';
import 'package:esphome_display_editor/interpreter/display_parser_pass.dart';
import 'package:esphome_display_editor/interpreter/variable_pass.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:yaml/yaml.dart';

/// Pass that parsers the yaml and decides what exactly we're going to do.
/// Handles variable parsing and intepreting, as well as passing this context to
/// the render object pass.

/// Parses the code given in [input].
List<DisplayObject> parse(String input) {
  final yaml = loadYaml(input);
  if (verifyDisplayComponent(yaml as YamlMap)) {
    final codeLines = extractCode(yaml);

    final (variableToObjectMapping, passedCodeLines) =
        VariablePass().processDisplayCode(codeLines);

    final parsedDisplayObjects = DisplayParserPass(variableToObjectMapping)
        .parseDisplayCode(passedCodeLines);

    return DisplayObjectPass().transformObjects(
      parsedDisplayObjects,
      variableToObjectMapping,
    );
  } else {
    throw const FormatException('This was not valid yaml');
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
