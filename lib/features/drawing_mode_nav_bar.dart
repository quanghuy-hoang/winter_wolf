import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/models/settings.dart';

import '../utils/my_widgets.dart';

enum DrawingMode { drawLine, erase, sticker, paint, drawPoint }

class DrawingModeNavBar extends StatelessWidget {
  final SettingsProvider settings;
  const DrawingModeNavBar(this.settings, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyModeChangeButton(
          icon: const Icon(Icons.fiber_smart_record),
          isSelected: settings.mode == DrawingMode.drawPoint,
          onPressed: () {
            context.read<SettingsProvider>().mode = DrawingMode.drawPoint;
            context.read<SettingsProvider>().brushColor =
                settings.lastPickedColor;
          },
        ),
        const SizedBox(
          width: 8,
        ),
        MyModeChangeButton(
          icon: const Icon(Icons.format_color_fill_outlined),
          isSelected: settings.mode == DrawingMode.paint,
          onPressed: () {
            context.read<SettingsProvider>().mode = DrawingMode.paint;
            context.read<SettingsProvider>().brushColor =
                settings.lastPickedColor;
          },
        ),
        const SizedBox(
          width: 8,
        ),
        MyModeChangeButton(
          icon: const Icon(Icons.gesture),
          isSelected: settings.mode == DrawingMode.drawLine,
          onPressed: () {
            context.read<SettingsProvider>().mode = DrawingMode.drawLine;
            context.read<SettingsProvider>().brushColor =
                settings.lastPickedColor;
          },
        ),
        const SizedBox(
          width: 8,
        ),
        MyModeChangeButton(
          icon: const Icon(Icons.close),
          isSelected:
              context.read<SettingsProvider>().mode == DrawingMode.erase,
          onPressed: () {
            context.read<SettingsProvider>().mode = DrawingMode.erase;
            context.read<SettingsProvider>().lastPickedColor =
                settings.brushColor;
            context.read<SettingsProvider>().brushColor = Colors.white;
          },
        ),
        const SizedBox(
          width: 8,
        ),
        MyModeChangeButton(
          icon: const Icon(Icons.image_outlined),
          isSelected:
              context.read<SettingsProvider>().mode == DrawingMode.sticker,
          onPressed: () {
            context.read<SettingsProvider>().mode = DrawingMode.sticker;
          },
        ),
      ],
    );
    ;
  }
}

class MyModeChangeButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final bool isSelected;
  const MyModeChangeButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return MyRoundBox(
        diameter: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        child: IconButton(
          onPressed: onPressed,
          color: Colors.white,
          icon: icon,
        ),
      );
    }
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }
}
