import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import '../routes.dart';
import '../services/tutor_service.dart';

class AudioScreen extends StatefulWidget {
  final int videoId;
  const AudioScreen({super.key, required this.videoId});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final TutorService _service = TutorService();

  bool loading = true;
  bool generatingVideo = false;

  String? audioUrl;
  bool isPlaying = false;

  late AnimationController _mouthController;
  late AnimationController _particleController;

  double tiltX = 0;
  double tiltY = 0;

  @override
  void initState() {
    super.initState();
    generateAudio();

    _mouthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);

    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
  }

  // ================= GENERATE AUDIO =================
  Future<void> generateAudio() async {
    final result = await _service.generateAudio(widget.videoId);
    if (result != null) {
      audioUrl = "http://localhost:8000${result["audio_path"]}";
      setState(() => loading = false);
    }
  }

  // ================= PLAY / PAUSE =================
  void togglePlay() async {
    if (isPlaying) {
      await _player.pause();
      _mouthController.stop();
    } else {
      await _player.play(UrlSource(audioUrl!));
      _mouthController.repeat(reverse: true);
    }
    setState(() => isPlaying = !isPlaying);
  }

  // ================= UPLOAD IMAGE + GENERATE VIDEO =================
  // ================= UPLOAD IMAGE + GENERATE VIDEO =================
  Future<void> goToVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) return;

    final file = result.files.single;

    if (file.bytes == null) {
      print("❌ File bytes are null");
      return;
    }

    setState(() => generatingVideo = true);

    try {
      // 1️⃣ Upload image
      final uploadResult = await _service.uploadImageWeb(
        widget.videoId,
        file.bytes!,
        file.name,
      );

      if (uploadResult == null) {
        print("❌ Upload failed");
        setState(() => generatingVideo = false);
        return;
      }

      print("✅ Image uploaded");

      // 2️⃣ Generate video
      final videoResult = await _service.generateVideo(widget.videoId);

      setState(() => generatingVideo = false);

      if (videoResult == null) {
        print("❌ Video generation failed");
        return;
      }

      print("VIDEO RESULT: $videoResult");

      if (videoResult["video_path"] == null) {
        print("❌ video_path is null");
        return;
      }

      final videoUrl = "http://localhost:8000${videoResult["video_path"]}";

      print("✅ Final Video URL: $videoUrl");

      Navigator.pushNamed(
        context,
        Routes.video,
        arguments: {"videoUrl": videoUrl},
      );
    } catch (e) {
      print("🚨 ERROR in goToVideo(): $e");
      setState(() => generatingVideo = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _mouthController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  tiltX = details.delta.dy * 0.01;
                  tiltY = -details.delta.dx * 0.01;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  tiltX = 0;
                  tiltY = 0;
                });
              },
              child: Stack(
                children: [
                  /// 🔵 BACKGROUND
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFB3D4FF),
                          Color(0xFFEAF3FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  /// ✨ PARTICLES
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (_, __) {
                      return CustomPaint(
                        painter: ParticlePainter(_particleController.value),
                        child: Container(),
                      );
                    },
                  ),

                  /// 🧊 GLASS CARD
                  Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(tiltX)
                        ..rotateY(tiltY),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: 330,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// 🤖 ROBOT
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset("assets/logo.png", height: 120),
                                    Positioned(
                                      bottom: 25,
                                      child: AnimatedBuilder(
                                        animation: _mouthController,
                                        builder: (_, __) {
                                          return Container(
                                            width: 30,
                                            height: isPlaying
                                                ? 5 +
                                                    (_mouthController.value *
                                                        10)
                                                : 5,
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 30),

                                /// ▶ PLAY BUTTON
                                GestureDetector(
                                  onTap: togglePlay,
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blueAccent,
                                          Color(0xFF5CA9FF)
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent,
                                          blurRadius: 20,
                                          spreadRadius: 3,
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                /// 🎬 GENERATE VIDEO BUTTON
                                generatingVideo
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: goToVideo,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 14),
                                        ),
                                        child: const Text(
                                          "Upload Image & Generate Video",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// 🌟 PARTICLES
class ParticlePainter extends CustomPainter {
  final double progress;
  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent.withOpacity(0.2);

    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i / 20)) + sin(progress * 2 * pi + i) * 20;
      final y = size.height * progress;
      canvas.drawCircle(Offset(x, y % size.height), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
