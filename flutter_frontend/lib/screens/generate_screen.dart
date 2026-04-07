import 'package:flutter/material.dart';
import '../services/tutor_service.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';

class GenerateScreen extends StatefulWidget {
  final int userId;
  final String prompt;
  final String gender;

  const GenerateScreen({
    super.key,
    required this.userId,
    required this.prompt,
    required this.gender,
  });

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen>
    with SingleTickerProviderStateMixin {
  final TutorService _service = TutorService();

  bool loading = true;
  String scriptText = "";
  int? videoId;

  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    generateScript();

    _particleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  Future<void> generateScript() async {
    final result = await _service.generateScript(
      userId: widget.userId,
      prompt: widget.prompt,
      gender: widget.gender,
    );

    if (result != null) {
      setState(() {
        scriptText = result["script_text"];
        videoId = result["id"];
        loading = false;
      });
    }
  }

  void goToAudio() {
    Navigator.pushNamed(
      context,
      Routes.audio,
      arguments: {"videoId": videoId},
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : GlassCardScaffold(
            particleController: _particleController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 📘 HEADING
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Script Preview",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),

                /// 📜 SCRIPT BOX
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      scriptText,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// 🎧 CONTINUE BUTTON
                ElevatedButton(
                  onPressed: goToAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: const Text(
                    "Continue to Audio",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
  }
}