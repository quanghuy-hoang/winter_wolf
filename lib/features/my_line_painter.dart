import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:winter_wolf/features/drawing_mode_nav_bar.dart';
import 'drawing_line.dart';

class MyLinePainter extends CustomPainter {
  List<DrawingLine> lines;
  MyLinePainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);

    int count = 0;

    for (var line in lines) {
      int pointCount = line.points.length;
      count += pointCount;
      for (var i = 0; i < pointCount; i++) {
        Offset currentPoint = line.points[i];
        Offset? nextPoint = i != pointCount - 1 ? line.points[i + 1] : null;
        switch (line.mode) {
          case DrawingMode.drawLine || DrawingMode.erase || DrawingMode.sticker:
            if (nextPoint != null) {
              canvas.drawLine(currentPoint, nextPoint, line.paint);
            } else {
              canvas.drawPoints(PointMode.points, [currentPoint], line.paint);
            }
          case DrawingMode.paint:
            canvas.drawPaint(line.paint);
          case DrawingMode.drawPoint:
            canvas.drawPoints(PointMode.points, [currentPoint], line.paint);
        }
      }
    }
    print(count);
  }

  @override
  bool shouldRepaint(MyLinePainter oldDelegate) {
    return true;
  }
}
