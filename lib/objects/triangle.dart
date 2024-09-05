import 'dart:ui';

import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:flutter/material.dart';

/// Triangle, specific kind of vertices with only three points.
class Triangle implements DisplayObject {
  /// Creates a [Triangle] object that can be drawn on the canvas at points
  /// ([x1], [y1]), ([x2], [y2]), and ([x3], [y3]). Optionally define the
  /// [color] defaults to black. Also the style of the [fill].
  Triangle(
    int x1,
    int y1,
    int x2,
    int y2,
    int x3,
    int y3, {
    Color color = Colors.black,
    bool fill = false,
  }) {
    positions = [
      Offset(x1.toDouble(), y1.toDouble()),
      Offset(x2.toDouble(), y2.toDouble()),
      Offset(x3.toDouble(), y3.toDouble()),
    ];
    paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;
  }

  /// Converts an [ParsedDisplayObject] to a [Triangle].
  Triangle.fromParsedDisplayObject(
    ParsedDisplayObject parsedDisplayObject,
  ) {
    if (parsedDisplayObject.type == DisplayObjectTypes.triangle) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 6 || variables.length > 7) {
        throw FormatException(
          'Triangles requires 6 or 7 variables, provided: ${variables.length}',
        );
      }
      if (variables.length >= 6) {
        positions = [
          Offset(
            double.parse(variables[0] as String),
            double.parse(variables[1] as String),
          ),
          Offset(
            double.parse(variables[2] as String),
            double.parse(variables[3] as String),
          ),
          Offset(
            double.parse(variables[4] as String),
            double.parse(variables[5] as String),
          ),
        ];
      }
      var color = Colors.black;
      if (variables.length == 7) {
        color = variables[6] as Color;
      }
      paint = Paint()
        ..color = color
        ..style = parsedDisplayObject.filled
            ? PaintingStyle.fill
            : PaintingStyle.stroke;
    } else {
      throw FormatException(
        'This is not a triangle, this is a: ${parsedDisplayObject.type}',
      );
    }
  }

  /// Vertices of the triangle.
  late List<Offset> positions;

  /// Color and fill of the triangle.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    if (paint.style == PaintingStyle.fill) {
      canvas.drawVertices(
        Vertices(VertexMode.triangles, positions),
        BlendMode.srcOver,
        paint,
      );
    } else {
      final path = Path()..moveTo(positions[0].dx, positions[0].dy);
      for (var i = 1; i < positions.length; i++) {
        path.lineTo(positions[i].dx, positions[i].dy);
      }

      // Close the path to complete the shape
      path.close();

      // Draw the path (hollow polygon)
      canvas.drawPath(path, paint);
    }
  }
}
