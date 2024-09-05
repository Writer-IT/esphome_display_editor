import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:flutter/material.dart';

/// A line to be drawn.
class Line extends DisplayObject {
  /// Create a line from point 1 to point 2.
  Line(this.p1, this.p2, {Color color = Colors.black}) {
    paint = Paint()..color = color;
  }

  /// Converts an [ParsedDisplayObject] to a [Line].
  Line.fromParsedDisplayObject(
    ParsedDisplayObject parsedDisplayObject,
  ) {
    if (parsedDisplayObject.type == DisplayObjectTypes.line) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 4 || variables.length > 5) {
        throw FormatException(
          'Lines requires 4 or 5 variables, provided: ${variables.length}',
        );
      }
      if (variables.length >= 4) {
        p1 = Offset(
          double.parse(variables[0] as String),
          double.parse(variables[1] as String),
        );
        p2 = Offset(
          double.parse(variables[2] as String),
          double.parse(variables[3] as String),
        );
      }
      if (variables.length == 5) {
        final color = variables[4] as Color;
        paint = Paint()..color = color;
      }
    } else {
      throw FormatException(
        'This is not a line, this is a: ${parsedDisplayObject.type}',
      );
    }
  }

  /// Start position of the line.
  late Offset p1;

  /// End position of the line.
  late Offset p2;

  /// Paint of the line.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    canvas.drawLine(p1, p2, paint);
  }
}
