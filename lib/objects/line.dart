import 'package:esphome_display_editor/objects/display_objects.dart';
import 'package:flutter/material.dart';

/// A line to be drawn.
class Line implements DisplayObject {
    /// Create a line from point 1 to point 2.
    Line(this.p1, this.p2);
    /// Start position of the line.
    final Offset p1;

    /// End position of the line.
    final Offset p2;
}
