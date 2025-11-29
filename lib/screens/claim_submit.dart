import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import the existing ThemeProvider
import '../theme_provider.dart';
import 'package:tracelink/firebase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Assume these files exist in your project structure for navigation
import 'submitted_claim.dart';

// Ensure Supabase is initialized in main.dart
final supabase = Supabase.instance.client;

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

// 1. CONVERT TO STATEFUL WIDGET
class VerifyOwnershipScreen extends StatefulWidget {
  const VerifyOwnershipScreen({super.key});

  @override
  State<VerifyOwnershipScreen> createState() => _VerifyOwnershipScreenState();
}

class _VerifyOwnershipScreenState extends State<VerifyOwnershipScreen> {
  // Map for Firebase data: 'fullName', 'studentId', 'email' are expected keys
  Map<String, dynamic>? userData;
  bool _isLoading = true; // Loading state

  // 2. TEXT EDITING CONTROLLERS FOR NEW FIELDS
  final _itemNameController = TextEditingController();
  final _uniqueFeatureController = TextEditingController();
  final _contactController = TextEditingController();
  final _daysLostController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // 3. GLOBAL KEY FOR FORM

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load real data when screen starts
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is removed
    _itemNameController.dispose();
    _uniqueFeatureController.dispose();
    _contactController.dispose();
    _daysLostController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  // NOTE: didChangeDependencies logic is kept simple since data is loaded in initState
  // and we generally don't expect the user to manually trigger a refresh here.

  Future<void> _loadUserData() async {
    // Assuming FirebaseService.getUserData() fetches the required data (full name, student ID, email)
    // NOTE: This service is not defined in the provided code, assuming it exists.
    try {
      Map<String, dynamic>? data = await FirebaseService.getUserData();
      if (mounted) {
        setState(() {
          userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Optionally show an error to the user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading user data: $e')));
      }
    }
  }

  // 4. SUPABASE INSERT LOGIC
  Future<void> _submitClaim() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    if (userData == null ||
        userData!['studentId'] == null ||
        userData!['fullName'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User data not loaded. Cannot submit claim.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state for submission
    });

    try {
      final String studentId = userData!['studentId'] as String;
      final String fullName = userData!['fullName'] as String;

      await supabase.from('claimed_items').insert({
        'User ID': studentId,
        'User Name': fullName,
        'Item Name': _itemNameController.text.trim(),
        'Unique Features': _uniqueFeatureController.text.trim(),
        'Contact': _contactController.text.trim(),
        'Days Lost': _daysLostController.text
            .trim(), // Storing as text for simplicity
        'Additional Notes': _additionalNotesController.text.trim(),
      });

      // Navigate to the success screen after successful submission
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SubmittedClaimScreen()),
        );
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting claim: ${e.message}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper widget for the text fields (Updated to include controller and validator)
  Widget _buildTextField({
    required String labelText,
    required bool isDarkMode,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
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
    final Color errorColor = isDarkMode ? const Color(0xFFFFCCBC) : Colors.red;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      validator: validator,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: TextStyle(color: hintColor),
        labelText: labelText,
        labelStyle: TextStyle(color: hintColor),
        fillColor: fillColor,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        errorStyle: TextStyle(color: errorColor),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
      ),
    );
  }

  // Helper widget for the gradient button (unchanged)
  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color primaryColor,
    required Color secondaryColor,
    bool isLoading = false,
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
        onPressed: isLoading ? null : onPressed, // Disable when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // Text is always white on the gradient button
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
              colors: [
                appBarPrimary,
                appBarSecondary,
                isDarkMode ? darkTertiaryColor : lightTertiaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading && userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20.0,
                20.0,
                20.0,
                40.0,
              ), // Added bottom padding
              child: Form(
                key: _formKey, // Attach form key
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
                            color: Colors.black.withOpacity(
                              isDarkMode ? 0.3 : 0.1,
                            ),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        // Outline for the card in light mode (Dark Blue Text color)
                        border: isDarkMode
                            ? null
                            : Border.all(
                                color: _kDarkBlueText.withOpacity(0.3),
                              ),
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
                            style: TextStyle(
                              fontSize: 16,
                              color: bodyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- NEW FIELDS IMPLEMENTATION ---
                    // 1. Item Name
                    Text(
                      'Item Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: questionTitleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      labelText: 'e.g., Brown Leather Wallet',
                      controller: _itemNameController,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the item name.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 2. Describe any unique feature
                    Text(
                      'Describe any unique feature',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: questionTitleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      labelText:
                          'Describe unique features, marks, or contents...',
                      controller: _uniqueFeatureController,
                      maxLines: 4,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe a unique feature to verify ownership.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 3. Contact Information
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
                      labelText: 'Your phone number or preferred contact',
                      controller: _contactController,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a contact number.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 4. For many days did lost it
                    Text(
                      'For how many days was it lost?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: questionTitleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      labelText: 'Number of days (e.g., 2)',
                      controller: _daysLostController,
                      isDarkMode: isDarkMode,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please specify the number of days lost.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 5. Additional Notes (Optional) Field
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
                      labelText: 'Any other detail that might help...',
                      controller: _additionalNotesController,
                      maxLines: 4,
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 40),

                    // Submit Claim Button
                    _buildGradientButton(
                      context: context,
                      text: 'Submit Claim',
                      onPressed: _submitClaim, // Call the new submission logic
                      primaryColor: appBarPrimary,
                      secondaryColor: appBarSecondary,
                      isLoading: _isLoading, // Pass loading state to button
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
