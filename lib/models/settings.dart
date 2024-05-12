import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../features/drawing_mode_nav_bar.dart';

class SettingsProvider extends ChangeNotifier {
  DrawingMode _mode = DrawingMode.drawLine;
  double _brushSize = 5;
  Color _brushColor = const Color(0xffff8484);
  Color _lastPickedColor = const Color(0xffff8484);
  bool _displayBrushPreview = false;
  bool _enableDeleteSticker = false;
  bool _aboutToDeleteSticker = false;

  final List<Color> _swatchList = [
    const Color(0xffff8484),
    const Color(0xffffd484),
    const Color(0xff9fff84),
    const Color(0xff84cbff),
    const Color(0xfff7f3ff),
    const Color(0xff3a3a3a),
  ];
  final List<String> _stickerList = [
    "assets/images/chiikawa.png",
    "assets/images/chiikawa_2.png",
    "assets/images/hachiware.png",
    "assets/images/usagi.png",
    "assets/images/usagi_2.png",
    "assets/images/momonga.png",
  ];

  DrawingMode get mode => _mode;
  double get brushSize => _brushSize;
  Color get brushColor => _brushColor;
  Color get lastPickedColor => _lastPickedColor;
  bool get displayBrushPreview => _displayBrushPreview;
  bool get enableDeleteSticker => _enableDeleteSticker;
  bool get aboutToDeleteSticker => _aboutToDeleteSticker;
  List<Color> get swatchList => _swatchList;
  List<String> get stickerList => _stickerList;

  set mode(DrawingMode mode) {
    _mode = mode;
    notifyListeners();
  }

  set brushSize(double size) {
    _brushSize = size;
    notifyListeners();
  }

  set brushColor(Color color) {
    _brushColor = color;
    notifyListeners();
  }

  set lastPickedColor(Color color) {
    _lastPickedColor = color;
    notifyListeners();
  }

  set displayBrushPreview(bool value) {
    _displayBrushPreview = value;
    notifyListeners();
  }

  set enableDeleteSticker(bool value) {
    _enableDeleteSticker = value;
    notifyListeners();
  }

  set aboutToDeleteSticker(bool value) {
    _aboutToDeleteSticker = value;
    notifyListeners();
  }

  void addSwatch(Color color) {
    _swatchList.add(color);
    notifyListeners();
  }

  void removeSwatch(int index) {
    _swatchList.removeAt(index);
    _brushColor = _swatchList.last;
    notifyListeners();
  }
}
// return Consumer<PaintingModel>(
// builder: (context, painting, child) {
// return Container();
// });
