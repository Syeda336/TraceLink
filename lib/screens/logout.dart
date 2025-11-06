import 'package:flutter/material.dart';

// Placeholders for navigation
import 'profile_page.dart';
import 'welcome_3.dart';

class LogoutConfirmationScreen extends StatelessWidget {
  const LogoutConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F9),
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
    // Defines the bright, multi-color gradient from the image
    const gradient = LinearGradient(
      colors: [Color(0xFFE53995), Color(0xFFFF8B3F)], // Pink to Orange
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              Icons
                  .logout, // Use Icons.logout or Icons.arrow_forward for the exit icon
              color: Color(0xFFFF5C8D), // A pinkish color from the gradient
              size: 50,
            ),
          ),

          const SizedBox(height: 20),

          // Title and Subtitle
          const Text(
            'Leaving Already? 🥺',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll miss you! Are you sure you want to logout? ✨",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.deepPurple,
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
                      ),
                    ),
                    Text(
                      "You've helped return 8 items and earned a 4.9⭐ rating from the community!",
                      style: TextStyle(
                        color: Colors.grey.shade700,
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
        color: Colors.amber.shade100, // Light yellow background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "You'll need to login again to access your account and continue helping the community.",
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 14),
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
          // Gradient for 'Yes, Logout' button
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3F6A), Color(0xFFFF8B3F)], // Red to Orange
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to 'welcome_3.dart'
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Welcoming3()),
            );
          },
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: const Text(
            'Yes, Logout',
            style: TextStyle(
              color: Colors.white,
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
          // Gradient for 'Stay Logged In' button
          gradient: const LinearGradient(
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFFC084FC),
            ], // Purple/Indigo to Light Purple
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
              color: Colors.white,
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
