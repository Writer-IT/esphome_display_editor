import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:flutter/material.dart';

/// Regular Polygon with a center, offset angle, size and amount of edges.
class RegularPolygon implements DisplayObject {
  RegularPolygon({
    required this.p1,
    required this.radius,
    required this.edges,
    this.rotation,
    this.color = Colors.black,
  });

  /// Center of the polygon.
  Offset p1;

  /// Radius of the polygon.
  int radius;

  /// Number of edges of the polygon.
  int edges;

  /// Rotation of the polygon.
  double? rotation;

  /// Color of the polygon.
  Color color;

  @override
  void renderOnCanvas(Canvas canvas) {
    // canvas.drawVertices(vertices, blendMode, paint);
  }
}
