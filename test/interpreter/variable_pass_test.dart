import 'package:esphome_display_editor/interpreter/variable_pass.dart';
import 'package:esphome_display_editor/interpreter/variable_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late VariablePass variablePass;
  setUp(() {
    variablePass = VariablePass();
  });

  group('Testing the extractNameAndValueString method', () {
    test('Give a valid variable assignment string', () {
      // Arrange
      const testCodeLine = 'auto color = Color(23, 244, 231);';
      const expected = ('color', ' Color(23, 244, 231);');

      // Act
      final result = variablePass.extractNameAndValueString(testCodeLine);

      // Assert
      expect(result, expected);
    });
    test('Give a valid variable reassignment string', () {
      // Arrange
      const testCodeLine = "color = 'pink';";
      const expected = ('color', " 'pink';");

      // Act
      final result = variablePass.extractNameAndValueString(testCodeLine);

      // Assert
      expect(result, expected);
    });
  });

  group('Testing the storeVariable method', () {
    test('Give a valid Color assignment string', () {
      // Arrange
      const testCodeLine = 'auto color = Color(3, 4, 1);';
      final (name, _) = variablePass.extractNameAndValueString(testCodeLine);
      final expectedTempName = '${VariablePass.variableSignature}$name'
          '${variablePass.variableCounter}';
      const expectedObject = Color.fromRGBO(3, 4, 1, 1);

      // Act
      variablePass.storeVariable(
        variableType: VariableTypes.color,
        codeLine: testCodeLine,
      );

      // Assert
      expect(variablePass.variableNameMapping[name], expectedTempName);
      expect(
        variablePass.variableValueMapping[expectedTempName],
        expectedObject,
      );
    });

    test('Give a valid Color assignment string twice!', () {
      // Arrange
      const testCodeLine = 'auto color_black = Color(255, 255, 255);';
      final (name, _) = variablePass.extractNameAndValueString(testCodeLine);
      final expectedTempName = '${VariablePass.variableSignature}${name}0';
      const expectedObject = Color.fromRGBO(255, 255, 255, 1);

      const testCodeLine2 = 'auto color_potato = Color(5, 100, 4);';
      final (name2, _) = variablePass.extractNameAndValueString(testCodeLine2);
      final expectedTempName2 = '${VariablePass.variableSignature}${name2}1';
      const expectedObject2 = Color.fromRGBO(5, 100, 4, 1);

      // Act
      variablePass.storeVariable(
        variableType: VariableTypes.color,
        codeLine: testCodeLine,
      );
      // ignore: cascade_invocations
      variablePass.storeVariable(
        variableType: VariableTypes.color,
        codeLine: testCodeLine2,
      );

      // Assert
      expect(variablePass.variableNameMapping[name], expectedTempName);
      expect(variablePass.variableNameMapping[name2], expectedTempName2);
      expect(
        variablePass.variableValueMapping[expectedTempName],
        expectedObject,
      );
      expect(
        variablePass.variableValueMapping[expectedTempName2],
        expectedObject2,
      );
    });

    test('Give a valid int assignment string', () {
      // Arrange
      const testCodeLine = 'int five = 5;';
      final (name, _) = variablePass.extractNameAndValueString(testCodeLine);
      final expectedTempName = '${VariablePass.variableSignature}$name'
          '${variablePass.variableCounter}';
      const expectedObject = 5;

      // Act
      variablePass.storeVariable(
        variableType: VariableTypes.int,
        codeLine: testCodeLine,
      );

      // Assert
      expect(variablePass.variableNameMapping[name], expectedTempName);
      expect(
        variablePass.variableValueMapping[expectedTempName],
        expectedObject,
      );
    });

    test('Give a valid double assignment string', () {
      // Arrange
      const testCodeLine = 'double twentydotfive = 20.5;';
      final (name, _) = variablePass.extractNameAndValueString(testCodeLine);
      final expectedTempName = '${VariablePass.variableSignature}$name'
          '${variablePass.variableCounter}';
      const expectedObject = 20.5;

      // Act
      variablePass.storeVariable(
        variableType: VariableTypes.double,
        codeLine: testCodeLine,
      );

      // Assert
      expect(variablePass.variableNameMapping[name], expectedTempName);
      expect(
        variablePass.variableValueMapping[expectedTempName],
        expectedObject,
      );
    });

    test('Give a valid String assignment string', () {
      // Arrange
      const testCodeLine = 'std::string SomeText = "Hello there";';
      final (name, _) = variablePass.extractNameAndValueString(testCodeLine);
      final expectedTempName = '${VariablePass.variableSignature}$name'
          '${variablePass.variableCounter}';
      const expectedObject = 'Hello there';

      // Act
      variablePass.storeVariable(
        variableType: VariableTypes.string,
        codeLine: testCodeLine,
      );

      // Assert
      expect(variablePass.variableNameMapping[name], expectedTempName);
      expect(
        variablePass.variableValueMapping[expectedTempName],
        expectedObject,
      );
    });
  });
}
