import 'dart:math';
import 'package:flutter/material.dart';

class ScriptParticlePainter extends CustomPainter {
  final double progress;
  ScriptParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent.withOpacity(0.15);

    for (int i = 0; i < 15; i++) {
      final x = (size.width * (i / 15)) + sin(progress * 2 * pi + i) * 20;
      final y = size.height * progress;
      canvas.drawCircle(Offset(x, y % size.height), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}