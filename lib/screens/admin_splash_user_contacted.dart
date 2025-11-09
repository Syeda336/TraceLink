import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Required for Timer


import 'admin_resolve_pending.dart'; 

class UserContactedSplashScreen extends StatefulWidget {
  const UserContactedSplashScreen({super.key});

  @override
  UserContactedSplashScreenState createState() => UserContactedSplashScreenState();
}

class UserContactedSplashScreenState extends State<UserContactedSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Navigate to the AdminResolvePendingScreen and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboardResolvePendingUserReport(),
          ),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to dark for better contrast with the light background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: Container(
        // Full screen green/yellow gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 127, 193, 53), // A light, vibrant green
              Color.fromARGB(255, 226, 241, 54), // A bright yellow-green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon with checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Soft shadow for depth
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline, // Checkmark icon
                  color: Color(0xFF69F0AE), // A vibrant green for the checkmark
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              // "User Contacted!" text
              const Text(
                "User Contacted!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26, // Darker shadow for more pop
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "The user has been contacted through\nnotification to return the item.", // Two lines as in the image
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70, // Slightly transparent white
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12, // Softer shadow for subtitle
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}