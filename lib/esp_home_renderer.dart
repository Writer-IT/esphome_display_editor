import 'dart:async';
import 'dart:convert';

import 'package:esphome_display_editor/display_object_painter.dart';
import 'package:esphome_display_editor/interpreter/yaml_parser_pass.dart';
import 'package:esphome_display_editor/ui/constants.dart';
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
      final yaml = parseYamlFromString(widget.code);
      if (yaml != null) {
        final configurableVariables = parseConfigurableVariables(yaml);
        if (verifyDisplayComponent(yaml)) {
          final existingValues =
              widget.preferences.getString('configVariables');
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

          final displayObjects =
              parseDisplayObjects(yaml, configurableVariables);

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
            child: ListView(
              children: [
                // const SizedBox(
                //   width: 400,
                //   height: 400,
                //   child: SingleChildScrollView(
                //     child: Text('Customize Values'),
                //   ),
                // ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Configurable Inputs',
                      style: titleStyle,
                    ),
                    const Divider(),
                    SizedBox(
                      width: 200,
                      height: 400,
                      child: ListView.builder(
                        itemCount: configurableVariables.length,
                        itemBuilder: (context, index) {
                          final key =
                              configurableVariables.keys.toList()[index];
                          final value =
                              configurableVariables.values.toList()[index];

                          final controller = TextEditingController(text: value);
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      label: Text(key),
                                      fillColor: Colors.white,
                                      filled: true,
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          await updateVariable(
                                            'configVariables',
                                            jsonEncode(configurableVariables),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                    ),
                                    controller: controller,
                                    onChanged: (inputValue) {
                                      configurableVariables[key] = inputValue;
                                    },
                                    onTapOutside: (event) async {
                                      configurableVariables[key] =
                                          controller.text;
                                      await updateVariable(
                                        'configVariables',
                                        jsonEncode(configurableVariables),
                                      );
                                    },
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Display Preview',
                        textAlign: TextAlign.center,
                        style: titleStyle,
                      ),
                    ),
                    const Divider(),
                    CustomPaint(
                      painter: DisplayObjectPainter(displayObjects),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
      return const SizedBox(
        width: 400,
        height: 300,
        child: Text('Your display will render here.'),
      );
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
