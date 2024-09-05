/// Mark a line of code to be treated as a render object.
class RenderObject {
  /// We know we will have to render this object, it has a [type] and the 
  /// associated [variables].
  RenderObject(this.type, this.variables);

  /// Type of render object, triangle, circle, etc.
  final String type;

  /// Variables of the given [RenderObject].
  final List<String> variables;
}
