import 'dart:async';

import 'package:esphome_display_editor/esp_home_renderer.dart';
import 'package:esphome_display_editor/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Editor for ESPHome displays.
class EspHomeEditor extends StatefulWidget {
  /// Instantiate the editor.
  const EspHomeEditor({super.key});

  @override
  State<EspHomeEditor> createState() => _EspHomeEditorState();
}

class _EspHomeEditorState extends State<EspHomeEditor> {
  static const _displayCodeKey = 'display_code';
  String code = '';

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: code);
    return FutureBuilder<SharedPreferencesWithCache>(
      // ignore: discarded_futures
      future: SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      ),
      builder: (context, prefs) {
        if (prefs.hasData) {
          var code = prefs.data!.getString(_displayCodeKey) ?? '';
          textController.text = code;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('ESP Home Editor'),
            ),
            drawer: Drawer(
              child: ListView(
                children: const [
                  DrawerHeader(child: Text('ESPHome Display Editor')),
                  AboutListTile(
                    icon: Icon(Icons.info),
                    applicationName: 'ESPHome Display Editor',
                    applicationVersion: 'Rolling Release',
                  ),
                ],
              ),
            ),
            body: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    child: Column(
                      children: [
                        Text(
                          'Code',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                            child: TextField(
                              controller: textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              expands: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Your display lambda',
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              code = textController.text;
                              unawaited(
                                prefs.data!.setString(
                                  _displayCodeKey,
                                  code,
                                ),
                              );
                            }),
                            child: const Text(
                              'Render Preview',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: EspHomeRenderer(
                    code: code,
                    variables: const [],
                    preferences: prefs.data!,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Please wait');
        }
      },
    );
  }
}
