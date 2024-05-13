import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/features/sticker_on_canvas.dart';
import 'package:winter_wolf/features/swatch_picker.dart';
import 'package:winter_wolf/models/settings.dart';

import 'drawing_mode_nav_bar.dart';
import 'my_sticker.dart';

class ToolsContents extends StatelessWidget {
  const ToolsContents({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = context.watch<SettingsProvider>();
    switch (settings.mode) {
      case DrawingMode.drawLine || DrawingMode.drawPoint:
        return ToolLayout(
          smallTool: const BrushSizeSlider(),
          bigTool: SwatchPicker(settings: settings),
        );
      case DrawingMode.erase:
        return const ToolLayout(
          smallTool: BrushSizeSlider(),
          bigTool: null,
        );
      case DrawingMode.paint:
        return ToolLayout(
          smallTool: null,
          bigTool: SwatchPicker(settings: settings),
        );
      case DrawingMode.sticker:
        return ToolLayout(
          smallTool: AnimatedOpacity(
            opacity: settings.enableDeleteSticker ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 100),
              scale: settings.aboutToDeleteSticker ? 3 : 1,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: DragTarget<StickerOnCanvas>(
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return const Icon(
                          Icons.delete_outline_rounded,
                          size: 36,
                        );
                      },
                      onMove: (details) {
                        settings.aboutToDeleteSticker = true;
                      },
                      onLeave: (sticker) {
                        settings.aboutToDeleteSticker = false;
                      },
                      onAcceptWithDetails: (details) {
                        settings.aboutToDeleteSticker = false;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          bigTool: StickerList(settings: settings),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class ToolLayout extends StatelessWidget {
  final Widget? smallTool;
  final Widget? bigTool;
  const ToolLayout({super.key, this.smallTool, this.bigTool});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: smallTool,
          ),
          const SizedBox(height: 8),
          if (bigTool != null)
            Expanded(
              child: bigTool!,
            ),
        ],
      ),
    );
  }
}

class BrushSizeSlider extends StatelessWidget {
  const BrushSizeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
              thumbColor: Colors.pink[200],
              activeTrackColor: Colors.pink[300],
              inactiveTrackColor: Colors.pink[100],
            ),
            child: Consumer<SettingsProvider>(
              builder: (context, painting, child) {
                return Animate(
                  effects: const [
                    FadeEffect(duration: Duration(milliseconds: 200))
                  ],
                  child: Slider(
                    label: painting.brushSize.floor().toString(),
                    value: painting.brushSize,
                    min: 5,
                    max: MediaQuery.of(context).size.width / 5,
                    onChangeStart: (value) {
                      painting.displayBrushPreview = true;
                    },
                    onChanged: (value) {
                      painting.brushSize = value;
                    },
                    onChangeEnd: (value) {
                      painting.displayBrushPreview = false;
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BrushSizePreview extends StatelessWidget {
  final double canvasSize;
  const BrushSizePreview({super.key, required this.canvasSize});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = context.read<SettingsProvider>();
    bool displayBrushPreview = context.select(
        (SettingsProvider settingsProvider) =>
            settingsProvider.displayBrushPreview);
    if (!displayBrushPreview) {
      return const SizedBox.shrink();
    }

    double brushDisplaySize = context.select(
        (SettingsProvider settingsProvider) => settingsProvider.brushSize);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Center(
        child: Container(
          width: brushDisplaySize,
          height: brushDisplaySize,
          decoration: BoxDecoration(
            color: settings.brushColor,
            shape: BoxShape.circle,
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: settings.mode == DrawingMode.erase
                  ? Colors.grey.shade600
                  : Colors.grey.shade100,
              width: settings.brushSize / 16,
            ),
          ),
        ),
      ),
    );
  }
}

class StickerList extends StatelessWidget {
  final SettingsProvider settings;
  const StickerList({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(),
        SlideEffect(
          begin: Offset(0, 0.4),
          duration: Duration(milliseconds: 300),
        )
      ],
      child: Scrollbar(
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => DraggableSticker(
            stickerOnCanvas: StickerOnCanvas(
              sticker: MySticker(
                size: MediaQuery.of(context).size.width / 4,
                imagePath: settings.stickerList[index],
              ),
              position: const Offset(0, 0),
              scale: 1,
              angle: 0,
            ),
          ),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8,
          ),
          itemCount: settings.stickerList.length,
        ),
      ),
    );
  }
}
