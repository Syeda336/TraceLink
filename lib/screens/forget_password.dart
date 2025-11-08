import 'package:flutter/material.dart';
import 'login_screen.dart';

// Password Changed Success Screen (from the second code block)
class PasswordChangedSuccess extends StatefulWidget {
  const PasswordChangedSuccess({super.key});
  @override
  _PasswordChangedSuccessState createState() => _PasswordChangedSuccessState();
}

class _PasswordChangedSuccessState extends State<PasswordChangedSuccess> {
  // Color variables derived from the requested theme
  static const Color _brightBlue = Color(0xFF007BFF); // Bright Blue for accents
  static const Color _lightBlue = Color(
    0xFFE3F2FD,
  ); // Light Blue for background gradient start
  static const Color _darkBlueText = Color(
    0xFF0D47A1,
  ); // Dark Blue for main body text
  static const Color _lightBlueGradientEnd = Color(
    0xFFBBDEFB,
  ); // Slightly darker light blue for gradient end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          // Overall Background Gradient: Light Blue Theme
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_lightBlue, _lightBlueGradientEnd],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: ListView(
                    shrinkWrap: true, // Only occupy required vertical space
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      // --- Icon Section (Bright Blue Accent) ---
                      Center(
                        child: Container(
                          width: 111,
                          height: 111,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4FC3F7), // Lighter Blue
                                _brightBlue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _brightBlue.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color:
                                Colors.white, // White text/icon on Bright Blue
                            size: 60,
                          ),
                        ),
                      ),

                      // 1. Password Reset Title
                      Center(
                        child: Text(
                          "Password Reset! 🎉",
                          style: TextStyle(
                            color: _brightBlue, // Bright Blue accent color
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Success Message 1 (Dark Blue text on Light Blue background)
                      Center(
                        child: Text(
                          "Your password has been successfully reset!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _darkBlueText, // Dark Blue text
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 3. Success Message 2 (Bright Blue text on Light Blue background)
                      Center(
                        child: Text(
                          "You can now login with your new password ✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _brightBlue, // Bright Blue accent color
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // 4. Back to Login Button (Bright Blue background, White text)
                      InkWell(
                        onTap: () {
                          // Navigate back to the LoginScreen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Clears all routes
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _darkBlueText.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            // Bright Blue Gradient for the Button
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF00BFFF), // A lighter shade of blue
                                _brightBlue,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 23),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login,
                                  color:
                                      Colors.white, // White icon on Bright Blue
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Back to Login",
                                  style: TextStyle(
                                    color: Color(
                                      0xFFFFFFFF,
                                    ), // White text on Bright Blue
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

// Reset Password Screen (from the first code block)
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // --- New Color Definitions for the Blue Theme ---
  // Primary Gradient: Bright Blue (for buttons and main icon)
  static const List<Color> _brightBlueGradient = [
    Color(0xFF42A5F5), // Light Blue
    Color(0xFF1565C0), // Darker Blue
  ];
  // Background: Very Light Blue
  static const Color _lightBlueBackgroundStart = Color(
    0xFFE3F2FD,
  ); // Light Blue 50
  static const Color _lightBlueBackgroundEnd = Color(
    0xFFBBDEFB,
  ); // Light Blue 200
  // Secondary Color: Dark Blue (for text and outlines)
  static const Color _darkBlue = Color(0xFF0D47A1); // Very Dark Blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1. Overall Background Gradient (Light Blue)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _lightBlueBackgroundStart, // Very light blue
              _lightBlueBackgroundEnd, // Slightly darker light blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: _darkBlue, // Dark Blue Icon
                    onPressed: () {
                      // Handle back navigation
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Main Lock Icon (Bright Blue Gradient)
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _brightBlueGradient, // Bright Blue Gradient
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _darkBlue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Colors.white, // White Icon
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Title and Subtitle
                  Center(
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Reset Password ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _darkBlue, // Dark Blue Title
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              const TextSpan(
                                text: '🔐',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            text: 'Create a new secure password ',
                            style: TextStyle(
                              fontSize: 16,
                              color: _darkBlue.withOpacity(
                                0.7,
                              ), // Dark Blue Subtitle
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              const TextSpan(
                                text: '💙',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 5. "New Password" Field Label
                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _darkBlue, // Dark Blue Label
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    hint: 'Enter new password',
                    isObscured: _isPasswordObscured,
                    onToggleVisibility: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // 6. "Confirm Password" Field Label
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _darkBlue, // Dark Blue Label
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    hint: 'Confirm new password',
                    isObscured: _isConfirmPasswordObscured,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordObscured =
                            !_isConfirmPasswordObscured;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // 7. Password Hint Box
                  _buildPasswordHintBox(),
                  const SizedBox(height: 32),

                  // 8. Reset Password Button (Bright Blue Gradient)
                  _buildResetButton(),
                  const SizedBox(height: 24),

                  // 9. Back to Login Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Handle back to login (pop to go back to the previous screen)
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: _darkBlue, // Dark Blue Link Icon
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _darkBlue, // Dark Blue Link Text
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 10. Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(color: const Color(0xFFBBDEFB)), // Light Blue
                      _buildDot(color: const Color(0xFF64B5F6)), // Mid Blue
                      _buildDot(color: _darkBlue), // Dark Blue (Current Page)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for Password Text Fields
  Widget _buildPasswordField({
    required String hint,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _darkBlue, width: 1.5), // Dark Blue Outline
        boxShadow: [
          BoxShadow(
            color: _darkBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        obscureText: isObscured,
        style: const TextStyle(
          color: _darkBlue,
          fontFamily: 'Poppins',
        ), // Dark Blue Input Text
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintText: hint,
          hintStyle: TextStyle(
            color: _darkBlue.withOpacity(0.4),
            fontFamily: 'Poppins',
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: _darkBlue,
          ), // Dark Blue Icon
          suffixIcon: IconButton(
            icon: Icon(
              isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: _darkBlue, // Dark Blue Icon
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }

  // Helper widget for the "Create a strong password" box
  Widget _buildPasswordHintBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _darkBlue, width: 1.5), // Dark Blue Outline
        boxShadow: [
          BoxShadow(
            color: _darkBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF90CAF9), // Light Blue
                  Color(0xFF42A5F5), // Mid Blue
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white, // White Icon
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a strong password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _darkBlue, // Dark Blue Text
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text:
                        'Use at least 8 characters with a mix of '
                        'letters, numbers, and symbols ',
                    style: TextStyle(
                      fontSize: 12,
                      color: _darkBlue.withOpacity(0.7), // Dark Blue Text
                      height: 1.4,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      const TextSpan(
                        text: '🔒',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the main "Reset Password" button
  Widget _buildResetButton() {
    return GestureDetector(
      onTap: () {
        // Handle reset password logic and navigate to the success screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PasswordChangedSuccess(),
          ),
        );
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          // Bright Blue Gradient for the button
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: _brightBlueGradient,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _darkBlue.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.autorenew, // Reset icon
                color: Colors.white, // White Icon
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white, // White Text
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the dots at the bottom
  Widget _buildDot({required Color color}) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
