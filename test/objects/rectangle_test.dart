import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/objects/rectangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../expect_helpers.dart';

void main() {
  group('Testing parsed from display for Rectangle', () {
    test('Testing parsing from display object with 4 variables', () {
      // Arrange
      final expectedVariables = [20.1, 33.2, 44.2, 10.5];
      final expectedRect = Rect.fromLTWH(
        expectedVariables[0],
        expectedVariables[1],
        expectedVariables[2],
        expectedVariables[3],
      );
      final parsedDisplayObject = ParsedDisplayObject(
        DisplayObjectTypes.rectangle,
        expectedVariables,
        false,
      );
      final expectedPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke;

      // Act
      final rectangle =
          Rectangle.fromParsedDisplayObject(parsedDisplayObject, {});

      // Assert
      expect(rectangle.rect, expectedRect);
      expectPaints(rectangle.paint, expectedPaint);
    });
  });
}
