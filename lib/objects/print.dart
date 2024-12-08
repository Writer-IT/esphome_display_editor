import 'package:esphome_display_editor/interpreter/interpreter_utilities.dart';
import 'package:esphome_display_editor/interpreter/parsed_display_object.dart';
import 'package:esphome_display_editor/objects/display_object.dart';
import 'package:esphome_display_editor/objects/display_object_types.dart';
import 'package:flutter/material.dart';

/// Text to be drawn.
class Print extends DisplayObject {
  /// Create text starting at point 1.
  Print(
    this.p1,
    this.font,
    this.text, {
    Color? color,
    Color? backgroundColor,
    this.textAlign,
  }) {
    if (color != null) {
      font = font.copyWith(color: color);
    }
    if (backgroundColor != null) {
      font = font.copyWith(backgroundColor: backgroundColor);
    }
  }

  /// Converts a [ParsedDisplayObject] to a [Print].
  Print.fromParsedDisplayObject(ParsedDisplayObject parsedDisplayObject) {
    if (parsedDisplayObject.type == DisplayObjectTypes.print) {
      final variables = parsedDisplayObject.variables;
      if (variables.length < 4 || variables.length > 7) {
        throw FormatException(
          'Print requires 4 to 7 variables, provided: ${variables.length}',
        );
      } else {
        p1 = Offset(
          double.parse(variables[0] as String),
          double.parse(variables[1] as String),
        );
        font = variables[2] as TextStyle;
        switch (variables.length) {
          case 4:
            textAlign = TextAlign.left;
            text = variables[3] as String;
          case 5:
            textAlign = parseTextAlign(variables[3] as String);
            text = variables[4] as String;
          case 6:
            textAlign = TextAlign.left;
            text = variables[4] as String;
          case 7:
            textAlign = parseTextAlign(variables[4] as String);
            text = variables[5] as String;
        }
      }
    } else {
      throw FormatException(
        'This is not a print statement, this is a: ${parsedDisplayObject.type}',
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
  late TextAlign? textAlign;

  @override
  void renderOnCanvas(Canvas canvas) {
    final textSpan = TextSpan(
      text: text,
      style: font,
    );

    TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign ??= TextAlign.start,
    )
      ..layout()
      ..paint(canvas, p1);
  }
}
