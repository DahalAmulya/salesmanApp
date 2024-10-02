import 'dart:typed_data';
import 'package:flutter/material.dart';

class CircularImagePainter extends CustomPainter {
  final Uint8List imageBytes;
  final double width;

  CircularImagePainter({required this.imageBytes, required this.width});

  @override
  void paint(Canvas canvas, Size size) async {
    final paint = Paint()..isAntiAlias = true;
    final image = await decodeImageFromList(imageBytes);

    // Define the circle bounds
    final Rect rect = Rect.fromCircle(
        center: Offset(width / 2, width / 2), radius: width / 2);

    // Create a circular clip path
    final Path path = Path()..addOval(rect);

    // Clip the canvas to the circular path
    canvas.clipPath(path);

    // Draw the image inside the circular area
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        rect,
        paint);
  }

  @override
  bool shouldRepaint(CircularImagePainter oldDelegate) {
    return oldDelegate.imageBytes != imageBytes;
  }
}
