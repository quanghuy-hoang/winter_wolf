import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

import '../utils/my_widgets.dart';

class BrushSettingsDialog extends StatefulWidget {
  final Color initBrushColor;
  final Function(Color color) onAddSwatch;
  final Function(Color color)? onColorChange;

  const BrushSettingsDialog({
    super.key,
    required this.initBrushColor,
    this.onColorChange,
    required this.onAddSwatch,
  });

  @override
  State<BrushSettingsDialog> createState() => _BrushSettingsDialogState();
}

class _BrushSettingsDialogState extends State<BrushSettingsDialog> {
  Color _currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initBrushColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: [
        MyTextButton(
          text: 'cancel',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MyTextButton(
          text: 'add swatch',
          onPressed: () {
            widget.onAddSwatch.call(_currentColor);
            Navigator.pop(context);
          },
        ),
      ],
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              ColorPicker(
                color: _currentColor,
                onChanged: (value) {
                  setState(() {
                    _currentColor = value;
                  });
                },
                initialPicker: Picker.wheel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
