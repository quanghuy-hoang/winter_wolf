import 'dart:ui';

import 'drawing_mode_nav_bar.dart';

class DrawingLine {
  DrawingMode mode;
  List<Offset> points;
  Paint paint;

  DrawingLine({required this.mode, required this.points, required this.paint});
}
