import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/features/canvas_zone.dart';
import 'package:winter_wolf/features/my_sticker.dart';
import 'package:winter_wolf/features/sticker_on_canvas.dart';
import 'package:winter_wolf/models/painting.dart';
import 'package:winter_wolf/models/settings.dart';
import 'package:winter_wolf/utils/save_to_gallery.dart';
import '../features/drawing_mode_nav_bar.dart';
import '../features/swatch_picker.dart';
import '../utils/my_widgets.dart';

class DrawingAppMainScreen extends StatefulWidget {
  const DrawingAppMainScreen({super.key});

  @override
  State<DrawingAppMainScreen> createState() => _DrawingAppMainScreenState();
}

class _DrawingAppMainScreenState extends State<DrawingAppMainScreen> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final double deviceWidth = MediaQuery.of(context).size.width;
    const double canvasPadding = 64.0;
    final double canvasSize = deviceWidth - canvasPadding;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyTextButton(
                      text: "save",
                      onPressed: () async {
                        await saveImageFromRepaintBoundaryToGallery(
                          _key,
                          context: context,
                        );
                      }),
                ],
              ),
              const SizedBox(height: 16),
              DrawingModeNavBar(settings),
              const SizedBox(height: 16),
              buildActionBar(),
              const SizedBox(height: 16),
              CanvasZone(
                globalKey: _key,
                settings: settings,
                canvasSize: canvasSize,
              ),
              const SizedBox(height: 16),
              buildDrawModeTools(settings),
            ],
          ),
        ),
      ),
    );
  }

  void showClearScreenAlert() {
    PaintingProvider painting =
        Provider.of<PaintingProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            content: const Text(
              "clear everything you've drawn?",
              style: TextStyle(fontSize: 16),
            ),
            actionsPadding: const EdgeInsets.all(12),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            actions: [
              MyTextButton(
                text: "yes",
                onPressed: () {
                  painting.clearLine();
                  painting.clearSticker();
                  Navigator.pop(context);
                },
              ),
              MyTextButton(
                text: "no",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget buildDrawModeTools(SettingsProvider settings) {
    switch (settings.mode) {
      case DrawingMode.drawLine || DrawingMode.drawPoint:
        return buildToolLayout(
          smallTool: buildBrushSizeSlider(),
          bigTool: SwatchPicker(settings: settings),
        );
      case DrawingMode.erase:
        return buildToolLayout(
          smallTool: buildBrushSizeSlider(),
          bigTool: null,
        );
      case DrawingMode.paint:
        return buildToolLayout(
          smallTool: null,
          bigTool: SwatchPicker(settings: settings),
        );
      case DrawingMode.sticker:
        return buildToolLayout(
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
          bigTool: buildStickerList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildToolLayout(
      {required Widget? smallTool, required Widget? bigTool}) {
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
              child: bigTool,
            ),
        ],
      ),
    );
  }

  Widget buildBrushSizeSlider() {
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

  Widget buildActionBar() {
    if (context.watch<SettingsProvider>().mode == DrawingMode.sticker) {
      return Row(
        children: [
          const Spacer(),
          buildClearScreenButton(),
        ],
      );
    }
    return Row(
      children: [
        buildUndoButton(),
        buildRedoButton(),
        const Spacer(),
        buildClearScreenButton(),
      ],
    );
  }

  Widget buildClearScreenButton() {
    PaintingProvider painting = context.read<PaintingProvider>();
    return MyTextButton(
      text: "clear screen",
      onPressed:
          (painting.lines.isNotEmpty || painting.stickerOnCanvasList.isNotEmpty)
              ? () {
                  showClearScreenAlert();
                }
              : null,
    );
  }

  Widget buildUndoButton() {
    PaintingProvider painting = context.read<PaintingProvider>();
    return MyTextButton(
      text: "undo",
      onPressed: painting.lines.isNotEmpty
          ? () {
              painting.addUndoLine(painting.lines.last);
              painting.removeLastLine();
            }
          : null,
    );
  }

  Widget buildRedoButton() {
    PaintingProvider painting = context.read<PaintingProvider>();
    return MyTextButton(
      text: "redo",
      onPressed: painting.undoStack.isNotEmpty
          ? () {
              painting.addLine(painting.undoStack.last);
              painting.removeLastUndoLine();
            }
          : null,
    );
  }

  Widget buildStickerList() {
    SettingsProvider settings = context.watch<SettingsProvider>();

    return Animate(
      effects: const [
        FadeEffect(),
        SlideEffect(
          begin: ui.Offset(0, 0.4),
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
              position: const ui.Offset(0, 0),
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
