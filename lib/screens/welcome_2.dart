import 'package:flutter/material.dart';
import 'welcome_3.dart'; // Import the next screen

class Welcome2Screen extends StatelessWidget {
  const Welcome2Screen({super.key});

  // A helper function to build the page indicator dots
  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 6.0,
      width: isActive ? 24.0 : 6.0, // Active dot is longer
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to be transparent to show the body's gradient
      backgroundColor: Colors.transparent,
      body: Container(
        // 1. Apply a Linear Gradient for the pink/purple background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Matching the pink, purple, and blue tones from the image
            colors: [
              Color(0xFFffb5d7), // Light Pink/Purple top
              Color(0xFFa29bfe), // Mid-range Blue/Purple
              Color(
                0xFFffdfe6,
              ), // Light Pink bottom (subtle hint of the first screen)
            ],
            // Start the gradient at the top and end at the bottom
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // Pushes content down slightly
              // --- Circular Icon Container ---
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(
                    0.15,
                  ), // Semi-transparent white
                  border: Border.all(
                    color: Colors.white.withOpacity(
                      0.3,
                    ), // Fainter white border
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.groups_outlined, // Icon representing connection/users
                  size: 70.0,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 1),

              // --- Main Heading Text ---
              const Text(
                'Connect safely with finders',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15.0),

              // --- Subtitle Text ---
              const Text(
                'Secure messaging system to coordinate item returns with verified students',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const Spacer(flex: 2),

              // --- Page Indicator Dots ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildPageIndicator(false),
                  _buildPageIndicator(true), // Active (longer) dot
                  _buildPageIndicator(false),
                ],
              ),

              const SizedBox(height: 25.0),

              // --- Next Button ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // *** NAVIGATION ADDED HERE ***
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Welcoming3(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          // Using a deep purple/blue color for the text/icon for contrast
                          color: Color(0xFF4854a0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFF4854a0),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // --- Skip Link ---
              TextButton(
                onPressed: () {
                  // TODO: Implement skip functionality, e.g., navigate to the home screen
                  print('Skip pressed');
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),

              const Spacer(flex: 1), // Final bottom space
            ],
          ),
        ),
      ),
    );
  }
}
