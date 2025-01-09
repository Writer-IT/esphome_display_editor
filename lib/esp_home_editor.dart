import 'dart:async';

import 'package:esphome_display_editor/esp_home_renderer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Editor for ESPHome displays.
class EspHomeEditor extends StatefulWidget {
  /// Instantiate the editor.
  const EspHomeEditor({required this.preferences, super.key});

  final SharedPreferences preferences;
  const String _codeKey = 'esphome_code';

  @override
  State<EspHomeEditor> createState() => _EspHomeEditorState();
}

class _EspHomeEditorState extends State<EspHomeEditor> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: code);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ESP Home Editor'),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 40,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your display lambda',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        code = textController.text;
                        unawaited(
                          widget.preferences.setString(widget._codeKey, code),
                        );
                      }),
                      child: const Text('Render preview'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EspHomeRenderer(
                code: code,
                variables: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
