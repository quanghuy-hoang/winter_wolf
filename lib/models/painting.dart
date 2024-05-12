import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../features/drawing_line.dart';
import '../features/sticker_on_canvas.dart';

class PaintingProvider extends ChangeNotifier {
  final List<DrawingLine> _lines = [];
  final List<DrawingLine> _undoStack = [];
  final List<StickerOnCanvas> _stickerOnCanvasList = [];
  StickerOnCanvas? _selectedSticker;
  Offset? _originHandlerPosition;
  Offset? _originRotatorPosition;

  List<DrawingLine> get lines => _lines;
  List<DrawingLine> get undoStack => _undoStack;
  List<StickerOnCanvas> get stickerOnCanvasList => _stickerOnCanvasList;
  StickerOnCanvas? get selectedSticker => _selectedSticker;
  Offset? get originHandlerPosition => _originHandlerPosition;
  Offset? get originRotatorPosition => _originRotatorPosition;

  void addLine(DrawingLine line) {
    _lines.add(line);
    notifyListeners();
  }

  void updateLastLine(Offset point) {
    // reduce sampling of very close neighbour point
    if ((point - _lines.last.points.last).distance < 4) {
      return;
    }
    _lines.last.points.add(point);
    notifyListeners();
  }

  void clearLine() {
    _lines.clear();
    notifyListeners();
  }

  void removeLastLine() {
    _lines.removeLast();
    notifyListeners();
  }

  void addUndoLine(DrawingLine line) {
    _undoStack.add(line);
    notifyListeners();
  }

  void clearUndoLine() {
    _undoStack.clear();
    notifyListeners();
  }

  void removeLastUndoLine() {
    _undoStack.removeLast();
    notifyListeners();
  }

  void addSticker(StickerOnCanvas sticker) {
    _stickerOnCanvasList.add(sticker);
    notifyListeners();
  }

  void removeSticker(StickerOnCanvas sticker) {
    _stickerOnCanvasList.removeAt(_stickerOnCanvasList.indexOf(sticker));
    notifyListeners();
  }

  void clearSticker() {
    _stickerOnCanvasList.clear();
    notifyListeners();
  }

  set selectedSticker(StickerOnCanvas? sticker) {
    _selectedSticker = sticker;
    notifyListeners();
  }

  set originHandlerPosition(Offset? position) {
    _originHandlerPosition = position;
    notifyListeners();
  }

  set originRotatorPosition(Offset? position) {
    _originRotatorPosition = position;
    notifyListeners();
  }

  void scaleSelectedSticker(double currentScale, double factor) {
    const resizeThreshold = 0.05;
    if (factor > resizeThreshold) factor = resizeThreshold;
    if (factor < -resizeThreshold) factor = -resizeThreshold;
    if (currentScale + factor < 0.5 || currentScale + factor > 3) {
      return;
    }
    if (_selectedSticker == null) {
      return;
    }
    _stickerOnCanvasList[_stickerOnCanvasList.indexOf(_selectedSticker!)]
        .scale = currentScale + factor;
    notifyListeners();
  }

  void rotateSelectedSticker(double angle) {
    if (_selectedSticker == null) {
      return;
    }
    _stickerOnCanvasList[_stickerOnCanvasList.indexOf(_selectedSticker!)]
        .angle += angle;
    notifyListeners();
  }
}
