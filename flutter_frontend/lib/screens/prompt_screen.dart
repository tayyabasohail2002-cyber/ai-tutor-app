import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';

class PromptScreen extends StatefulWidget {
  final int userId;
  const PromptScreen({super.key, required this.userId});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();

  void goNext() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a topic")));
      return;
    }
    Navigator.pushNamed(context, Routes.tutorSetup, arguments: {"userId": widget.userId, "prompt": prompt});
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(tag: "robotHero", child: Image.asset("assets/logo.png", height: 80)),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Enter topic...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}