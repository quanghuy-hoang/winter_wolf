import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/models/settings.dart';

import '../utils/utils.dart';
import 'brush_settings_dialog.dart';

class SwatchPicker extends StatelessWidget {
  final SettingsProvider settings;
  const SwatchPicker({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    List<Widget> swatchPickerList = [
      ...settings.swatchList.map((color) =>
          Consumer<SettingsProvider>(builder: (context, painting, child) {
            return MySwatch(
              color: color,
              isSelected: color == painting.brushColor,
              onPressed: () {
                painting.brushColor = color;
                settings.lastPickedColor = color;
              },
              onLongPressed: () {
                painting.removeSwatch(settings.swatchList.indexOf(color));
              },
            );
          })),
      MyRoundButton(
        onPressed: () {
          showColorPicker(context);
        },
        child: const Icon(Icons.add),
      ),
    ];
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 200))],
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 50,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => swatchPickerList[index],
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 16,
            ),
            itemCount: swatchPickerList.length,
          ),
        ),
      ),
    );
  }

  void showColorPicker(context) {
    SettingsProvider settings =
        Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BrushSettingsDialog(
            initBrushColor: settings.brushColor,
            onAddSwatch: (color) {
              settings.brushColor = color;
              settings.addSwatch(color);
            },
          );
        });
  }
}

class MySwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final void Function() onPressed;
  final void Function() onLongPressed;
  const MySwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onPressed,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    // expensive, may not be needed
    bool isVeryBright = color.computeLuminance() > 0.9;
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: MyRoundBox(
        diameter: 36,
        color: Colors.white,
        child: Center(
          child: Center(
            child: MyRoundBox(
              diameter: 28,
              color: color,
              child: isSelected
                  ? Center(
                      child: MyRoundBox(
                        // visually the same size
                        diameter: isVeryBright ? 10 : 8,
                        color: isVeryBright ? Colors.black38 : Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
