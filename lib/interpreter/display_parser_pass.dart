import 'package:esphome_display_editor/interpreter/interpreter_utilities.dart';
import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';

/// Converts the strings of a display section to [ParsedDisplayObject]s.
class DisplayParserPass {
  /// Instantiate the parser for display sections.
  DisplayParserPass(this.variableToObjectMapping);

  /// The variable mapping.
  final Map<String, Object> variableToObjectMapping;

  static const _circleSignature = 'it.circle(';
  static const _lineSignature = 'it.line(';
  static const _rectangleSignature = 'it.rectangle(';
  static const _triangleSignature = 'it.triangle(';

  /// Parses given code to [ParsedDisplayObject]s.
  List<ParsedDisplayObject> parseDisplayCode(List<String> codeLines) {
    final result = <ParsedDisplayObject>[];

    for (var codeLine in codeLines) {
      // Clean up a potential comment in the line.

      // Some shenanigans for easily determining if we have to fill or not.
      final filled = codeLine.contains('filled');
      codeLine = codeLine.replaceAll('filled_', '')..trim();

      switch (codeLine) {
        case final circle when circle.startsWith(_circleSignature):
          final variables = parseVariables(
            codeLine: circle,
            signature: _circleSignature,
            variableToObjectMapping: variableToObjectMapping,
          );
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.circle,
              variables,
              filled,
            ),
          );

        case final line when line.startsWith(_lineSignature):
          final variables = parseVariables(
            codeLine: line,
            signature: _lineSignature,
            variableToObjectMapping: variableToObjectMapping,
          );
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.line,
              variables,
              filled,
            ),
          );

        case final rectangle when rectangle.startsWith(_rectangleSignature):
          final variables = parseVariables(
            codeLine: rectangle,
            signature: _rectangleSignature,
            variableToObjectMapping: variableToObjectMapping,
          );
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.rectangle,
              variables,
              filled,
            ),
          );

        case final triangle when triangle.startsWith(_triangleSignature):
          final variables = parseVariables(
            codeLine: triangle,
            signature: _triangleSignature,
            variableToObjectMapping: variableToObjectMapping,
          );
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.triangle,
              variables,
              filled,
            ),
          );

        default:
          break;
      }
    }
    return result;
  }
}
