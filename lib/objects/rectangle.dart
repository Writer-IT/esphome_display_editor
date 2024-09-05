import 'package:esphome_display_editor/objects/display_object.dart';
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

  /// Rectangle object to be drawn as a canvas.
  late Rect rect;

  /// Color and fill of the rectangle.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
}
