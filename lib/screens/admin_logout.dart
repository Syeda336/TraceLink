import 'package:flutter/material.dart';
import 'login_screen.dart';

class AdminDashboardLogoutConfirmation extends StatefulWidget {
  const AdminDashboardLogoutConfirmation({super.key});

  @override
  AdminDashboardLogoutConfirmationState createState() =>
      AdminDashboardLogoutConfirmationState();
}

class AdminDashboardLogoutConfirmationState
    extends State<AdminDashboardLogoutConfirmation> {
  // Define color constants
  static const Color primaryBlue = Color(0xFF007BFF); // Bright Blue
  static const Color darkBlue = Color(0xFF003366); // Dark Blue
  static const Color whiteColor = Color(0xFFFFFFFF); // White

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Changed Background: Uses a gradient blue instead of plain white
      // This reduces eye strain and makes the white card "pop"
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkBlue,   // Starts dark
              primaryBlue // Fades to bright blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                // 2. The Card remains White for maximum text readability
                elevation: 12,
                color: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Alert Icon ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD), // Very light blue circle
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.power_settings_new_rounded,
                          size: 48,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Heavy Contrast Title ---
                      const Text(
                        "Log Out?",
                        style: TextStyle(
                          // Explicitly Dark Blue to ensure visibility on White Card
                          color: darkBlue, 
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // --- Readable Body Text ---
                      const Text(
                        "Are you sure you want to leave the admin panel? You will need to enter your credentials again to return.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87, // Dark grey/black for best reading
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // --- Buttons ---
                      Row(
                        children: [
                          // 1. Cancel Button (Grey/Dark text)
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: const Text(
                                "Stay Logged In",
                                style: TextStyle(
                                  color: Colors.black87, // High visibility text
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 2. Logout Button (Solid Blue)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: whiteColor, // Forces text to be white
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Yes, Logout",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}