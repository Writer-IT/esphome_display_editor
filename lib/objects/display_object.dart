import 'package:flutter/material.dart';

/// Abstract display object that represents options in the display library of
/// ESPHome.
// ignore: one_member_abstracts
abstract class DisplayObject {
  /// Render the object on the canvas.
  void renderOnCanvas(Canvas canvas);
}
