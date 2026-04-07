import 'dart:ui';
import 'package:flutter/material.dart';
import 'particle_painter.dart';

class GlassCardScaffold extends StatelessWidget {
  final Widget child;
  final AnimationController? particleController;

  const GlassCardScaffold({
    super.key,
    required this.child,
    this.particleController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 GRADIENT BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB3D4FF), Color(0xFFEAF3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// ✨ PARTICLES
          if (particleController != null)
            AnimatedBuilder(
              animation: particleController!,
              builder: (_, __) {
                return CustomPaint(
                  painter: ScriptParticlePainter(particleController!.value),
                  child: Container(),
                );
              },
            ),

          /// 🧊 GLASS CARD CENTER
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}