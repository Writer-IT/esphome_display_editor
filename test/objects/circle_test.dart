import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/circle.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../expect_helpers.dart';

void main() {
  group('Testing parsed from display for Circle', () {
    test('Testing parsing from display object with 3 variables', () {
      // Arrange
      final expectedVariables = ['20', '35', 40.0];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.circle,
        expectedVariables,
        false,
      );
      final expectedPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke;

      // Act
      final circle = Circle.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(
        circle.center,
        Offset(
          double.parse(expectedVariables[0] as String),
          double.parse(expectedVariables[1] as String),
        ),
      );
      expect(circle.radius, expectedVariables[2] as double);
      expectPaints(circle.paint, expectedPaint);
    });
    test('Testing parsing from display object with 4 variables', () {
      // Arrange
      final expectedVariables = ['43', '200', 10.04, Colors.red];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.circle,
        expectedVariables,
        false,
      );
      final expectedPaint = Paint()
        ..color = expectedVariables[3] as Color
        ..style = PaintingStyle.stroke;

      // Act
      final circle = Circle.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(
        circle.center,
        Offset(
          double.parse(expectedVariables[0] as String),
          double.parse(expectedVariables[1] as String),
        ),
      );
      expect(circle.radius, expectedVariables[2] as double);
      expectPaints(circle.paint, expectedPaint);
    });
    test('Testing parsing from display object with too many variables', () {
      // Arrange
      final expectedVariables = ['43', '200', 10.04, Colors.red, 'extra'];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.circle,
        expectedVariables,
        false,
      );

      // Act & Assert
      expect(
        () => Circle.fromParsedDisplayObject(parsedDisplayObject, {}),
        throwsA(isA<FormatException>()),
      );
    });
    test('Testing parsing from display object with too few variables', () {
      // Arrange
      final expectedVariables = ['43', '200'];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.circle,
        expectedVariables,
        false,
      );

      // Act & Assert
      expect(
        () => Circle.fromParsedDisplayObject(parsedDisplayObject, {}),
        throwsA(isA<FormatException>()),
      );
    });
    test('Testing parsing from display object with 4 variables and with filled',
        () {
      // Arrange
      final expectedVariables = ['43', '200', 10.04, Colors.red];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.circle,
        expectedVariables,
        true,
      );
      final expectedPaint = Paint()
        ..color = expectedVariables[3] as Color
        ..style = PaintingStyle.fill;

      // Act
      final circle = Circle.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(
        circle.center,
        Offset(
          double.parse(expectedVariables[0] as String),
          double.parse(expectedVariables[1] as String),
        ),
      );
      expect(circle.radius, expectedVariables[2] as double);
      expectPaints(circle.paint, expectedPaint);
    });
  });
}
