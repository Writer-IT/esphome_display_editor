import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/utils/parsing_helpers.dart';
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
    Map<String, Object> variableToObjectMapping,
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
          parseNumValue(
            valueObject: variables[0],
            variableToValueMapping: variableToObjectMapping,
          ),
          parseNumValue(
            valueObject: variables[1],
            variableToValueMapping: variableToObjectMapping,
          ),
        );
        p2 = Offset(
          parseNumValue(
            valueObject: variables[2],
            variableToValueMapping: variableToObjectMapping,
          ),
          parseNumValue(
            valueObject: variables[3],
            variableToValueMapping: variableToObjectMapping,
          ),
        );
      }
      var color = Colors.black;
      if (variables.length == 5) {
        color = variables[4] as Color;
      }
      paint = Paint()
        ..color = color
        ..style = parsedDisplayObject.filled
            ? PaintingStyle.fill
            : PaintingStyle.stroke;
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
