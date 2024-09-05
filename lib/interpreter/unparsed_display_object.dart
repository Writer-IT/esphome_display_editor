import 'package:esphome_display_editor/objects/display_object_types.dart';

/// Mark a line of code to be treated as a render object.
class UnparsedDisplayObject {
  /// We know we will have to render this object, it has a [type] and the 
  /// associated [variables].
  UnparsedDisplayObject(this.type, this.variables);

  /// Type of render object, triangle, circle, etc.
  final DisplayObjectTypes type;

  /// Variables of the given [UnparsedDisplayObject].
  final List<String> variables;
}
