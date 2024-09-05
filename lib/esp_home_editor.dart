import 'package:flutter/material.dart';

/// Editor for ESPHome displays.
class EspHomeEditor extends StatefulWidget {
  /// Instantiate the editor.
  const EspHomeEditor({super.key});

  @override
  State<EspHomeEditor> createState() => _EspHomeEditorState();
}

class _EspHomeEditorState extends State<EspHomeEditor> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
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
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your display lambda',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Render preview'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
