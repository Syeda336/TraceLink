import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:provider/provider.dart'; // For Provider
import 'profile_page.dart'; // Import your profile_page.dart
import '../theme_provider.dart'; // Import the ThemeProvider

// --- Theme Colors (Base) ---
// Note: Actual colors will be determined at runtime based on isDarkMode
const Color _primaryBrightBlue = Color(
  0xFF007AFF,
); // Header/Button background, TextField focus
const Color _secondaryDarkBlue = Color(
  0xFF0A183C,
); // Dark text on light background
const Color _lightBlue = Color(0xFFB3E5FC); // Button track

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Determine background color based on theme
    final Color scaffoldBgColor = isDarkMode ? Colors.black : Colors.grey[50]!;

    // Set status bar icons dynamically
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Icons are white on bright blue header, regardless of overall theme
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: const _ChangePasswordContent(),
    );
  }
}

// --- New Widget for Content and Logic ---

class _ChangePasswordContent extends StatefulWidget {
  const _ChangePasswordContent();

  @override
  State<_ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<_ChangePasswordContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      // Simulate backend call
      debugPrint('Password update simulated.');

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the ProfilePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Theme-dependent colors
    final Color textColor = isDarkMode ? Colors.white : _secondaryDarkBlue;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color cardBorderColor = isDarkMode
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    return CustomScrollView(
      slivers: [
        // SliverAppBar
        SliverAppBar(
          expandedHeight: 120.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: _primaryBrightBlue),
            titlePadding: const EdgeInsetsDirectional.only(
              start: 72,
              bottom: 16,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep your account secure',
                  style: TextStyle(fontSize: 12.0, color: Colors.white70),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Password Tips Section
                    Card(
                      color: cardColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: cardBorderColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _primaryBrightBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.lock_outline,
                                    color: _primaryBrightBlue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password Tips',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            textColor, // Use theme-aware color
                                      ),
                                    ),
                                    Text(
                                      'Follow these guidelines for a strong password',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey
                                            : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _buildTipRow(
                              'At least 10 characters long',
                              textColor,
                            ),
                            _buildTipRow(
                              'Include uppercase and lowercase letters',
                              textColor,
                            ),
                            _buildTipRow(
                              'Include numbers and special characters',
                              textColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Current Password Field
                    Text(
                      'Current Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      hintText: 'Enter current password',
                      isVisible: _isCurrentPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isCurrentPasswordVisible =
                              !_isCurrentPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      isDarkMode: isDarkMode, // Pass theme state
                    ),
                    const SizedBox(height: 20),

                    // New Password Field
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      hintText: 'Enter new password',
                      isVisible: _isNewPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 10) {
                          return 'Password must be at least 10 characters long';
                        }
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Password must include uppercase letters';
                        }
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'Password must include lowercase letters';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must include numbers';
                        }
                        if (!value.contains(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                        )) {
                          return 'Password must include special characters';
                        }
                        return null;
                      },
                      isDarkMode: isDarkMode, // Pass theme state
                    ),
                    const SizedBox(height: 20),

                    // Confirm New Password Section
                    Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _confirmNewPasswordController,
                      hintText: 'Confirm new password',
                      isVisible: _isConfirmNewPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isConfirmNewPasswordVisible =
                              !_isConfirmNewPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      isDarkMode: isDarkMode, // Pass theme state
                    ),
                    const SizedBox(height: 30),

                    // Update Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: _primaryBrightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.lock_open, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Update Password',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Forgot Password Section
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: _primaryBrightBlue.withOpacity(0.3),
                        ),
                      ),
                      color: isDarkMode
                          ? Colors.black26
                          : _lightBlue.withOpacity(
                              0.2,
                            ), // Theme-aware background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: textColor, // Theme-aware icon color
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Forgot your password?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor, // Theme-aware text
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Contact support at ',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'support@university.edu',
                                          style: TextStyle(
                                            color: _primaryBrightBlue,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' for assistance with password recovery.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // Helper widget for password tips
  Widget _buildTipRow(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: _primaryBrightBlue,
            size: 18,
          ), // Bright blue checkmark
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ), // Theme-aware tip text
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for password text fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required bool isDarkMode, // New parameter for theme awareness
    String? Function(String?)? validator,
  }) {
    final Color inputTextColor = isDarkMode ? Colors.white : _secondaryDarkBlue;
    final Color hintTextColor = isDarkMode
        ? Colors.grey
        : _secondaryDarkBlue.withOpacity(0.5);
    final Color fillColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : Colors.grey[100]!;
    final Color enabledBorderColor = isDarkMode
        ? Colors.grey.withOpacity(0.5)
        : _secondaryDarkBlue.withOpacity(0.3);
    final Color toggleIconColor = isDarkMode
        ? Colors.grey.withOpacity(0.8)
        : _secondaryDarkBlue.withOpacity(0.6);

    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: inputTextColor), // Input text is theme-aware
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintTextColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: enabledBorderColor, // Theme-aware border
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: enabledBorderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: _primaryBrightBlue,
            width: 2,
          ), // Bright blue on focus (same for both themes)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: toggleIconColor, // Theme-aware icon color
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}
