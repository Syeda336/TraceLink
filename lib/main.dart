import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: FigmaLoginLab(),
    ),
  );
}

class FigmaLoginLab extends StatelessWidget {
  const FigmaLoginLab({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
