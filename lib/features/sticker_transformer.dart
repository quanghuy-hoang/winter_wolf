import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/features/sticker_handler.dart';
import 'package:winter_wolf/features/sticker_on_canvas.dart';
import 'package:winter_wolf/models/painting.dart';
import 'package:winter_wolf/models/settings.dart';

class StickerTransformer extends StatelessWidget {
  final PaintingProvider painting;
  final StickerOnCanvas stickerOnCanvas;
  final Offset parentPosition;
  const StickerTransformer({
    super.key,
    required this.painting,
    required this.stickerOnCanvas,
    required this.parentPosition,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = painting.selectedSticker == stickerOnCanvas;
    double originalSize = stickerOnCanvas.sticker.size;
    double currentSize = originalSize * stickerOnCanvas.scale;
    double paddingOfScale =
        currentSize > originalSize ? ((currentSize - originalSize) / 2) : 0;
    double leftDistance =
        stickerOnCanvas.position.dx - parentPosition.dx - paddingOfScale;
    double topDistance =
        stickerOnCanvas.position.dy - parentPosition.dy - paddingOfScale;
    return Positioned(
      left: leftDistance,
      top: topDistance,
      child: GestureDetector(
        onTap: () {
          painting.originHandlerPosition = Offset(
            leftDistance + currentSize,
            topDistance + currentSize,
          );
          painting.originRotatorPosition = Offset(
            leftDistance + currentSize,
            topDistance,
          );
          if (painting.selectedSticker == stickerOnCanvas) {
            painting.selectedSticker = null;
          } else {
            painting.selectedSticker = stickerOnCanvas;
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Draggable<StickerOnCanvas>(
              feedback: Transform.scale(
                scale: stickerOnCanvas.scale,
                child: Transform.rotate(
                  angle: stickerOnCanvas.angle,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.pinkAccent.shade100.withOpacity(0.5),
                        BlendMode.srcATop),
                    child: stickerOnCanvas.sticker,
                  ),
                ),
              ),
              childWhenDragging: Container(),
              data: stickerOnCanvas,
              child: Transform.scale(
                scale: stickerOnCanvas.scale,
                child: Transform.rotate(
                  angle: stickerOnCanvas.angle,
                  child: stickerOnCanvas.sticker,
                ),
              ),
              onDragStarted: () {
                context.read<SettingsProvider>().enableDeleteSticker = true;
                painting.selectedSticker = null;
              },
              onDragCompleted: () {
                context.read<SettingsProvider>().enableDeleteSticker = false;
                painting.selectedSticker = painting.stickerOnCanvasList.last;
                painting.removeSticker(stickerOnCanvas);
              },
            ),
            SizedBox(
              width: currentSize,
              height: currentSize,
              child: !isSelected
                  ? null
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Draggable(
                        onDragUpdate: (details) {
                          if (painting.originHandlerPosition == null) {
                            return;
                          }
                          Offset handlerOffset = Offset(
                            details.localPosition.dx - parentPosition.dx,
                            details.localPosition.dy - parentPosition.dy,
                          );
                          double distanceX = handlerOffset.dx -
                              painting.originHandlerPosition!.dx;
                          double distanceY = handlerOffset.dy -
                              painting.originHandlerPosition!.dy;
                          double vector =
                              sqrt(pow(distanceX, 2) + pow(distanceY, 2));
                          double vectorOfSize =
                              sqrt(pow(currentSize, 2) + pow(currentSize, 2));
                          double factor = vector / vectorOfSize;
                          double currentScale = currentSize / originalSize;
                          if (distanceX > 0 && distanceY > 0) {
                            painting.scaleSelectedSticker(currentScale, factor);
                          }
                          if (distanceX < 0 && distanceY < 0) {
                            painting.scaleSelectedSticker(
                                currentScale, -factor);
                          }
                        },
                        onDragEnd: (details) {
                          painting.originHandlerPosition = Offset(
                            leftDistance + currentSize,
                            topDistance + currentSize,
                          );
                        },
                        feedback: const StickerHandler(
                          color: Colors.blueAccent,
                          icon: Icons.open_in_full,
                        ),
                        childWhenDragging: Container(),
                        child: const StickerHandler(
                          color: Colors.blueAccent,
                          icon: Icons.open_in_full,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: currentSize,
              height: currentSize,
              child: !isSelected
                  ? null
                  : Align(
                      alignment: Alignment.topRight,
                      child: Draggable(
                        onDragUpdate: (details) {
                          if (painting.originRotatorPosition == null) {
                            return;
                          }
                          Offset handlerOffset = Offset(
                            details.localPosition.dx - parentPosition.dx,
                            details.localPosition.dy - parentPosition.dy,
                          );
                          double distanceX = handlerOffset.dx -
                              painting.originRotatorPosition!.dx;
                          double distanceY = handlerOffset.dy -
                              painting.originRotatorPosition!.dy;

                          if (distanceX > 0 || distanceY > 0) {
                            painting.rotateSelectedSticker(0.02);
                          }
                          if (distanceX < 0 || distanceY < 0) {
                            painting.rotateSelectedSticker(-0.02);
                          }
                        },
                        onDragEnd: (details) {
                          painting.originRotatorPosition = Offset(
                            leftDistance + currentSize,
                            topDistance,
                          );
                        },
                        feedback: const StickerHandler(
                          color: Colors.lightGreen,
                          icon: Icons.replay,
                        ),
                        childWhenDragging: Container(),
                        child: const StickerHandler(
                          color: Colors.lightGreen,
                          icon: Icons.replay,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
