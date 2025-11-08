import 'package:flutter/material.dart';

// Placeholders for navigation
import 'profile_page.dart';
import 'login_screen.dart';

class LogoutConfirmationScreen extends StatelessWidget {
  const LogoutConfirmationScreen({super.key});

  // --- New Color Definitions for the Blue Theme ---
  // Background: Very Light Blue
  static const Color _lightBlueBackground = Color(0xFFE3F2FD); // Light Blue 50
  // Primary Gradient: Bright Blue
  static const List<Color> _brightBlueGradient = [
    Color(0xFF42A5F5), // Mid-light Blue
    Color(0xFF1565C0), // Darker Blue
  ];
  // Secondary Color: Dark Blue (for text and outlines)
  static const Color _darkBlue = Color(0xFF0D47A1); // Very Dark Blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBlueBackground, // Updated: Light Blue Background
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- Gradient Header Section ---
            _buildGradientHeader(context),

            const SizedBox(height: 24),

            // --- Your Impact Card ---
            _buildImpactCard(),

            const SizedBox(height: 16),

            // --- Warning Card ---
            _buildWarningCard(),

            const SizedBox(height: 40),

            // --- Yes, Logout Button ---
            _buildLogoutButton(context),

            const SizedBox(height: 16),

            // --- Stay Logged In Button ---
            _buildStayLoggedInButton(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildGradientHeader(BuildContext context) {
    // Defines the bright blue gradient
    const gradient = LinearGradient(
      colors: _brightBlueGradient, // Bright Blue Gradient
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Top Left Corner Button (Navigates to profile_page.dart)
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ), // Text is White
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Large Icon Container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.logout,
              color:
                  _darkBlue, // Dark Blue for the icon inside the white circle
              size: 50,
            ),
          ),

          const SizedBox(height: 20),

          // Title and Subtitle
          const Text(
            'Leaving Already? 🥺',
            style: TextStyle(
              color: Colors.white, // Text is White
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll miss you! Are you sure you want to logout? ✨",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ), // Text is White
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: _darkBlue,
            width: 1.5,
          ), // Dark Blue Outline
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _darkBlue.withOpacity(
                    0.1,
                  ), // Dark Blue opacity background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star,
                  color: _darkBlue, // Dark Blue Icon
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _darkBlue, // Dark Blue Text
                      ),
                    ),
                    Text(
                      "You've helped return 8 items and earned a 4.9⭐ rating from the community!",
                      style: TextStyle(
                        color: _darkBlue.withOpacity(0.8), // Dark Blue Text
                        fontSize: 14,
                      ),
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

  Widget _buildWarningCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: const Color(0xFFBBDEFB), // Distinct Light Blue background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: _darkBlue,
            width: 1.5,
          ), // Dark Blue Outline
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _darkBlue, // Dark Blue Icon
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: const Text(
                  "You'll need to login again to access your account and continue helping the community.",
                  style: TextStyle(
                    color: _darkBlue,
                    fontSize: 14,
                  ), // Dark Blue Text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Gradient for 'Yes, Logout' button (Bright Blue)
          gradient: const LinearGradient(
            colors: _brightBlueGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to 'login_screen.dart'
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: const Text(
            'Yes, Logout',
            style: TextStyle(
              color: Colors.white, // Text is White
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Important for gradient
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStayLoggedInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Gradient for 'Stay Logged In' button (Bright Blue)
          gradient: const LinearGradient(
            colors: _brightBlueGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to 'profile_page.dart'
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          icon: const Icon(Icons.favorite, color: Colors.white),
          label: const Text(
            'Stay Logged In',
            style: TextStyle(
              color: Colors.white, // Text is White
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Important for gradient
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
