import 'package:flutter/material.dart';
import 'home.dart';

class SubmittedClaimScreen extends StatefulWidget {
  const SubmittedClaimScreen({super.key});

  @override
  State<SubmittedClaimScreen> createState() => _SubmittedClaimScreenState();
}

class _SubmittedClaimScreenState extends State<SubmittedClaimScreen>
    with SingleTickerProviderStateMixin {
  // Controller for managing the animation
  late AnimationController _controller;
  // Animation that provides the value for the slight up/down movement
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 700,
      ), // Duration of one loop (up and down)
      vsync: this,
    )..repeat(reverse: true); // Make it repeat, alternating directions

    // 2. Define the animation for movement (from 0 to -15 pixels)
    _animation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth start and end for the movement
      ),
    );

    // 3. Set a timer to close the screen and navigate after 3 seconds
    _navigateToHome();
  }

  // Function to handle the auto-close and navigation
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      // Check if the widget is still mounted before navigating
      if (mounted) {
        // Navigate to HomeScreen and replace all previous routes
        // (so the user can't press back to this success screen)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    // Crucially, dispose the controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the gradient colors based on the image
    const Color startColor = Color(0xFF2DCF83); // Lighter green/teal
    const Color endColor = Color(0xFF00C6FF); // Cyan/blueish

    return Scaffold(
      // The background is the full-screen gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // AnimatedBuilder constantly rebuilds the child based on the animation value
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    // Apply the vertical translation for the up/down movement
                    offset: Offset(0, _animation.value),
                    child: child,
                  );
                },
                // The checkmark icon is the child that gets animated
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF2DCF83), // Match the primary green color
                      size: 70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Claim Submitted text
              const Text(
                'Claim Submitted!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Description text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'The owner will review your claim and contact you soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
