import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:winter_wolf/features/my_sticker.dart';

class StickerOnCanvas {
  MySticker sticker;
  Offset position;
  double scale;
  double angle;

  StickerOnCanvas({
    required this.sticker,
    required this.position,
    required this.scale,
    required this.angle,
  });
}
