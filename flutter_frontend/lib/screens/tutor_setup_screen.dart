import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';

class TutorSetupScreen extends StatefulWidget {
  final int userId;
  final String prompt;
  const TutorSetupScreen({super.key, required this.userId, required this.prompt});

  @override
  State<TutorSetupScreen> createState() => _TutorSetupScreenState();
}

class _TutorSetupScreenState extends State<TutorSetupScreen> {
  String gender = "male";

  void goNext() {
    Navigator.pushNamed(context, Routes.generate, arguments: {
      "userId": widget.userId,
      "prompt": widget.prompt,
      "gender": gender
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(tag: "robotHero", child: Image.asset("assets/logo.png", height: 80)),
          const SizedBox(height: 20),
          RadioListTile(
            value: "male",
            groupValue: gender,
            title: const Text("Male"),
            onChanged: (v) => setState(() => gender = v!),
          ),
          RadioListTile(
            value: "female",
            groupValue: gender,
            title: const Text("Female"),
            onChanged: (v) => setState(() => gender = v!),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Generate Script"),
          ),
        ],
      ),
    );
  }
}