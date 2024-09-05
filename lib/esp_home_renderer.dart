import 'package:esphome_display_editor/display_object_painter.dart';
import 'package:esphome_display_editor/interpreter/yaml_parser_pass.dart';
import 'package:flutter/material.dart';

/// Responsible for rendering the display.
class EspHomeRenderer extends StatelessWidget {
  /// Instantiate the widget that will render the given code.
  const EspHomeRenderer({
    required this.code,
    required this.variables,
    super.key,
  });

  /// Variables users can interact with.
  final List<(String, Object)> variables;

  /// ESPHome config code.
  final String code;

  @override
  Widget build(BuildContext context) {
    try {
      final parser = YamlParserPass(variables);
      final displayObjects = parser.parse(code);

      // TODO replace width and height with layouts, parse from display type.
      return SizedBox(
        width: 400,
        height: 300,
        child: CustomPaint(painter: DisplayObjectPainter(displayObjects)),
      );
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return AlertDialog(content: Text('Uh oh something went wrong $e'));
    }
  }
}
