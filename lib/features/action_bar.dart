import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/models/settings.dart';
import 'package:winter_wolf/models/painting.dart';
import '../utils/utils.dart';
import 'drawing_mode_nav_bar.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = context.watch<SettingsProvider>();
    PaintingProvider painting = context.watch<PaintingProvider>();
    return Row(
      children: [
        if (settings.mode != DrawingMode.sticker) ...[
          buildUndoButton(painting, context),
          buildRedoButton(painting, context),
        ],
        const Spacer(),
        buildClearScreenButton(painting, context),
      ],
    );
  }

  Widget buildClearScreenButton(
      PaintingProvider painting, BuildContext context) {
    return MyTextButton(
      text: "clear screen",
      onPressed:
          (painting.lines.isNotEmpty || painting.stickerOnCanvasList.isNotEmpty)
              ? () {
                  showClearScreenAlert(context);
                }
              : null,
    );
  }

  Widget buildUndoButton(PaintingProvider painting, BuildContext context) {
    return MyTextButton(
      text: "undo",
      onPressed: painting.lines.isNotEmpty
          ? () {
              context.read<PaintingProvider>().addUndoLine(painting.lines.last);
              context.read<PaintingProvider>().removeLastLine();
            }
          : null,
    );
  }

  Widget buildRedoButton(PaintingProvider painting, BuildContext context) {
    return MyTextButton(
      text: "redo",
      onPressed: painting.undoStack.isNotEmpty
          ? () {
              context.read<PaintingProvider>().addLine(painting.undoStack.last);
              context.read<PaintingProvider>().removeLastUndoLine();
            }
          : null,
    );
  }

  void showClearScreenAlert(BuildContext buildContext) {
    showDialog(
        context: buildContext,
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
                  buildContext.read<PaintingProvider>().clearLine();
                  buildContext.read<PaintingProvider>().clearSticker();
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
}
