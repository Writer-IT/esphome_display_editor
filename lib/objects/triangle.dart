import 'dart:ui';

import 'package:esphome_display_editor/objects/display_object.dart';
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
    vertices = Vertices(
      VertexMode.triangles,
      [
        Offset(x1.toDouble(), y1.toDouble()),
        Offset(x2.toDouble(), y2.toDouble()),
        Offset(x3.toDouble(), y3.toDouble()),
      ],
    );
    paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;
  }

  /// Vertices of the triangle.
  late Vertices vertices;

  /// Color and fill of the triangle.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    canvas.drawVertices(vertices, BlendMode.srcOver, paint);
  }
}
