import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:flutter/material.dart';

/// Transforms all render calls to render objects.
class RenderObjectPass {
  /// Will transforms [RenderObject]s to [DisplayObject]s.
  RenderObjectPass(this.variables);

  /// What objects we will have to render and transform into a
  /// [DisplayObject].
  final List<(String, Object)>? variables;

  List<DisplayObject> transformObjects() {}
}
