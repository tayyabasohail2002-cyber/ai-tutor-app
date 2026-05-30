import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/glass_card_scaffold.dart';

Future<void> openVideo(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

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

  double volume = 1.0;
  double speed = 1.0;

  late AnimationController _replayAnimation;

  @override
  void initState() {
    super.initState();

    /// ✅ FIX URL
    String fullUrl = widget.videoUrl.trim();

    if (fullUrl.contains("http://localhost") && fullUrl.contains("https://")) {
      fullUrl = fullUrl.substring(fullUrl.indexOf("https://"));
    }

    print("🎬 FINAL VIDEO URL: $fullUrl");

    _controller = VideoPlayerController.networkUrl(Uri.parse(fullUrl))
      ..initialize().then((_) {
        setState(() => isLoading = false);
        _controller!.setLooping(false);
        _controller!.play();
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
      } else {
        _controller!.play();
        isPlaying = true;
      }
    });
  }

  void changeVolume(double v) {
    volume = v;
    _controller?.setVolume(v);
    setState(() {});
  }

  void changeSpeed(double s) {
    speed = s;
    _controller?.setPlaybackSpeed(s);
    setState(() {});
  }

  void downloadVideo() {
    String url = widget.videoUrl;

    if (url.contains("http://localhost") && url.contains("https://")) {
      url = url.substring(url.indexOf("https://"));
    }

    openVideo(url);
  }

  void shareVideo() {
    Share.share(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      child: Column(
        children: [
          /// 🎬 FULL WIDTH VIDEO (TOP)
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),

          if (!isLoading && _controller != null)
            GestureDetector(
              onTap: togglePlay,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),

                    /// ▶ Play Icon
                    if (!isPlaying)
                      Icon(
                        Icons.play_circle_fill,
                        size: 80,
                        color: Colors.white.withOpacity(0.8),
                      ),

                    /// 📊 Progress Bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          /// 📦 CONTROLS AT BOTTOM
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// ▶ PLAY BUTTON
                  ElevatedButton(
                    onPressed: togglePlay,
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

                  /// ⚡ SPEED
                  const Text("Speed"),
                  DropdownButton<double>(
                    value: speed,
                    items: const [
                      DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                      DropdownMenuItem(value: 1.0, child: Text("1x")),
                      DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                      DropdownMenuItem(value: 2.0, child: Text("2x")),
                    ],
                    onChanged: (v) {
                      if (v != null) changeSpeed(v);
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 📤 ACTIONS
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
          ),
        ],
      ),
    );
  }
}
