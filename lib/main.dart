import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const FigmaLoginLab());
}

class FigmaLoginLab extends StatelessWidget {
  const FigmaLoginLab({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
