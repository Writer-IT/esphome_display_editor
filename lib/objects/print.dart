import 'package:esphome_display_editor/objects/display_object.dart';
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
    ).paint(canvas, p1);
  }
}
