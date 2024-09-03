import 'package:esphome_display_editor/objects/display_objects.dart';
import 'package:flutter/material.dart';

class Circle implements DisplayObject {
  Circle(int x, int y, int radius, {bool fill = false}) {
    center = Offset(x.toDouble(), y.toDouble());
    this.radius = radius.toDouble();
    filled = fill;
  }

  /// Center of the circle.
  late Offset center;

  /// Radius of the circle.
  late double radius;

  /// Whether or not to fill the circle.
  late bool filled;
}
