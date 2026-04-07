import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/hello_screen.dart';
import 'screens/prompt_screen.dart';
import 'screens/tutor_setup_screen.dart';
import 'screens/generate_screen.dart';
import 'screens/audio_screen.dart';
import 'screens/video_screen.dart';

class Routes {
  static const String hello = '/hello';
  static const String login = '/login';
  static const String register = '/register';
  static const String prompt = '/prompt';
  static const String tutorSetup = '/tutorSetup';
  static const String generate = '/generate';
  static const String audio = '/audio';
  static const String video = '/video';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // ---------------- LOGIN ----------------
      login: (context) => const LoginScreen(),

      // ---------------- REGISTER ----------------
      register: (context) => const RegisterScreen(),

      // ---------------- HELLO ----------------
      hello: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["userId"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Hello arguments")),
          );
        }

        return HelloScreen(userId: args["userId"]);
      },

      // ---------------- PROMPT ----------------
      prompt: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["userId"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Prompt arguments")),
          );
        }

        return PromptScreen(userId: args["userId"]);
      },

      // ---------------- TUTOR SETUP ----------------
      tutorSetup: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["userId"] == null || args["prompt"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Tutor Setup arguments")),
          );
        }

        return TutorSetupScreen(
          userId: args["userId"],
          prompt: args["prompt"],
        );
      },

      // ---------------- GENERATE SCRIPT ----------------
      generate: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["userId"] == null || args["prompt"] == null || args["gender"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Generate arguments")),
          );
        }

        return GenerateScreen(
          userId: args["userId"],
          prompt: args["prompt"],
          gender: args["gender"],
        );
      },

      // ---------------- AUDIO ----------------
      audio: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["videoId"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Audio arguments")),
          );
        }

        return AudioScreen(videoId: args["videoId"]);
      },

      // ---------------- VIDEO ----------------
      video: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args == null || args["videoUrl"] == null) {
          return const Scaffold(
            body: Center(child: Text("Missing Video arguments")),
          );
        }

        return VideoScreen(videoUrl: args["videoUrl"]);
      },
    };
  }
}