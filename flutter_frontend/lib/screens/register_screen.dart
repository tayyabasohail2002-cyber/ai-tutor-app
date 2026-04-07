import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';
import 'app_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService api = ApiService();
  bool isLoading = false;

  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void registerUser() async {
    setState(() => isLoading = true);
    final result = await api.register(
        emailController.text.trim(), passwordController.text.trim());
    setState(() => isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Registration Successful")));
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User already exists or Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardScaffold(
      particleController: _particleController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(tag: "robotHero", child: Image.asset("assets/logo.png", height: 120)),
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            decoration: AppStyles.inputDecoration(label: "Email"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: AppStyles.inputDecoration(label: "Password"),
          ),
          const SizedBox(height: 30),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: registerUser,
                  style: AppStyles.primaryButtonStyle(horizontal: 80),
                  child: const Text("Register"),
                ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: AppStyles.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}