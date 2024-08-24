import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/text_settings_provider.dart';

class TextSettingsScreen extends StatelessWidget {
  const TextSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matn sozlamalari'),
      ),
      body: Consumer<TextSettingsProvider>(
        builder: (context, textSettings, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Shrift o\'lchami: ${textSettings.fontSize.toStringAsFixed(1)}'),
              Slider(
                value: textSettings.fontSize,
                min: 12.0,
                max: 30.0,
                divisions: 36,
                label: textSettings.fontSize.toStringAsFixed(1),
                onChanged: (value) {
                  textSettings.setFontSize(value);
                },
              ),
              const SizedBox(height: 20),
              Text('Shrift turi: ${textSettings.fontFamily}'),
              DropdownButton<String>(
                value: textSettings.fontFamily,
                items: const [
                  DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                  DropdownMenuItem(value: 'OpenSans', child: Text('Open Sans')),
                  DropdownMenuItem(value: 'Lato', child: Text('Lato')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    textSettings.setFontFamily(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}