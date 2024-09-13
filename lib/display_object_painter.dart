import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:flutter/rendering.dart';

/// Painter that can paint the given display objects.
class DisplayObjectPainter extends CustomPainter {
  /// Initializes the painter.
  DisplayObjectPainter(this.displayObjects);

  /// The objects that should be painted.
  final List<DisplayObject> displayObjects;

  @override
  void paint(Canvas canvas, Size size) {
    for (final displayObject in displayObjects) {
      displayObject.renderOnCanvas(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
