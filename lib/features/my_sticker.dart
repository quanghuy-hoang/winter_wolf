import 'package:flutter/material.dart';
import 'package:winter_wolf/features/sticker_on_canvas.dart';

class MySticker extends StatefulWidget {
  final String imagePath;
  final double size;
  const MySticker({
    super.key,
    required this.imagePath,
    required this.size,
  });

  @override
  State<MySticker> createState() => _MyStickerState();
}

class _MyStickerState extends State<MySticker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        width: widget.size,
        height: widget.size,
        widget.imagePath,
      ),
    );
  }
}

class DraggableSticker extends StatelessWidget {
  final StickerOnCanvas stickerOnCanvas;
  const DraggableSticker({
    super.key,
    required this.stickerOnCanvas,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: Draggable<StickerOnCanvas>(
          data: stickerOnCanvas,
          feedback: stickerOnCanvas.sticker,
          childWhenDragging: SizedBox(
            height: stickerOnCanvas.sticker.size,
            width: stickerOnCanvas.sticker.size,
          ),
          child: SizedBox(
            height: stickerOnCanvas.sticker.size,
            width: stickerOnCanvas.sticker.size,
            child: stickerOnCanvas.sticker,
          ),
        ),
      ),
    );
  }
}
