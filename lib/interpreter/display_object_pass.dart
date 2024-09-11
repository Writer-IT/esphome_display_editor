import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/circle.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/objects/line.dart';
import 'package:esphome_display_editor/objects/rectangle.dart';
import 'package:esphome_display_editor/objects/triangle.dart';

/// Transforms all render calls to render objects.
class DisplayObjectPass {
  /// Will transforms [ParsedDisplayObject]s to [DisplayObject]s.
  DisplayObjectPass();

  /// Transforms [ParsedDisplayObject]s into [DisplayObject]s.
  List<DisplayObject> transformObjects(
    List<ParsedDisplayObject> parsedDisplayObjects,
    Map<String, Object> variableToObjectMapping,
  ) {
    final result = <DisplayObject>[];
    for (final parsedDisplayObject in parsedDisplayObjects) {
      switch (parsedDisplayObject.type) {
        case DisplayObjectTypes.circle:
          result.add(Circle.fromParsedDisplayObject(parsedDisplayObject));
        case DisplayObjectTypes.line:
          result.add(
            Line.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToObjectMapping,
            ),
          );
        case DisplayObjectTypes.rectangle:
          result.add(
            Rectangle.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToObjectMapping,
            ),
          );
        case DisplayObjectTypes.triangle:
          result.add(Triangle.fromParsedDisplayObject(parsedDisplayObject));
      }
    }
    return result;
  }
}
