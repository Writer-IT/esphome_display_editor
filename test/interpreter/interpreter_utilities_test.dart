import 'dart:ui';

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

    test('Check with valid code line with variables to replace', () {
      // Arrange
      const exampleCode = 'it.circle(1002, 45, 20, black);';
      const signature = 'it.circle(';
      const expectedVariableValue = Color.fromRGBO(0, 0, 0, 1);
      const variableToObjectMapping = {'black': expectedVariableValue};

      // Act
      final result = parseVariables(
        codeLine: exampleCode,
        signature: signature,
        variableToObjectMapping: variableToObjectMapping,
      );

      // Assert
      expect(result.length, 4);
      expect(result[0], '1002');
      expect(result[1], '45');
      expect(result[2], '20');
      expect(result[3], expectedVariableValue);
    });
  });

  group('Testing isVariableReassignment method', () {
    test('Test with a normal variable reassignment', () {
      // Arrange
      const exampleCode = 'color = Color(200, 233, 233);';
      final existingVariableToObjectMapping = {
        'color': const Color.fromRGBO(120, 20, 20, 1),
      };
      const expected = (true, Color);

      // Act
      final result =
          isVariableReassignment(exampleCode, existingVariableToObjectMapping);

      // Assert
      expect(result, expected);
    });

    test('Test with a uninitalized variable reassignment', () {
      // Arrange
      const exampleCode = 'color = Color(200, 233, 233);';
      final existingVariableToObjectMapping = {
        'some_color': const Color.fromRGBO(120, 20, 20, 1),
      };

      // Act & Assert
      expect(
        () => isVariableReassignment(
          exampleCode,
          existingVariableToObjectMapping,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
