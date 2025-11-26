import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import the existing ThemeProvider
import '../theme_provider.dart';

// Assume these files exist in your project structure for navigation
import 'submitted_claim.dart';

// --- Theme Constants ---
// Bright Blue Theme (Primary for Light Mode)
const Color _kPrimaryBrightBlue = Color(0xFF1E88E5); // Bright Blue
const Color _kDarkBlueText = Color(0xFF0D47A1); // Darker Blue for text/outline

// Dark Theme (Primary for Dark Mode)
const Color _kDarkPrimaryColor = Color(0xFF303F9F); // Deep Indigo
const Color _kDarkBackgroundColor = Color(0xFF121212); // True black/dark grey
const Color _kDarkCardColor = Color(0xFF1F1F1F);
const Color _kDarkHighlightColor = Color(
  0xFFBBDEFB,
); // Light text color for dark mode

class VerifyOwnershipScreen extends StatelessWidget {
  const VerifyOwnershipScreen({super.key});

  // Helper widget for the text fields
  Widget _buildTextField({
    required String hintText,
    required bool isDarkMode, // Added isDarkMode parameter
    int maxLines = 1,
  }) {
    // Colors dynamically set based on theme
    final Color focusColor = isDarkMode ? _kDarkHighlightColor : _kDarkBlueText;
    final Color fillColor = isDarkMode ? _kDarkCardColor : Colors.white;
    // Using ! operator to assert non-null for Colors.grey shades
    final Color hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color enabledBorderColor = isDarkMode
        ? _kDarkPrimaryColor
        : const Color(0xFFE0E0E0);

    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        fillColor: fillColor,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: focusColor,
            width: 2.0,
          ), // Dynamic Focus color
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
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
            color: Colors.white, // Text is always white on the gradient button
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme state
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Dynamic Colors based on theme
    const Color lightPrimaryColor = _kPrimaryBrightBlue;
    const Color lightSecondaryColor = Color(
      0xFF42A5F5,
    ); // Lighter shade of blue
    const Color lightTertiaryColor = Color(0xFF90CAF9); // Even lighter blue
    const Color lightScaffoldBg = Color(0xFFF7F7F7);

    // Dark Mode colors for AppBar Gradient (using the Deep Indigo theme)
    final Color darkPrimaryColor = _kDarkPrimaryColor;
    final Color darkSecondaryColor = const Color(0xFF5C6BC0);
    final Color darkTertiaryColor = const Color(0xFF7986CB);
    final Color darkScaffoldBg = _kDarkBackgroundColor;

    // Select the colors based on theme mode
    final Color appBarPrimary = isDarkMode
        ? darkPrimaryColor
        : lightPrimaryColor;
    final Color appBarSecondary = isDarkMode
        ? darkSecondaryColor
        : lightSecondaryColor;
    final Color appBarTertiary = isDarkMode
        ? darkTertiaryColor
        : lightTertiaryColor;
    final Color scaffoldBg = isDarkMode ? darkScaffoldBg : lightScaffoldBg;
    final Color cardBg = isDarkMode ? _kDarkCardColor : Colors.white;
    final Color headingColor = isDarkMode
        ? _kDarkHighlightColor
        : _kDarkBlueText;
    final Color bodyTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final Color questionTitleColor = isDarkMode
        ? _kDarkHighlightColor
        : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBg,
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
            // Navigate back to item_description.dart
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [appBarPrimary, appBarSecondary, appBarTertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // --- CHANGE: Removed Stack/Align, using SingleChildScrollView only ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          40.0,
        ), // Added bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Verification Required Card/Container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                // Outline for the card in light mode (Dark Blue Text color)
                border: isDarkMode
                    ? null
                    : Border.all(color: _kDarkBlueText.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Required',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: headingColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please answer the following questions to verify you\'re the owner of this item.',
                    style: TextStyle(fontSize: 16, color: bodyTextColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Verification Questions
            Text(
              'What was inside the wallet?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: questionTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hintText: 'Your answer...',
              isDarkMode: isDarkMode, // Pass theme state
            ),

            const SizedBox(height: 20),

            Text(
              'What color is your student ID card?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: questionTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hintText: 'Your answer...',
              isDarkMode: isDarkMode, // Pass theme state
            ),

            const SizedBox(height: 20),

            Text(
              'Can you describe any unique features?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: questionTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hintText: 'Describe unique features, marks, or contents...',
              maxLines: 4,
              isDarkMode: isDarkMode, // Pass theme state
            ),

            const SizedBox(height: 20),

            // Contact Information Field
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: questionTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hintText: 'Your phone number',
              isDarkMode: isDarkMode, // Pass theme state
            ),

            const SizedBox(height: 20),

            // Additional Notes (Optional) Field
            Text(
              'Additional Notes (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: questionTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hintText:
                  'Any additional information that might help verify ownership...',
              maxLines: 4,
              isDarkMode: isDarkMode, // Pass theme state
            ),

            const SizedBox(height: 40), // Spacing before the button
            // --- CHANGE: Submit Claim Button placed directly in the Column (scrolls with content) ---
            _buildGradientButton(
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
              // Button gradient uses the dynamic primary/secondary colors
              primaryColor: appBarPrimary,
              secondaryColor: appBarSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
