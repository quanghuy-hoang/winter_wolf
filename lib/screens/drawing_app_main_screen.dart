import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:winter_wolf/features/canvas_zone.dart';
import 'package:winter_wolf/screens/result_screen.dart';
import 'package:winter_wolf/utils/save_to_gallery.dart';
import '../features/action_bar.dart';
import '../features/drawing_mode_nav_bar.dart';
import '../features/tools_contents.dart';
import '../utils/utils.dart';

class DrawingAppMainScreen extends StatefulWidget {
  const DrawingAppMainScreen({super.key});

  @override
  State<DrawingAppMainScreen> createState() => _DrawingAppMainScreenState();
}

class _DrawingAppMainScreenState extends State<DrawingAppMainScreen> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    const double canvasPadding = 64.0;
    final double canvasSize = deviceWidth - canvasPadding;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyTextButton(
                    text: "test 2",
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  MyTextButton(
                    text: "save",
                    onPressed: () async {
                      Uint8List? imageData =
                          await createImageDataFromRepaintBoundary(
                        _key,
                        context: context,
                      );
                      if (imageData != null) {
                        showSaveToGalleryAlert(imageData);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const DrawingModeNavBar(),
              const SizedBox(height: 16),
              const ActionBar(),
              const SizedBox(height: 16),
              Stack(
                children: [
                  CanvasZone(
                    globalKey: _key,
                    canvasSize: canvasSize,
                  ),
                  BrushSizePreview(
                    canvasSize: canvasSize,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const ToolsContents(),
            ],
          ),
        ),
      ),
    );
  }

  void showSaveToGalleryAlert(Uint8List imageData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(24),
            content: Image.memory(imageData),
            actionsPadding: const EdgeInsets.all(12),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            actions: [
              MyTextButton(
                text: "cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MyTextButton(
                text: "save to gallery",
                onPressed: () {
                  saveImageDataToGallery(imageData);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
