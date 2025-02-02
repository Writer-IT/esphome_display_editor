import 'dart:math';
import 'dart:ui';

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
    Color color = Colors.black,
    bool fill = false,
  }) {
    paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;
  }

  /// Converts an [ParsedDisplayObject] to a [RegularPolygon].
  RegularPolygon.fromParsedDisplayObject(
    ParsedDisplayObject parsedDisplayObject,
    Map<String, Object> variableToValueMapping,
  ) {
    if (parsedDisplayObject.type == DisplayObjectTypes.regularPolygon) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 4 || variables.length > 8) {
        throw FormatException(
          'Rectangle requires 4 to 8 variables, provided: ${variables.length}',
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
      ).toInt();
      var color = Colors.black;
      if (parsedDisplayObject.filled) {
        switch (variables.length) {
          case 4:
            break;
          case 5:
            color = _tryParseColor(variables[4]);
          case 6:
            color = _tryParseColor(variables[5]);
          case 7:
            rotation = parseNumValue(
              valueObject: variables[5],
              variableToValueMapping: variableToValueMapping,
            );
            color = _tryParseColor(variables[6]);
        }
      } else {
        switch (variables.length) {
          case 4:
            break;
          case 5:
            color = _tryParseColor(variables[4]);
          case 6:
            color = _tryParseColor(variables[4]);
          case 7:
            color = _tryParseColor(variables[5]);
          case 8:
            rotation = parseNumValue(
              valueObject: variables[5],
              variableToValueMapping: variableToValueMapping,
            );
            color = _tryParseColor(variables[6]);
          default:
            throw Exception('Something weird happened here, your variables '
                'are not an accepted length.');
        }
      }
      paint = Paint()
        ..color = color
        ..style = parsedDisplayObject.filled
            ? PaintingStyle.fill
            : PaintingStyle.stroke;
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
  late int edges;

  /// Rotation of the polygon.
  double? rotation;

  /// Color of the polygon.
  late Paint paint;

  @override
  void renderOnCanvas(Canvas canvas) {
    final points = _getPoints();

    if (paint.style == PaintingStyle.fill) {
      final vertices = Vertices(VertexMode.triangleFan, points);
      canvas.drawVertices(vertices, BlendMode.srcOver, paint);
    } else {
      points.add(points.first);
      canvas.drawPoints(PointMode.polygon, points, paint);
    }
  }

  List<Offset> _getPoints() {
    final baseRotation = rotation ?? 0;
    final baseRadian = baseRotation / 180.0 * pi;
    final rotationStep = 2 * pi / edges;

    late double startRotation;
    if (edges.isEven) {
      startRotation = baseRadian + rotationStep / 2;
    } else {
      startRotation = baseRotation;
    }

    final points = <Offset>[];
    for (var i = 0; i < edges; i++) {
      final angle = startRotation + i * rotationStep;
      final point = p1 + Offset(radius * cos(angle), radius * sin(angle));
      points.add(point);
    }
    return points;
  }

  Color _tryParseColor(Object colorObject) {
    try {
      return colorObject as Color;
      // ignore: avoid_catching_errors
    } on TypeError {
      return Colors.black;
    }
  }
}
