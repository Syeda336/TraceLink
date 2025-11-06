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
            colors: [Color(0xFFffb5d7), Color(0xFFa29bfe), Color(0xFF81e6d9)],
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.favorite,
                    size: 60.0,
                    color: Color(0xFFff7979),
                  ),
                ),
                color: Color(0xFFffdfe6),
              ),

              SizedBox(height: 25.0),

              // --- Main Title Text ---
              Text(
                'Lost & Found',
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
