import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/utils/parsing_helpers.dart';
import 'package:flutter/material.dart';

/// Regular Polygon with a center, offset angle, size and amount of edges.
class RegularPolygon implements DisplayObject {
  /// Constructor for a [RegularPolygon].
  RegularPolygon({
    required this.p1,
    required this.radius,
    required this.edges,
    this.rotation,
    this.color = Colors.black,
  });

  /// Converts an [ParsedDisplayObject] to a [RegularPolygon].
  RegularPolygon.fromParsedDisplayObject({
    required ParsedDisplayObject parsedDisplayObject,
    required Map<String, Object> variableToValueMapping,
  }) {
    if (parsedDisplayObject.type == DisplayObjectTypes.regularPolygon) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 6 || variables.length > 8) {
        throw FormatException(
          'Rectangle requires 6 to 8 variables, provided: ${variables.length}',
        );
      }
      final x = parseNumValue(
        valueObject: variables[0],
        variableToValueMapping: variableToValueMapping,
      );
      final y = parseNumValue(
        valueObject: variables[1],
        variableToValueMapping: variableToValueMapping,
      );
      p1 = Offset(x, y);

      radius = parseNumValue(
        valueObject: variables[2],
        variableToValueMapping: variableToValueMapping,
      );
      edges = parseNumValue(
        valueObject: variables[3],
        variableToValueMapping: variableToValueMapping,
      );
      switch (variables.length) {
        case 6:
          color = variables[4] as Color;
        case 7:
          color = variables[5] as Color;
        case 8:
          rotation = parseNumValue(
            valueObject: variables[5],
            variableToValueMapping: variableToValueMapping,
          );
          color = variables[6] as Color;
        default:
          throw Exception('Something weird happened here, your variables '
              'are not an accepted length.');
      }
    } else {
      throw FormatException(
        'This is not a rectangle type, '
        'this is a: ${parsedDisplayObject.type}',
      );
    }
  }

  /// Center of the polygon.
  late Offset p1;

  /// Radius of the polygon.
  late double radius;

  /// Number of edges of the polygon.
  late double edges;

  /// Rotation of the polygon.
  double? rotation;

  /// Color of the polygon.
  late Color color;

  @override
  void renderOnCanvas(Canvas canvas) {
      StarBorder.polygon(side: BorderSide(color: color, width: 2), sides: edges, );
  }

  List[Offset] _getPoints() {
      baseRadian = :
      for (var i = 0; i < edges; i++) {
              
            }
  }
}
