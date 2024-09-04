import 'dart:ui';

import 'package:esphome_display_editor/objects/display_object.dart';

class Triangle implements DisplayObject {
  Triangle(
    int x1,
    int y1,
    int x2,
    int y2,
    int x3,
    int y3, {
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
    filled = fill;
  }

  late Vertices vertices;

  late bool filled;
}
