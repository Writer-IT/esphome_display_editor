import 'package:esphome_display_editor/interpreter/yaml_parser_pass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Testing verifyDisplayComponent method', () {
    test('Check with valid example with list to be true', () {
      // Arrange
      final exampleYaml = loadYaml('''
            binary_sensor:
              - platform: ...
                # ...
                id: my_binary_sensor

            color:
              - name: my_red
                red: 100%

            display:
              - platform: ...
                # ...
                lambda: |-
                  if (id(my_binary_sensor).state) {
                    it.print(0, 0, id(my_font), "state: ON");
                  } else {
                    it.print(0, 0, id(my_font), "state: OFF");
                  }
                  // Shorthand:
                  it.start_clipping(40,0,140,20);
                  it.printf(0, 0, id(my_font), id(my_red), "State: %s", id(my_binary_sensor).state ? "ON" : "OFF");
                  it.end_clipping();
                    ''');

      // Act
      final result =
          YamlParserPass.verifyDisplayComponent(exampleYaml as YamlMap);

      // Assert
      expect(result, true);
    });
  });
}
