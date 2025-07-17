import 'package:esphome_display_editor/interpreter/interpreter_utilities.dart';
import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:esphome_display_editor/utils/parsing_helpers.dart';
import 'package:flutter/material.dart';

/// Text with variable input to be drawn.
class Printf extends DisplayObject {
  /// Create text that can be filed with variables
  Printf(
    this.p1,
    this.font,
    this.text, {
    Color? color,
    Color? backgroundColor,
    this.textAlign = TextAlign.left,
  }) {
    if (color != null) {
      font = font.copyWith(color: color);
    }
    if (backgroundColor != null) {
      font = font.copyWith(backgroundColor: backgroundColor);
    }
  }

  /// Converts a [ParsedDisplayObject] to a [Printf].
  Printf.fromParsedDisplayObject(
    ParsedDisplayObject parsedDisplayObject,
    Map<String, Object> variableToValueMapping,
  ) {
    if (parsedDisplayObject.type == DisplayObjectTypes.printf) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 4) {
        throw FormatException(
          'Print requires at least 4 variables, provided: ${variables.length}',
        );
      }
      p1 = Offset(
        parseNumValue(
          valueObject: variables[0],
          variableToValueMapping: variableToValueMapping,
        ),
        parseNumValue(
          valueObject: variables[1],
          variableToValueMapping: variableToValueMapping,
        ),
      );
      font = variables[2] as TextStyle;
      late String formatString;
      final formatVariables = <String>[];
      Color? color;
      Color? backgroundColor;
      var parsingFormatVariables = false;

      /// Parsing actual variables and parsing all format variables after
      for (var i = 3; i < variables.length; i++) {
        final variable = variables[i].toString();
        if (parsingFormatVariables || i > 7) {
          formatVariables.add(variable);
        } else {
          if (i >= 3) {
            final (type, object) = _parsePotentialVar(variable);
            switch (type) {
              case == String:
                formatString = object as String;
                parsingFormatVariables = true;
              case == TextAlign:
                textAlign = object as TextAlign;
              case == Color:
                if (color == null) {
                  color = object as Color;
                } else {
                  backgroundColor = object as Color;
                }
              default:
                throw const FormatException(
                  'This printf variable could not be parsed',
                );
            }
          } else {
            throw FormatException('Guess this broke, better call tech support, '
                'context $variables');
          }
        }
      }

      // Inputting parsed variables
      // TODO separate this out
      final stringBuffer = StringBuffer();
      for (var i = 1; i < formatString.length - 1; i++) {
        if (formatString[i] == '%' && i + 1 < formatString.length - 1) {
          final nextChar = formatString[i + 1].toLowerCase();
          i += 1;
          if ('%' == nextChar) {
            stringBuffer.write('%');
          } else if (['d', 'i', 'u'].contains(nextChar)) {
            final abstractVariable = formatVariables.removeAt(0);
            final variable = int.tryParse(abstractVariable);
            if (variable != null) {
              stringBuffer.write(variable);
            } else {
              stringBuffer.write(abstractVariable);
            }
            // Doubles
          } else if ('f' == nextChar || '.' == nextChar) {
            var precisionString = '';
            if (nextChar == '.') {
              // Skipping over characters to find 'f' and number of decimals
              i += 1;
              while (i + 1 < formatString.length - 1) {
                final precisionChar = formatString[i + 1].toLowerCase();
                if (precisionChar == 'f' ||
                    int.tryParse(precisionChar) == null) {
                  i += 1;
                  break;
                } else {
                  precisionString += precisionChar;
                  i += 1;
                }
              }
            }
            final dynamicVariable = formatVariables.removeAt(0);
            final variable = double.tryParse(dynamicVariable);
            if (variable != null) {
              final precision = int.tryParse(precisionString);
              if (precision == null) {
                stringBuffer.write(variable);
              } else {
                stringBuffer.write(variable.toStringAsPrecision(precision));
              }
            } else {
              stringBuffer.write(dynamicVariable);
            }
          } else if (['c', 's'].contains(nextChar)) {
            final variable = formatVariables.removeAt(0);
            stringBuffer.write(variable);
          } else {
            stringBuffer.write('� ');
          }
        } else {
          stringBuffer.write(formatString[i]);
        }
      }
      text = stringBuffer.toString();

      if (color != null) {
        font = font.copyWith(color: color);
      }
      if (backgroundColor != null) {
        font = font.copyWith(backgroundColor: backgroundColor);
      }
    } else {
      throw FormatException(
        'This is not a printf statement, '
        'this is a: ${parsedDisplayObject.type}',
      );
    }
  }

  /// Start position of the text.
  late Offset p1;

  /// Font used for printing.
  late TextStyle font;

  /// Text to be printend.
  late String text;

  /// Alignment of the text.
  TextAlign textAlign = TextAlign.left;

  @override
  void renderOnCanvas(Canvas canvas) {
    final textSpan = TextSpan(
      text: text,
      style: font,
    );

    TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    )
      ..layout()
      ..paint(canvas, p1);
  }

  (Type, Object) _parsePotentialVar(String variable) {
    if (variable.startsWith('"')) {
      return (String, variable);
    }
    try {
      final textAlign = parseTextAlign(variable);
      return (TextAlign, textAlign);
    } on FormatException {
      final color = variable as Color;
      return (Color, color);
    }
  }
}
