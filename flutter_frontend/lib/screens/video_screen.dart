import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/glass_card_scaffold.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({super.key, required this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool isLoading = true;
  bool isPlaying = true;
  bool showMiniPlayer = false;

  double volume = 1.0;
  double playbackSpeed = 1.0;

  late AnimationController _replayAnimation;

  @override
  void initState() {
    super.initState();

    String fullUrl = widget.videoUrl.startsWith("http")
        ? widget.videoUrl
        : "http://localhost:8000${widget.videoUrl}";

    _controller = VideoPlayerController.networkUrl(Uri.parse(fullUrl))
      ..initialize().then((_) {
        setState(() => isLoading = false);
        _controller!.setLooping(false);
        _controller!.play();
      });

    _controller!.addListener(() {
      if (_controller!.value.position >= _controller!.value.duration) {
        _replayAnimation.forward(from: 0);
      }
    });

    _replayAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _replayAnimation.dispose();
    super.dispose();
  }

  void togglePlay() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        isPlaying = false;
        showMiniPlayer = true;
      } else {
        _controller!.play();
        isPlaying = true;
        showMiniPlayer = false;
      }
    });
  }

  void changeVolume(double value) {
    volume = value;
    _controller?.setVolume(volume);
    setState(() {});
  }

  void changeSpeed(double value) {
    playbackSpeed = value;
    _controller?.setPlaybackSpeed(playbackSpeed);
    setState(() {});
  }

  void downloadVideo() {
    if (kIsWeb) {
      html.AnchorElement(
        href: widget.videoUrl.startsWith("http")
            ? widget.videoUrl
            : "http://localhost:8000${widget.videoUrl}",
      )
        ..setAttribute("download", "ai_tutor_video.mp4")
        ..click();
    }
  }

  void shareVideo() {
    Share.share(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            /// 🎬 VIDEO THUMBNAIL / PLAYER
            if (isLoading)
              Container(
                height: 250,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            if (!isLoading && _controller != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth > 900
                        ? 900
                        : constraints.maxWidth * 0.95,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller!),
                          VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            padding: const EdgeInsets.all(8),
                          ),

                          /// 🔁 Replay Icon
                          AnimatedBuilder(
                            animation: _replayAnimation,
                            builder: (_, __) {
                              return Opacity(
                                opacity: _replayAnimation.value,
                                child: const Icon(
                                  Icons.replay_circle_filled,
                                  size: 80,
                                  color: Colors.white70,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            /// ▶ PLAY / PAUSE
            ElevatedButton(
              onPressed: togglePlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(isPlaying ? "Pause" : "Play"),
            ),

            const SizedBox(height: 20),

            /// 🔊 VOLUME
            const Text("Volume"),
            Slider(
              value: volume,
              min: 0,
              max: 1,
              onChanged: changeVolume,
            ),

            /// ⏩ PLAYBACK SPEED
            const Text("Playback Speed"),
            DropdownButton<double>(
              value: playbackSpeed,
              items: const [
                DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                DropdownMenuItem(value: 1.0, child: Text("1x")),
                DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                DropdownMenuItem(value: 2.0, child: Text("2x")),
              ],
              onChanged: (value) {
                if (value != null) changeSpeed(value);
              },
            ),

            const SizedBox(height: 20),

            /// 📥 DOWNLOAD + SHARE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: downloadVideo,
                  child: const Text("Download"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: shareVideo,
                  child: const Text("Share"),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
