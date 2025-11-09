import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'dart:async';
import 'admin_claims.dart';


class ClaimDeleteConfirmation extends StatefulWidget {
  const ClaimDeleteConfirmation({super.key});

  @override
  ClaimDeleteConfirmationState createState() => ClaimDeleteConfirmationState();
}
class ClaimDeleteConfirmationState extends State<ClaimDeleteConfirmation> {
  @override
  //adding timer
  void initState() {
    super.initState();
    // This timer will wait 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // This will PUSH the claims screen and REMOVE all screens behind it,
        // so the user can't go "back" to this confirmation page.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboardClaimScreen1(),
          ),
          (Route<dynamic> route) => false, // This removes all routes
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to light for better contrast with the dark background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Container(
        // Full screen gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9B59B6), // Purple from your design
              Color(0xFF3498DB), // Blue from your design
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center( // Center the entire content column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              // Circular icon with checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Translucent white background
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3), // Light border
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline, // Checkmark icon
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              // "Claim Deleted!" text
              const Text(
                "Claim Deleted!",
                style: TextStyle(
                  color: Colors.white, // Changed to white
                  fontSize: 28, // Increased font size
                  fontWeight: FontWeight.bold, // Added bold
                  shadows: [ // Added shadow for depth
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0), // Added horizontal padding
                child: Text(
                  "The claim for this item has been deleted",
                  textAlign: TextAlign.center, // Center align text
                  style: TextStyle(
                    color: Colors.white70, // Changed to white70 for slight transparency
                    fontSize: 18, // Increased font size
                    shadows: [ // Added shadow for depth
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12,
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