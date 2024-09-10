import 'package:esphome_display_editor/interpreter/interpreter_utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('testing cleanCodeLine method', () {
    test('Check if normal code line is not changed', () {
      // Arrange
      const code = 'it.circle(20, 75, 10);';
      const expected = 'it.circle(20, 75, 10);';
      // Act
      final result = cleanCodeLine(code);

      // Assert
      expect(result, expected);
    });
    test('Check if white space is dropped correctly', () {
      // Arrange
      const code = '   it.circle(20, 75, 10);          ';
      const expected = 'it.circle(20, 75, 10);';
      // Act
      final result = cleanCodeLine(code);

      // Assert
      expect(result, expected);
    });
    test('Check if white space and comments are dropped correctly', () {
      // Arrange
      const code =
          '   it.circle(20, 75, 10);      // An amazing comment in C++    ';
      const expected = 'it.circle(20, 75, 10);';
      // Act
      final result = cleanCodeLine(code);

      // Assert
      expect(result, expected);
    });
  });
  group('Testing parseVariables method', () {
    test('Check with valid code line with variables', () {
      // Arrange
      const exampleCode = 'it.circle(20, 75, 10);';
      const signature = 'it.circle(';

      // Act
      final result =
          parseVariables(codeLine: exampleCode, signature: signature);

      // Assert
      expect(result.length, 3);
      expect(result[0], '20');
      expect(result[1], '75');
      expect(result[2], '10');
    });
  });
}
