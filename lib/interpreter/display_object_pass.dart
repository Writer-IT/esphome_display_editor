import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/circle.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/objects/line.dart';
import 'package:esphome_display_editor/objects/print.dart';
import 'package:esphome_display_editor/objects/printf.dart';
import 'package:esphome_display_editor/objects/rectangle.dart';
import 'package:esphome_display_editor/objects/regular_polygon.dart';
import 'package:esphome_display_editor/objects/triangle.dart';

/// Transforms all render calls to render objects.
class DisplayObjectPass {
  /// Will transforms [ParsedDisplayObject]s to [DisplayObject]s.
  DisplayObjectPass();

  /// Transforms [ParsedDisplayObject]s into [DisplayObject]s.
  List<DisplayObject> transformObjects(
    List<ParsedDisplayObject> parsedDisplayObjects,
    Map<String, Object> variableToValueMapping,
  ) {
    final result = <DisplayObject>[];
    for (final parsedDisplayObject in parsedDisplayObjects) {
      switch (parsedDisplayObject.type) {
        case DisplayObjectTypes.circle:
          result.add(
            Circle.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.line:
          result.add(
            Line.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.rectangle:
          result.add(
            Rectangle.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.triangle:
          result.add(
            Triangle.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.print:
          result.add(
            Print.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.printf:
          result.add(
            Printf.fromParsedDisplayObject(
              parsedDisplayObject,
              variableToValueMapping,
            ),
          );
        case DisplayObjectTypes.regularPolygon:
          result.add(RegularPolygon.fromParsedDisplayObject(
            parsedDisplayObject,
            variableToValueMapping,
          ));
      }
    }
    return result;
  }
}
