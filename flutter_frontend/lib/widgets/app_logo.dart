import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Logo",
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.blue[700],
      ),
    );
  }
}
