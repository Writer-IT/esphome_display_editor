import 'package:yaml/yaml.dart';

/// Pass that parsers the yaml and decides what exactly we're going to do.
/// Handles variable parsing and intepreting, as well as passing this context to
/// the render object pass.
class YamlParserPass {
  YamlParserPass(this.variables);

  late List<(String, Object)> variables;


  void startParsing(String input) {
    final yaml = loadYaml(input);
    if (verifyDisplayComponent(yaml as YamlMap)) {
       

        late YamlMap display;
        final displayYaml = yaml['display'];

        if (displayYaml is YamlMap) {
            display = displayYaml;
        }
        else if (displayYaml is List) {
            display = [0] as YamlMap;
        }

        
    }
  }

  /// Check if we have a valid display component with a lambda to render.
  static bool verifyDisplayComponent(YamlMap yaml) {
    if (yaml.containsKey('display')) {
      final display = yaml['display'];
      if (display is YamlMap && display.containsKey('lambda')) {
        return true;
      }
      else if (display is List && display.isNotEmpty) {
          final firstDisplay = display[0];
          if (firstDisplay is YamlMap && firstDisplay.containsKey('lambda')) {
              return true;
          }
      }
    }
    return false;
  }
}
