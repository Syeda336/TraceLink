import 'package:flutter/material.dart';
// Assuming you will navigate to a different screen after the splash duration
// import 'contact_list_screen.dart';

class ContactWarnSplash extends StatefulWidget {
  const ContactWarnSplash({super.key});

  @override
  State<ContactWarnSplash> createState() => _ContactWarnSplashState();
}

class _ContactWarnSplashState extends State<ContactWarnSplash> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Function to handle the delay and navigation
  _navigateToNextScreen() async {
    // Wait for 3 seconds (adjust as needed for branding/loading time)
    await Future.delayed(const Duration(seconds: 3), () {});

    // Navigate to the next screen after the delay
    // Use Navigator.pushReplacement to prevent the user from going back to the splash screen
    /*
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactListScreen()),
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Or a warning color like Colors.red[50]
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- Warning Icon ---
            Icon(Icons.warning_rounded, color: Colors.red, size: 100.0),
            SizedBox(height: 20.0),
            // --- Warning Title ---
            Text(
              'Attention Required',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10.0),
            // --- Warning Message ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Reviewing contact permissions and data security.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
            ),
            SizedBox(height: 50.0),
            // --- Loading Indicator (Optional) ---
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
