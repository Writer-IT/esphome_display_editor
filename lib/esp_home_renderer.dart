import 'dart:async';
import 'dart:convert';

import 'package:esphome_display_editor/display_object_painter.dart';
import 'package:esphome_display_editor/interpreter/yaml_parser_pass.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Responsible for rendering the display.
class EspHomeRenderer extends StatefulWidget {
  /// Instantiate the widget that will render the given code.
  const EspHomeRenderer({
    required this.code,
    required this.variables,
    required this.preferences,
    super.key,
  });

  /// Variables users can interact with.
  final List<(String, Object)> variables;

  /// ESPHome config code.
  final String code;

  /// Preferences to store values
  final SharedPreferencesWithCache preferences;

  @override
  State<EspHomeRenderer> createState() => _EspHomeRendererState();
}

class _EspHomeRendererState extends State<EspHomeRenderer> {
  Future<void> updateVariable(String key, String value) async {
    await widget.preferences.setString(key, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    try {
      final result = parseYaml(widget.code);
      if (result != null) {
        final (displayObjects, configurableVariables) = result;

        // pass the configurable variables to a parent of display object painter
        // and make sure the configurableVariables are edited in the parent of
        // the painter. So triggerering a setState will make sure that the
        // display is refreshed

        final existingValues = widget.preferences.getString('configVariables');
        if (existingValues != null) {
          final existingConfigVariables =
              jsonDecode(existingValues) as Map<String, dynamic>;

          for (final key in configurableVariables.keys) {
            if (existingConfigVariables.containsKey(key) &&
                existingConfigVariables[key] != null) {
              configurableVariables[key] =
                  existingConfigVariables[key]! as String;
            }
          }
        }

        return ListView(
          children: [
            // const SizedBox(
            //   width: 400,
            //   height: 400,
            //   child: SingleChildScrollView(
            //     child: Text('Customize Values'),
            //   ),
            // ),
            SizedBox(
              width: 400,
              height: 400,
              child: ListView.builder(
                itemCount: configurableVariables.length,
                itemBuilder: (context, index) {
                  final key = configurableVariables.keys.toList()[index];
                  final value = configurableVariables.values.toList()[index];

                  return Row(
                    children: [
                      Expanded(child: Text(key)),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Enter value'),
                          controller: TextEditingController(text: value),
                          onSubmitted: (inputValue) async {
                            configurableVariables[key] = inputValue;
                            await updateVariable(
                              'configVariables',
                              jsonEncode(configurableVariables),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: 400,
              height: 300,
              child: CustomPaint(painter: DisplayObjectPainter(displayObjects)),
            ),
          ],
        );
      } else {
        return const SizedBox(
          width: 400,
          height: 300,
          child: Text('Your display will render here.'),
        );
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text('Uh oh something went wrong $e, $stacktrace'),
        ),
      );
    }
  }
}
