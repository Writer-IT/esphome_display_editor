import 'package:esphome_display_editor/interpreter/font_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Testing parseFontVariables method', () {
    test('Check with a single font', () {
      // Arrange
      const name = 'roboto';
      const size = 20.0;
      final expected = {name: const TextStyle(fontSize: size)};
      final exampleYaml = loadYaml('''
            font:
              - file: "fonts/Roboto-Regular.ttf"
                id: $name
                size: ${size.toInt()}
                    ''') as YamlMap;

      // Act
      final result = parseFontVariables(exampleYaml);

      // Assert
      expect(result, expected);
    });

    test('Check with a no font', () {
      // Arrange
      final expected = <String, TextStyle>{};
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
                    ''') as YamlMap;

      // Act
      final result = parseFontVariables(exampleYaml);

      // Assert
      expect(result, expected);
    });

    test('Check with a two fonts', () {
      // Arrange
      const name = 'roboto';
      const size = 20.0;
      const name1 = 'jetbrains-mono';
      const size1 = 10.0;
      final expected = {
        name: const TextStyle(fontSize: size),
        name1: const TextStyle(fontSize: size1),
      };
      final exampleYaml = loadYaml('''
            font:
              - file: "fonts/Roboto-Regular.ttf"
                id: $name
                size: ${size.toInt()}
              - file: "fonts/Jetbrains-Mono.ttf"
                id: $name1
                size: ${size1.toInt()}
                    ''') as YamlMap;

      // Act
      final result = parseFontVariables(exampleYaml);

      // Assert
      expect(result, expected);
    });
  });
}
