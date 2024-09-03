import 'package:flutter/material.dart';

class Rectangle implements DisplayObject {
  Rectangle(int x, int y, int width, int height, {bool fill = false}) {
    rectangle = Rect.fromLTWH(
      x.toDouble(),
      y.toDouble(),
      width.toDouble(),
      height.toDouble(),
    );
    filled = fill;
  }

  /// Rectangle object to be drawn as a canvas.
  late Rect rectangle;

  late bool filled;
}
