import 'package:esphome_display_editor/interpreter/unparsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';

/// Transforms all render calls to render objects.
class RenderObjectPass {
  /// Will transforms [UnparsedDisplayObject]s to [DisplayObject]s.
  RenderObjectPass(this.variables);

  /// What objects we will have to render and transform into a
  /// [DisplayObject].
  final List<(String, Object)>? variables;

  /// Transforms [UnparsedDisplayObject]s in [renderObjects] into
  /// [DisplayObject]s.
  List<DisplayObject> transformObjects(
      List<UnparsedDisplayObject> renderObjects) {}
}
