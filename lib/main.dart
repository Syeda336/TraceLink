import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'firebase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // REPLACE these placeholders with your actual project URL and Anon Key
    url: 'https://tzusprdkforqtgfptqjy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6dXNwcmRrZm9ycXRnZnB0cWp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMjkwMTIsImV4cCI6MjA3OTcwNTAxMn0.qiuc29ki4oJU5GjwtciDjtd-E9oC9oC9NDVGY_aIGuA',
  );
  // Raza#148564

  await FirebaseService.initialize();

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

final supabase = Supabase.instance.client;
