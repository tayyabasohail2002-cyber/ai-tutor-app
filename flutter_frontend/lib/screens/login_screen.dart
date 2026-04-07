import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../routes.dart';
import '../widgets/glass_card_scaffold.dart';
import 'app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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

  void loginUser() async {
    setState(() => isLoading = true);
    final result = await api.login(
        emailController.text.trim(), passwordController.text.trim());
    setState(() => isLoading = false);

    if (result != null && result["user_id"] != null) {
      Navigator.pushReplacementNamed(
        context,
        Routes.hello,
        arguments: {"userId": result["user_id"]},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Email or Password")),
      );
    }
  }

  void goToRegister() {
    Navigator.pushNamed(context, Routes.register);
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
                  onPressed: loginUser,
                  style: AppStyles.primaryButtonStyle(horizontal: 80),
                  child: const Text("Login"),
                ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: goToRegister,
            child: const Text(
              "Don't have an account? Register",
              style: TextStyle(color: AppStyles.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}