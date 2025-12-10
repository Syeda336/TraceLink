import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracelink/firebase_service.dart';
import 'bottom_navigation.dart';

// Define the colors based on your request
const Color _brightBlue = Color(0xFF007AFF); // A standard bright blue
const Color _darkBlue = Color(0xFF003D7A); // A darker shade for text
const Color _outlineDarkBlue = Color(0xFF0056B3); // A dark shade for outlines

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Global key for the form to enable validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State for the Terms & Conditions checkbox and password visibility
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Validation states for real-time feedback
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmailRealTime);
    _passwordController.addListener(_validatePasswordRealTime);
    _confirmPasswordController.addListener(_validateConfirmPasswordRealTime);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmailRealTime);
    _passwordController.removeListener(_validatePasswordRealTime);
    _confirmPasswordController.removeListener(_validateConfirmPasswordRealTime);
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation method
  bool _validateEmail(String email) {
    if (email.isEmpty) return true; // No error if empty
    
    // University email pattern - matches .edu domains and common university patterns
    final universityEmailRegex = RegExp(
      r'^[\w-\.]+@(.*\.)?(edu|ac\.[a-z]{2,}|university|college|school|institute)\.([a-z]{2,})',
      caseSensitive: false,
    );
    
    // Basic email pattern as fallback
    final basicEmailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    return universityEmailRegex.hasMatch(email) || basicEmailRegex.hasMatch(email);
  }

  // Password validation method
  bool _validatePassword(String password) {
    if (password.isEmpty) return true; // No error if empty
    return password.length >= 7;
  }

  // Confirm password validation method
  bool _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) return true; // No error if empty
    return confirmPassword == _passwordController.text;
  }

  // Real-time validation methods
  void _validateEmailRealTime() {
    final email = _emailController.text;
    setState(() {
      if (email.isNotEmpty && !_validateEmail(email)) {
        _emailErrorText = 'Please enter a valid university email address';
      } else {
        _emailErrorText = null;
      }
    });
  }

  void _validatePasswordRealTime() {
    final password = _passwordController.text;
    setState(() {
      if (password.isNotEmpty && !_validatePassword(password)) {
        _passwordErrorText = 'Password must be at least 7 characters long';
      } else {
        _passwordErrorText = null;
      }
      // Also re-validate confirm password when password changes
      _validateConfirmPasswordRealTime();
    });
  }

  void _validateConfirmPasswordRealTime() {
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      if (confirmPassword.isNotEmpty && !_validateConfirmPassword(confirmPassword)) {
        _confirmPasswordErrorText = 'Passwords do not match';
      } else {
        _confirmPasswordErrorText = null;
      }
    });
  }

  // --- Form Validation and Navigation Logic ---
  void _register() async {
    // Validate all fields and terms agreement
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Final validation check
      if (!_validateEmail(_emailController.text) || 
          !_validatePassword(_passwordController.text) ||
          !_validateConfirmPassword(_confirmPasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fix the validation errors before submitting.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Passwords do not match.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Call Firebase signup
      User? user = await FirebaseService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        studentId: _studentIdController.text,
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      if (user != null) {
        // Success - navigate to Home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms & Conditions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method for consistent input decoration styling
  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _darkBlue),
      prefixIcon: Icon(icon, color: _darkBlue),
      suffixIcon: suffixIcon,
      errorText: errorText,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _outlineDarkBlue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _outlineDarkBlue, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _outlineDarkBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 10.0,
      ),
    );
  }

  // Helper method for consistent text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    required bool isPassword,
    required bool isVisibleState,
    required ValueChanged<bool> toggleVisibility,
    String? errorText,
  }) {
    // Build suffix icon for password fields
    Widget? suffixIcon;
    if (isPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          isVisibleState ? Icons.visibility : Icons.visibility_off,
          color: _darkBlue,
        ),
        onPressed: () => toggleVisibility(!isVisibleState),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? !isVisibleState : obscureText,
            style: const TextStyle(color: _darkBlue),
            decoration: _buildInputDecoration(
              hint: hint,
              icon: icon,
              suffixIcon: suffixIcon,
              errorText: errorText,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Allow the body to resize/scroll when the keyboard appears
      resizeToAvoidBottomInset: true,
      backgroundColor: _brightBlue,
      body: SingleChildScrollView(
        // ⬅️ Enables scrolling
        child: Container(
          width: size.width,
          // Gradient background similar to the image
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_brightBlue, Color(0xFF87CEEB)],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                // Header Section
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: _brightBlue, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Join the community and start helping',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                // The White Card Container
                Container(
                  padding: const EdgeInsets.all(25.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Ensures card size fits content
                      children: <Widget>[
                        // Full Name Field
                        _buildTextFormField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'John Doe',
                          icon: Icons.person_outline,
                          isPassword: false,
                          isVisibleState: false,
                          toggleVisibility: (_) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        // Student ID Field
                        _buildTextFormField(
                          controller: _studentIdController,
                          label: 'Student ID',
                          hint: 'STU123456',
                          icon: Icons.badge_outlined,
                          isPassword: false,
                          isVisibleState: false,
                          toggleVisibility: (_) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your student ID';
                            }
                            return null;
                          },
                        ),
                        // University Email Field
                        _buildTextFormField(
                          controller: _emailController,
                          label: 'University Email',
                          hint: 'your.email@university.edu',
                          icon: Icons.email_outlined,
                          isPassword: false,
                          isVisibleState: false,
                          toggleVisibility: (_) {},
                          errorText: _emailErrorText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your university email';
                            }
                            if (!_validateEmail(value)) {
                              return 'Please enter a valid university email address';
                            }
                            return null;
                          },
                        ),
                        // Password Field
                        _buildTextFormField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          isPassword: true, // It is a password field
                          isVisibleState: _isPasswordVisible,
                          toggleVisibility: (newValue) {
                            setState(() => _isPasswordVisible = newValue);
                          },
                          errorText: _passwordErrorText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please create a password';
                            }
                            if (value.length < 7) {
                              return 'Password must be at least 7 characters long';
                            }
                            return null;
                          },
                        ),
                        // Confirm Password Field
                        _buildTextFormField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Re-enter password',
                          icon: Icons.lock_outline,
                          isPassword: true, // It is a password field
                          isVisibleState: _isConfirmPasswordVisible,
                          toggleVisibility: (newValue) {
                            setState(() => _isConfirmPasswordVisible = newValue);
                          },
                          errorText: _confirmPasswordErrorText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        // Terms & Conditions Checkbox
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _agreedToTerms = newValue!;
                                });
                              },
                              activeColor: _brightBlue,
                            ),
                            const Text(
                              'I agree to Terms & Conditions',
                              style: TextStyle(color: _darkBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Register Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // Gradient background for the button
                            gradient: const LinearGradient(
                              colors: [_brightBlue, Color(0xFF4C9AFF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Already have an account? Login link
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: _brightBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}