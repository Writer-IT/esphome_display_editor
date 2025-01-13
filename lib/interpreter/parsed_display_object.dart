import 'package:esphome_display_editor/objects/display_object_types.dart';

/// Mark a line of code to be treated as a render object.
class ParsedDisplayObject {
  /// We know we will have to render this object, it has a [type] and the
  /// associated [variables]. 
  ///
  /// Requires the [type] to be defined, the related [variables]. And lastly 
  /// the special variable [filled], because this has to be gathered from the 
  /// function call.
  ParsedDisplayObject(this.type, this.variables, this.filled);

  /// Type of render object, triangle, circle, etc.
  final DisplayObjectTypes type;

  /// Variables of the given [ParsedDisplayObject].
  final List<Object> variables;

  /// Whether or not to fill the object.
  final bool filled;
}
