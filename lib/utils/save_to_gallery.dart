import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';

Future<Uint8List?> createImageDataFromRepaintBoundary(
  GlobalKey boundaryKey, {
  double? pixelRatio,
  Size? imageSize,
  context,
}) async {
  assert(
    boundaryKey.currentContext?.findRenderObject() is RenderRepaintBoundary,
  );
  final RenderRepaintBoundary boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  final BoxConstraints constraints = boundary.constraints;
  double? outputRatio = pixelRatio;
  if (imageSize != null) {
    outputRatio = imageSize.width / constraints.maxWidth;
  }
  final ui.Image image = await boundary.toImage(
    pixelRatio: outputRatio ?? View.of(context).devicePixelRatio,
  );
  final ByteData? byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData?.buffer.asUint8List();
}

Future<void> saveImageDataToGallery(Uint8List imageData) async {
  await Gal.putImageBytes(imageData);
}
