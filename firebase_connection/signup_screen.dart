import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracelink/firebase_service.dart';
import 'home.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Form Validation and Navigation Logic ---
  void _register() async {
  // Validate all fields and terms agreement
  if (_formKey.currentState!.validate() && _agreedToTerms) {
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
        return const Center(
          child: CircularProgressIndicator(),
        );
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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _darkBlue),
      prefixIcon: Icon(icon, color: _darkBlue),
      suffixIcon: suffixIcon,
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
    required bool
    isPassword, // New parameter to handle password visibility toggle
    required bool isVisibleState, // New parameter for current visibility state
    required ValueChanged<bool>
    toggleVisibility, // New parameter for state update
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
            // Use obscureText flag correctly based on current state
            obscureText: isPassword ? !isVisibleState : obscureText,
            style: const TextStyle(color: _darkBlue),
            decoration: _buildInputDecoration(
              hint: hint,
              icon: icon,
              suffixIcon: suffixIcon,
            ),
            validator:
                validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your $label';
                  }
                  return null;
                },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your University Email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Enter a valid email address';
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
                          isVisibleState:
                              _isPasswordVisible, // Use dedicated state
                          toggleVisibility: (newValue) {
                            setState(() => _isPasswordVisible = newValue);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please create a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
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
                          isVisibleState:
                              _isConfirmPasswordVisible, // Use dedicated state
                          toggleVisibility: (newValue) {
                            setState(
                              () => _isConfirmPasswordVisible = newValue,
                            );
                          },
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
                              backgroundColor:
                                  Colors.transparent, // Show gradient
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
                            // Action for "Login": close this screen as requested
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
                const SizedBox(
                  height: 40,
                ), // Extra padding for scrolling clearance
              ],
            ),
          ),
        ),
      ),
    );
  }
}
