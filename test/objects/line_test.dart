import 'dart:ffi';

import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/objects/line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../expect_helpers.dart';

void main() {
  group('Testing parsed from display for Line', () {
    test('Testing parsing from display object with 4 variables', () {
      // Arrange
      final expectedVariables = [30.3, 25.2, 200.0, 240.23];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.line,
        expectedVariables,
        false,
      );
      final expectedPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke;

      // Act
      final line = Line.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(line.p1, Offset(expectedVariables[0], expectedVariables[1]));
      expect(line.p2, Offset(expectedVariables[2], expectedVariables[3]));
      expectPaints(line.paint, expectedPaint);
    });
    test('Testing parsing from display object with 5 variables', () {
      // Arrange
      final expectedVariables = [0.3, 5.2, 308.8, 29.23, Colors.green];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.line,
        expectedVariables,
        false,
      );
      final expectedPaint = Paint()
        ..color = expectedVariables[4] as Color
        ..style = PaintingStyle.stroke;

      // Act
      final line = Line.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(
        line.p1,
        Offset(
          expectedVariables[0] as double,
          expectedVariables[1] as double,
        ),
      );
      expect(
        line.p2,
        Offset(
          expectedVariables[2] as double,
          expectedVariables[3] as double,
        ),
      );
      expectPaints(line.paint, expectedPaint);
    });
    test('Testing parsing from display object with 5 variables and filled', () {
      // Arrange
      final expectedVariables = [50.2, 3.4, 20.34, 30.97, Colors.yellow];
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.line,
        expectedVariables,
        true,
      );
      final expectedPaint = Paint()
        ..color = expectedVariables[4] as Color
        ..style = PaintingStyle.fill;

      // Act
      final line = Line.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(
        line.p1,
        Offset(
          expectedVariables[0] as double,
          expectedVariables[1] as double,
        ),
      );
      expect(
        line.p2,
        Offset(
          expectedVariables[2] as double,
          expectedVariables[3] as double,
        ),
      );
      expectPaints(line.paint, expectedPaint);
    });
  });
}
