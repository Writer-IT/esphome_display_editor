import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';

/// Converts the strings of a display section to [ParsedDisplayObject]s.
class DisplayParserPass {
  /// Instantiate the parser for display sections.
  DisplayParserPass();

  static const _circleSignature = 'it.circle(';
  static const _lineSignature = 'it.line(';
  static const _rectangleSignature = 'it.rectangle(';
  static const _triangleSignature = 'it.triangle(';

  /// Parses given code to [ParsedDisplayObject]s.
  List<ParsedDisplayObject> parseDisplayCode(List<String> codeLines) {
    final result = <ParsedDisplayObject>[];

    for (var codeLine in codeLines) {
      // Clean up a potential comment in the line.
      final commentIndex = codeLine.indexOf('//');
      if (commentIndex >= 0) {
        codeLine = codeLine.replaceRange(commentIndex, codeLine.length, '');
      }

      // Some shenanigans for easily determining if we have to fill or not.
      final filled = codeLine.contains('filled');
      codeLine = codeLine.replaceAll('filled_', '')..trim();

      switch (codeLine) {
        case final circle when circle.startsWith(_circleSignature):
          final variables = parseVariables(circle, _circleSignature);
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.circle,
              variables,
              filled,
            ),
          );

        case final line when line.startsWith(_lineSignature):
          final variables = parseVariables(line, _lineSignature);
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.line,
              variables,
              filled,
            ),
          );

        case final rectangle when rectangle.startsWith(_rectangleSignature):
          final variables = parseVariables(rectangle, _rectangleSignature);
          result.add(
            ParsedDisplayObject(
              DisplayObjectTypes.rectangle,
              variables,
              filled,
            ),
          );

        case final triangle when triangle.startsWith(_triangleSignature):
          final variables = parseVariables(triangle, _triangleSignature);
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

  /// Parse variabales with the given signature.
  List<String> parseVariables(String codeLine, String signature) => codeLine
      .replaceRange(codeLine.length - 2, codeLine.length, '')
      .replaceRange(0, signature.length, '')
      .split(',')
      .map((variable) => variable.trim())
      .toList();
}