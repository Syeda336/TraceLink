import 'package:flutter/material.dart';
import 'login_screen.dart'; // ✅ make sure this file exists and defines HomeScreen()

// Note: Removed the main() and FigmaToCodeApp classes as they weren't requested for modification
// and the Welcoming3 class is the focus of the theme change.

class Welcoming3 extends StatelessWidget {
  const Welcoming3({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the primary bright blue color for consistent use
    const Color primaryBrightBlue = Color(0xFF1E90FF); // Dodger Blue
    const Color deepBlueText = Color(0xFF005BAC); // Darker blue for contrast
    const Color lightCyan = Color(
      0xFF00CED1,
    ); // Dark Turquoise (for gradient top)
    const Color azureBlue = Color(0xFF007FFF); // Azure (for gradient bottom)

    return Scaffold(
      backgroundColor: Colors.transparent, // Set to transparent
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // 1. Apply a Linear Gradient for the bright blue background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Updated to bright blue theme
            colors: [lightCyan, primaryBrightBlue, azureBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(), // Push content to vertical center
              // 💙 Center Circle + Texts
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: ShapeDecoration(
                      // Used standard Flutter method withOpacity for transparency
                      color: Colors.white.withOpacity(0.30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons
                            .emoji_events_outlined, // Changed icon to a Trophy/Reward
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Earn rewards for helping others',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Increased font size for title prominence
                      fontWeight: FontWeight.bold,
                      // Removed explicit fontFamily: 'Arimo' if not globally defined
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Build your reputation and earn badges by helping return lost items',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xE5FFFFFF), // Nearly white subtitle text
                        fontSize: 16,
                        // Removed explicit fontFamily: 'Arimo'
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(), // Push button to bottom
              // 🔘 Dots + Get Started Button
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(alpha: 0.4),
                      const SizedBox(width: 8),
                      _buildDot(alpha: 0.4),
                      const SizedBox(width: 8),
                      _buildDot(
                        width: 32,
                        alpha: 1.0,
                      ), // Active dot (last screen)
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: InkWell(
                      onTap: () {
                        // 2. Navigation logic: Go to the home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 55.99,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              // Updated text color to match the bright blue theme
                              color: deepBlueText,
                              fontSize: 18, // Increased font size slightly
                              // Removed explicit fontFamily: 'Arimo'
                              fontWeight: FontWeight.bold, // Made text bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({double width = 8, double alpha = 0.4}) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        // Used standard Flutter method withOpacity for transparency
        color: Colors.white.withOpacity(alpha),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

// Re-including the original main and app wrapper for completeness,
// using the corrected Welcoming3 class
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ remove debug banner
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Welcoming3(), // ✅ show this screen directly
    );
  }
}

void main() {
  runApp(const FigmaToCodeApp());
}
