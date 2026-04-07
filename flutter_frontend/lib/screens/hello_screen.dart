import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';

class HelloScreen extends StatelessWidget {
  final int userId;
  const HelloScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(tag: "robotHero", child: Image.asset("assets/logo.png", height: 120)),
          const SizedBox(height: 40),
          const Text(
            "Your intelligent learning companion.\nGenerate AI-powered study scripts instantly.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.prompt,
                arguments: {"userId": userId},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Start Learning"),
          ),
        ],
      ),
    );
  }
}