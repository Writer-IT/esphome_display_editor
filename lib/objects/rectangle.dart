import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:flutter/material.dart';

/// Rectangles, define a starting point and the width and height.
class Rectangle implements DisplayObject {
  /// Creates a rectangle object that can be drawn on the canvas, with start
  /// position at ([x], [y]), and with [width] and [height] respectively.
  /// Optionally you can define a [color], defaults to black, and whether or
  /// not to [fill] the rectangle, defaults to false.
  Rectangle(
    int x,
    int y,
    int width,
    int height, {
    Color color = Colors.black,
    bool fill = false,
  }) {
    rect = Rect.fromLTWH(
      x.toDouble(),
      y.toDouble(),
      width.toDouble(),
      height.toDouble(),
    );
    paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;
  }

  /// Converts an [ParsedDisplayObject] to a [Rectangle].
  Rectangle.fromParsedDisplayObject(
    ParsedDisplayObject parsedDisplayObject,
  ) {
    if (parsedDisplayObject.type == DisplayObjectTypes.rectangle) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 4 || variables.length > 5) {
        throw FormatException(
          'Circle requires 4 or 5 variables, provided: ${variables.length}',
        );
      }
      if (variables.length >= 4) {
        final x = double.parse(variables[0] as String);
        final y = double.parse(variables[1] as String);
        final width = double.parse(variables[2] as String);
        final height = double.parse(variables[3] as String);

        rect = Rect.fromLTWH(x, y, width, height);
      }
      if (variables.length == 5) {
        final color = variables[4] as Color;
        paint = Paint()..color = color;
      }
    } else {
      throw FormatException(
        'This is not a rectangle type, '
        'this is a: ${parsedDisplayObject.type}',
      );
    }
  }

  /// Rectangle object to be drawn as a canvas.
  late Rect rect;

  /// Color and fill of the rectangle.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
}
