import 'package:flutter/material.dart';

// Assume these files exist in your project structure for navigation
import 'item_description.dart'; // Renamed to ItemDetailScreen for consistency with usage
import 'submitted_claim.dart';

class VerifyOwnershipScreen extends StatelessWidget {
  const VerifyOwnershipScreen({super.key});

  // Helper widget for the text fields
  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // Hide the border for a cleaner look
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
          ), // Light border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFF8A2387),
            width: 2.0,
          ), // Focus color
        ),
      ),
    );
  }

  // Helper widget for the gradient button
  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors
              .transparent, // Make the button transparent to show the gradient
          shadowColor: Colors.transparent, // Remove shadow for a flatter look
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8A2387); // Deep purple
    const Color secondaryColor = Color(0xFFE94057); // Reddish-pink
    const Color tertiaryColor = Color(0xFFF27121); // Orange

    // Define a constant for the button area height to add padding to the scroll view
    const double fixedButtonHeight = 100.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Verify Ownership',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to item_description.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ItemDetailScreen(itemName: 'Black Wallet'),
              ),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor, tertiaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F7F7),
        child: Stack(
          // <--- Use Stack to layer scrolling content and fixed button
          children: <Widget>[
            // 1. Scrollable Form Content
            SingleChildScrollView(
              // Add padding at the bottom equal to the fixed button height
              // to prevent the last field from being hidden by the button.
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, fixedButtonHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Verification Required Card/Container
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Required',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5C),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please answer the following questions to verify you\'re the owner of this item.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Verification Questions
                  const Text(
                    'What was inside the wallet?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(hintText: 'Your answer...'),

                  const SizedBox(height: 20),

                  const Text(
                    'What color is your student ID card?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(hintText: 'Your answer...'),

                  const SizedBox(height: 20),

                  const Text(
                    'Can you describe any unique features?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText: 'Describe unique features, marks, or contents...',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  // Contact Information Field
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(hintText: 'Your phone number'),

                  const SizedBox(height: 20),

                  // Additional Notes (Optional) Field
                  const Text(
                    'Additional Notes (Optional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText:
                        'Any additional information that might help verify ownership...',
                    maxLines: 4,
                  ),

                  // The SizedBox at the end is now much smaller or removed,
                  // as the main padding for the button area is in the SingleChildScrollView.
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // 2. Fixed Submit Claim Button at the Bottom
            Align(
              // <--- Align positions the button at the bottom
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ), // Padding from screen edges
                child: _buildGradientButton(
                  context: context,
                  text: 'Submit Claim',
                  onPressed: () {
                    // Navigate to submitted_claim.dart when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubmittedClaimScreen(),
                      ),
                    );
                  },
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
