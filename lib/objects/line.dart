import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:flutter/material.dart';

/// A line to be drawn.
class Line extends DisplayObject {
    /// Create a line from point 1 to point 2.
    Line(this.p1, this.p2, {Color color = Colors.black}) {
        paint = Paint()
        ..color = color;
    }
    /// Start position of the line.
    final Offset p1;

    /// End position of the line.
    final Offset p2;

    /// Paint of the line.
    late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
      canvas.drawLine(p1, p2, paint);
  }
}
