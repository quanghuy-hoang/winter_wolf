import 'package:flutter/material.dart';

class StickerHandler extends StatelessWidget {
  final IconData icon;
  final Color color;
  const StickerHandler({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          icon,
          size: 24,
          color: color,
        ),
      ),
    );
  }
}
