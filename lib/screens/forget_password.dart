import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../firebase_service.dart'; // Import Firebase Service

// -----------------------------------------------------
// SUCCESS SCREEN (This is the screen from ...194014.jpg)
// -----------------------------------------------------
class PasswordChangedSuccess extends StatefulWidget {
  const PasswordChangedSuccess({super.key});
  @override
  _PasswordChangedSuccessState createState() => _PasswordChangedSuccessState();
}

class _PasswordChangedSuccessState extends State<PasswordChangedSuccess> {
  // Color variables derived from the requested theme
  static const Color _brightBlue = Color(0xFF007BFF);
  static const Color _lightBlue = Color(0xFFE3F2FD);
  static const Color _darkBlueText = Color(0xFF0D47A1);
  static const Color _lightBlueGradientEnd = Color(0xFFBBDEFB);

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
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      // --- Icon Section ---
                      Center(
                        child: Container(
                          width: 111,
                          height: 111,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4FC3F7), _brightBlue],
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
                            Icons.email_outlined,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),

                      // 1. Title
                      Center(
                        child: Text(
                          "Check Your Email! 📧",
                          style: TextStyle(
                            color: _brightBlue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Success Message 1
                      Center(
                        child: Text(
                          "A password reset link has been sent to your email.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _darkBlueText,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 3. Success Message 2
                      Center(
                        child: Text(
                          "Please follow the link to create a new password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _brightBlue,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // 4. Back to Login Button
                      InkWell(
                        onTap: () {
                          // Navigate back to the LoginScreen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
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
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF00BFFF), _brightBlue],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 23),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Back to Login",
                                  style: TextStyle(
                                    color: Colors.white,
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

// -----------------------------------------------------------------
// SCREEN 1: "RESET PASSWORD" SCREEN (MODIFIED TO ASK FOR EMAIL)
// -----------------------------------------------------------------
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // --- Controllers and State ---
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _emailError; // <-- NEW: State to hold the error text

  // --- Color Definitions (from your original file) ---
  static const List<Color> _brightBlueGradient = [
    Color(0xFF42A5F5),
    Color(0xFF1565C0),
  ];
  static const Color _lightBlueBackgroundStart = Color(0xFFE3F2FD);
  static const Color _lightBlueBackgroundEnd = Color(0xFFBBDEFB);
  static const Color _darkBlue = Color(0xFF0D47A1);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  // --- NEW: Function to manually validate email ---
  void _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    } else if (!value.contains('@') || !value.contains('.')) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = null; // It's valid
      });
    }
  }

  // --- Handle Verify Email Button Press ---
  void _handleSendLink() async {
    // 1. Manually validate before proceeding
    _validateEmail(_emailController.text);
    if (_emailError != null) {
      return; // If there's an error, stop
    }

    setState(() {
      _isLoading = true;
    });

    // 2. Call the Firebase service
    final email = _emailController.text.trim();
    final String? error =
        await FirebaseService.sendPasswordResetEmail(email: email);

    setState(() {
      _isLoading = false;
    });

    // 3. Handle success or failure
    if (error == null && mounted) {
      // SUCCESS!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PasswordChangedSuccess(),
        ),
      );
    } else if (mounted) {
      // ERROR!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'An unknown error occurred.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // --- Main Background Gradient (FITS WHOLE SCREEN) ---
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lightBlueBackgroundStart, _lightBlueBackgroundEnd],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              // --- REMOVED THE Form WIDGET ---
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Back Button ---
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: _darkBlue,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),

                  // --- Icon ---
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _brightBlueGradient,
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
                        Icons.lock_reset_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Title and Subtitle ---
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Forget Password?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _darkBlue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter the email associated with your account.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: _darkBlue.withOpacity(0.7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- EMAIL FIELD WIDGET ---
                  _buildEmailTextField(), // This now includes the error text below
                  const SizedBox(height: 32),

                  // --- "VERIFY EMAIL" BUTTON ---
                  _buildVerifyEmailButton(),
                  const SizedBox(height: 24),

                  // --- Back to Login Link ---
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 18, color: _darkBlue),
                          SizedBox(width: 4),
                          Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _darkBlue,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // --- Bottom Dots ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(color: _darkBlue.withOpacity(0.5)),
                      _buildDot(color: _darkBlue),
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

  // --- WIDGET: Email Text Field ---
  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your University Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _darkBlue,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            // Change border color if there is an error
            border: Border.all(
              color: _emailError != null ? Colors.red : _darkBlue, // Use red for error
              width: 1.5
            ),
            boxShadow: [
              BoxShadow(
                color: _darkBlue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: _darkBlue, fontFamily: 'Poppins'),
            
            // --- UPDATED ---
            // Call our manual validator on every change
            onChanged: (value) {
              _validateEmail(value);
            },
            // --- REMOVED autovalidateMode and validator ---

            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              hintText: 'your.email@university.edu',
              hintStyle: TextStyle(
                color: _darkBlue.withOpacity(0.4),
                fontFamily: 'Poppins',
              ),
              
              // --- HIDE THE DEFAULT ERROR TEXT ---
              errorStyle: const TextStyle(
                height: 0, 
                color: Colors.transparent,
                fontSize: 0,
              ),
            ),
          ),
        ),
        
        // --- NEW: MANUALLY DISPLAY THE ERROR TEXT OUTSIDE ---
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text(
              _emailError!,
              style: const TextStyle(
                color: _darkBlue, // Dark blue, as requested
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  // --- WIDGET: Verify Email Button ---
  Widget _buildVerifyEmailButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSendLink,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
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
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Verify Email',
                      style: TextStyle(
                        color: Colors.white,
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