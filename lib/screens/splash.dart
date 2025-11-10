import 'dart:async'; // Import for using Timer
import 'package:flutter/material.dart';

// In welcome.dart, change the import to:
import 'package:tracelink/screens/welcome_1.dart';

// Change StatelessWidget to StatefulWidget to manage the timer logic
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Declare a Timer variable
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 1. Start the navigation logic when the widget is created
    _startTimer();
  }

  void _startTimer() {
    // 2. Set the timer to navigate after 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      // 3. Navigate to the Welcome1Screen and remove the current screen from the stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Welcome1Screen()),
      );
    });
  }

  @override
  void dispose() {
    // 4. IMPORTANT: Cancel the timer when the widget is removed
    // to prevent memory leaks or crashes.
    _timer?.cancel();
    super.dispose();
  }

  // The UI remains the same as the original design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Bright blue theme
            colors: [Color(0xFF87CEEB), Color(0xFF1E90FF), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Icon Card ---
              Material(
                elevation: 4,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: Color(0xFFE0FFFF),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    // Changed icon to 'track_changes'
                    Icons.track_changes,
                    size: 60.0,
                    color: Color(0xFF1E90FF), // A bright blue color
                  ),
                ), // A light blue background for the icon
              ),

              SizedBox(height: 25.0),

              // --- Main Title Text ---
              Text(
                'TraceLink', // Changed from 'Lost & Found'
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.0),

              // --- Subtitle Text ---
              Text(
                'Find. Return. Earn Rewards.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
