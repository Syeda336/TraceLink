import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

//for online/offline status 
import 'package:firebase_auth/firebase_auth.dart'; 
import '../firebase_service.dart';                

// Placeholders for navigation
import 'profile_page.dart';
import 'login_screen.dart';

class LogoutConfirmationScreen extends StatelessWidget {
  const LogoutConfirmationScreen({super.key});

  // --- Theme Color Definitions ---
  // Background: Very Light Blue (Light Mode)
  static const Color _lightBlueBackground = Color(0xFFE3F2FD); // Light Blue 50

  // Primary Gradient: Bright Blue (Light Mode)
  static const List<Color> _brightBlueGradientLight = [
    Color(0xFF42A5F5), // Mid-light Blue
    Color(0xFF1565C0), // Darker Blue
  ];
  // Primary Gradient: Lighter Blue (Dark Mode)
  static const List<Color> _brightBlueGradientDark = [
    Color(0xFF81D4FA), // Lighter Blue
    Color(0xFF039BE5), // Mid Blue
  ];

  // Secondary Color: Dark Blue (Light Mode)
  static const Color _darkBlue = Color(0xFF0D47A1); // Very Dark Blue
  // Secondary Color: Light Blue (Dark Mode)
  static const Color _lightBlue = Color(0xFF4FC3F7); // Light Blue 300

  // Helper to get dynamic colors based on theme
  List<Color> _getGradient(bool isDarkMode) =>
      isDarkMode ? _brightBlueGradientDark : _brightBlueGradientLight;

  Color _getPrimaryColor(bool isDarkMode) =>
      isDarkMode ? _lightBlue : _darkBlue;

  @override
  Widget build(BuildContext context) {
    // 1. Use Consumer to react to theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDarkMode = themeProvider.isDarkMode;
        final Color primaryColor = _getPrimaryColor(isDarkMode);

        return Scaffold(
          // Use system background in dark mode, or light blue in light mode
          backgroundColor: isDarkMode
              ? Theme.of(context).colorScheme.background
              : _lightBlueBackground,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // --- Gradient Header Section ---
                _buildGradientHeader(context, isDarkMode, themeProvider),

                const SizedBox(height: 24),

                // --- Your Impact Card ---
                _buildImpactCard(context, primaryColor, isDarkMode),

                const SizedBox(height: 16),

                // --- Warning Card ---
                _buildWarningCard(context, primaryColor),

                const SizedBox(height: 40),

                // --- Yes, Logout Button ---
                _buildLogoutButton(context, isDarkMode),

                const SizedBox(height: 16),

                // --- Stay Logged In Button ---
                _buildStayLoggedInButton(context, isDarkMode),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Widget Builders ---

  Widget _buildGradientHeader(
    BuildContext context,
    bool isDarkMode,
    ThemeProvider themeProvider,
  ) {
    final gradient = LinearGradient(
      colors: _getGradient(isDarkMode), // Dynamic Gradient
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final Color primaryColor = _getPrimaryColor(isDarkMode);

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
          // Top Row: Back Button and Theme Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button (Navigates to profile_page.dart)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),

              // Theme Toggle Switch
              Row(
                children: [
                  const Text(
                    'Dark Mode',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: themeProvider.toggleTheme,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white70,
                    inactiveTrackColor: Colors.white38,
                  ),
                ],
              ),
            ],
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
            child: Icon(
              Icons.logout,
              color: primaryColor, // Dynamic Primary Color
              size: 50,
            ),
          ),

          const SizedBox(height: 20),

          // Title and Subtitle
          const Text(
            'Leaving Already? ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Are you sure you want to logout? ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // FIXED: Added BuildContext context as the first argument
  Widget _buildImpactCard(
    BuildContext context,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        // CORRECTED LINE: Using the passed 'context' argument
        color: isDarkMode
            ? Theme.of(context).colorScheme.surface
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: primaryColor, // Dynamic Primary Color Outline
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.star,
                  color: primaryColor, // Dynamic Primary Color Icon
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor, // Dynamic Primary Color Text
                      ),
                    ),
                    Text(
                      "You've helped return 8 items and earned a 4.9⭐ rating from the community!",
                      style: TextStyle(
                        color: primaryColor.withOpacity(isDarkMode ? 1.0 : 0.8),
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

  // FIXED: Added BuildContext context as the first argument
  Widget _buildWarningCard(BuildContext context, Color primaryColor) {
    // Distinct colors for the warning card background
    const Color cardBg = Color(0xFFBBDEFB);
    const Color cardBgDark = Color(0xFF03224C);

    bool isDarkMode = primaryColor == _lightBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: isDarkMode ? cardBgDark : cardBg, // Dynamic Warning Card Color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: primaryColor, // Dynamic Primary Color Outline
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: primaryColor, // Dynamic Primary Color Icon
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "You'll need to login again to access your account and continue helping the community.",
                  style: TextStyle(
                    color: primaryColor, // Dynamic Primary Color Text
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDarkMode) {
    final gradient = LinearGradient(
      colors: _getGradient(isDarkMode), // Dynamic Gradient
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: gradient, // Dynamic Gradient for button
        ),
        child: ElevatedButton.icon(
          
          onPressed: () async {
            // 1. Mark user as OFFLINE
            await FirebaseService.updateUserStatus(false);
            
            // 2. Actually Sign Out
            await FirebaseAuth.instance.signOut();

            // 3. Navigate to Login Screen
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
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
            backgroundColor: Colors.transparent,
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

  Widget _buildStayLoggedInButton(BuildContext context, bool isDarkMode) {
    final gradient = LinearGradient(
      colors: _getGradient(isDarkMode), // Dynamic Gradient
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: gradient, // Dynamic Gradient for button
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
            backgroundColor: Colors.transparent,
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
