import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/features/sticker_on_canvas.dart';
import 'package:winter_wolf/features/sticker_transformer.dart';

import '../models/painting.dart';
import '../models/settings.dart';
import 'drawing_mode_nav_bar.dart';
import 'drawing_line.dart';
import 'my_line_painter.dart';

class CanvasZone extends StatelessWidget {
  final GlobalKey globalKey;
  final SettingsProvider settings;
  final double canvasSize;
  const CanvasZone({
    super.key,
    required this.globalKey,
    required this.settings,
    required this.canvasSize,
  });

  @override
  Widget build(BuildContext context) {
    final painting = context.watch<PaintingProvider>();

    return RepaintBoundary(
      key: globalKey,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: GestureDetector(
              onPanStart: (details) {
                if (settings.mode == DrawingMode.sticker) {
                  return;
                }
                painting.clearUndoLine();
                painting.addLine(
                  DrawingLine(
                    mode: settings.mode,
                    points: [details.localPosition],
                    paint: Paint()
                      ..color = settings.brushColor
                      ..strokeWidth = settings.brushSize
                      ..strokeJoin = StrokeJoin.round
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  ),
                );
              },
              onPanUpdate: (details) {
                if (settings.mode == DrawingMode.sticker) {
                  return;
                }
                painting.updateLastLine(details.localPosition);
              },
              behavior: HitTestBehavior.translucent,
              child: CustomPaint(
                willChange: true,
                isComplex: true,
                painter: MyLinePainter(lines: painting.lines),
                size: Size(canvasSize, canvasSize),
              ),
            ),
          ),
          DragTarget<StickerOnCanvas>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              RenderObject? renderObj =
                  globalKey.currentContext?.findRenderObject();
              Offset widgetPosition = Offset.zero;
              if (renderObj != null) {
                RenderBox renderBox = renderObj as RenderBox;
                widgetPosition = renderBox.localToGlobal(Offset.zero);
              }
              return SizedBox(
                width: canvasSize,
                height: canvasSize,
                child: Stack(
                  children: painting.stickerOnCanvasList.map((stickerOnCanvas) {
                    return StickerTransformer(
                      painting: painting,
                      stickerOnCanvas: stickerOnCanvas,
                      parentPosition: widgetPosition,
                    );
                  }).toList(),
                ),
              );
            },
            onMove: (DragTargetDetails<StickerOnCanvas> details) {
              details.data.position =
                  Offset(details.offset.dx, details.offset.dy);
            },
            onAcceptWithDetails: (DragTargetDetails<StickerOnCanvas> details) {
              painting.addSticker(details.data);
            },
          ),
          buildBrushSizePreview(canvasSize),
        ],
      ),
    );
  }

  Widget buildBrushSizePreview(double canvasSize) {
    if (!settings.displayBrushPreview) {
      return const SizedBox.shrink();
    }

    return Consumer<SettingsProvider>(builder: (context, settings, child) {
      return SizedBox(
        width: canvasSize,
        height: canvasSize,
        child: Center(
          child: Container(
            width: settings.brushSize,
            height: settings.brushSize,
            decoration: BoxDecoration(
              color: context
                  .select((SettingsProvider painting) => painting.brushColor),
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
    });
  }
}
