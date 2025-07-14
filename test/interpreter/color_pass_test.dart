import 'package:esphome_display_editor/interpreter/color_pass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Testing parseColorVariablse method', () {
    test('Check with hex color', () {
      // Arrange
      const name = 'test_id';
      const variableName = 'id($name)';
      const expected = 0xffff3340;
      final input = loadYaml('''
                color:
                  - id: $name
                    hex: ff3340
            ''') as YamlMap;

      // Act
      final result = parseColorVariables(input);

      // Assert
      expect(result.containsKey(variableName), true);
      expect(
        result[variableName]!.value.toRadixString(16),
        expected.toRadixString(16),
      );
    });
    test('Check with percentage colors', () {
      // Arrange
      const name = 'test_id';
      const variableName = 'id($name)';
      const expected = 0xffff0000;
      final input = loadYaml('''
                color:
                  - id: $name
                    red: 100%
                    green: 0%
                    blue: 0%
            ''') as YamlMap;
      // Act
      final result = parseColorVariables(input);

      // Assert
      expect(result.containsKey(variableName), true);
      expect(
        result[variableName]!.value.toRadixString(16),
        expected.toRadixString(16),
      );
    });
    test('Check with percentage colors as doubles', () {
      // Arrange
      const name = 'test_id';
      const variableName = 'id($name)';
      const expected = 0xffff0000;
      final input = loadYaml('''
                color:
                  - id: $name
                    red: 1.0
                    green: 0.0
                    blue: 0.0
            ''') as YamlMap;
      // Act
      final result = parseColorVariables(input);

      // Assert
      expect(result.containsKey(variableName), true);
      expect(
        result[variableName]!.value.toRadixString(16),
        expected.toRadixString(16),
      );
    });
    test('Check with colors', () {
      // Arrange
      const name = 'test_id';
      const variableName = 'id($name)';
      const expectedRed = 200;
      const expectedGreen = 144;
      const expectedBlue = 12;
      final input = loadYaml('''
                color:
                  - id: $name
                    red_int: $expectedRed
                    green_int: $expectedGreen
                    blue_int: $expectedBlue
            ''') as YamlMap;
      // Act
      final result = parseColorVariables(input);

      // Assert
      expect(result.containsKey(variableName), true);
      expect(result[variableName]!.red, expectedRed);
      expect(result[variableName]!.green, expectedGreen);
      expect(result[variableName]!.blue, expectedBlue);
    });
  });
}
