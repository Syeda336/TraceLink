import 'package:flutter/material.dart';
// 1. Import the target screen file
import 'welcome_2.dart';

class Welcome1Screen extends StatelessWidget {
  const Welcome1Screen({super.key});

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
    // Define the primary bright blue color for consistent use
    const Color primaryBrightBlue = Color(0xFF00BFFF); // Deep Sky Blue
    // Cyan

    return Scaffold(
      // Set the background color to be transparent to show the body's gradient
      backgroundColor: Colors.transparent,
      body: Container(
        // 1. Apply a Linear Gradient for the bright blue background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Updated to brighter, more vibrant blue/cyan tones
            colors: [
              Color(0xFF00CED1), // Dark Turquoise (Light top)
              Color(0xFF1E90FF), // Dodger Blue (Mid)
              Color(0xFF007FFF), // Azure (Deep Blue bottom)
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
                  Icons.search,
                  size: 70.0,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 1),

              // --- Main Heading Text ---
              const Text(
                'Report lost items easily',
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
                'Quickly post and search for lost items on campus with our simple interface',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const Spacer(flex: 2),

              // --- Page Indicator Dots ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildPageIndicator(true), // Active (longer) dot
                  _buildPageIndicator(false),
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
                    // 2. Navigation logic: Push the Welcome2Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Welcome2Screen(),
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
                          color: primaryBrightBlue, // Bright blue text color
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: primaryBrightBlue, // Bright blue icon color
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
                  // TODO: Implement skip functionality
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
