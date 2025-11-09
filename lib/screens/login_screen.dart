<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'home.dart'; // Placeholder for the main app screen
import 'admin_welcome.dart'; // Placeholder for the admin screen
import 'signup_screen.dart'; // Placeholder for the sign-up screen
import 'forget_password.dart'; // Placeholder for the forget password screen (used as ResetPasswordScreen)

// Change to StatefulWidget to manage form key and controllers
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Global key for the Form widget to manage validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to capture input data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define the dark color scheme (copied from original code)
  static const Color darkBackgroundStart = Color.fromARGB(
    255,
    26,
    130,
    179,
  ); // Dark Slate
  static const Color darkBackgroundEnd = Color.fromARGB(
    255,
    84,
    180,
    224,
  ); // Slightly Lighter Slate
  static const Color darkAccentBlue = Color.fromARGB(
    255,
    47,
    173,
    223,
  ); // Deep Navy for text/outlines
  // Indigo for primary button contrast
  static const Color darkBlueText = Color.fromARGB(255, 36, 57, 172);

  // Dispose controllers to free up memory when the widget is removed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic Functions ---

  void _handleLogin() {
    // 1. Validate the form first
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with simulated user login

      // In a real app, you would perform API calls here.

      // Navigate to HomeScreen:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _handleAdminLogin() {
    // 1. Validate the form first
    if (_formKey.currentState!.validate()) {
      // Form is valid, check for admin credentials
      final email = _emailController.text;
      final password = _passwordController.text;

      // Dummy Admin Check:
      if (email == 'admin@uni.edu' && password == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminWelcome()),
        );
      } else {
        // Show error for unauthorized access
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin credentials required for this login route.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
  // --- End Login Logic Functions ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Main background gradient (DARKER)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkBackgroundStart, // New Dark Start
              darkBackgroundEnd, // New Dark End
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Heart icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.1,
                    ), // Adjusted for dark background
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white, // Text in dark section is WHITE
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Welcome Back! (Text in dark section is WHITE)
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline (Text in dark section is WHITE)
                const Text(
                  "Login to continue helping your community",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),
                // Main white card container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  // Form widget wrapping the inputs
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email label (Text in white section is DARK BLUE)
                        const Text(
                          "University Email / Student ID",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkBlueText, // Dark blue text
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email input field (TextFormField with validation)
                        TextFormField(
                          controller: _emailController,
                          // Validator to check if field is empty
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email or student ID.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "your.email@university.edu",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            // DARK BLUE OUTLINE styling
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: darkBlueText.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password label (Text in white section is DARK BLUE)
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkBlueText, // Dark blue text
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Password input field (TextFormField with validation)
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          // Validator to check if field is empty
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            suffixIcon: Icon(
                              Icons.visibility_off_outlined,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            // DARK BLUE OUTLINE styling
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: darkBlueText.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Forgot Password link (Text in white section is DARK BLUE)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Navigates to the forgot password screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // Assuming 'forget_password.dart' defines 'ResetPasswordScreen'
                                      const ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: darkBlueText, // Dark blue text
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Button (Gradient) - Calls _handleLogin
                        GestureDetector(
                          onTap: _handleLogin,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(
                                    255,
                                    28,
                                    110,
                                    143,
                                  ), // Dark blue start
                                  Color.fromARGB(
                                    255,
                                    15,
                                    91,
                                    136,
                                  ), // Indigo end
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Login as Admin Button (Bordered - Updated to dark blue) - Calls _handleAdminLogin
                        GestureDetector(
                          onTap: _handleAdminLogin,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: darkAccentBlue, // Dark blue border
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: darkBlueText, // Dark blue icon
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Login as Admin",
                                    style: TextStyle(
                                      color: darkBlueText, // Dark blue text
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                const SizedBox(height: 30),
                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ), // Text in dark section is WHITE
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Navigates to the sign up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white, // Text in dark section is WHITE
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'home.dart'; // Placeholder for the main app screen
import 'admin_welcome.dart'; // Placeholder for the admin screen
import 'signup_screen.dart'; // Placeholder for the sign-up screen
import 'forget_password.dart'; // Placeholder for the forget password screen (used as ResetPasswordScreen)

// Change to StatefulWidget to manage form key and controllers
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Global key for the Form widget to manage validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to capture input data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define the dark color scheme (copied from original code)
  static const Color darkBackgroundStart = Color.fromARGB(
    255,
    26,
    130,
    179,
  ); // Dark Slate
  static const Color darkBackgroundEnd = Color.fromARGB(
    255,
    84,
    180,
    224,
  ); // Slightly Lighter Slate
  static const Color darkAccentBlue = Color.fromARGB(
    255,
    47,
    173,
    223,
  ); // Deep Navy for text/outlines
  // Indigo for primary button contrast
  static const Color darkBlueText = Color.fromARGB(255, 36, 57, 172);

  // Dispose controllers to free up memory when the widget is removed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic Functions ---

  void _handleLogin() {
    // 1. Validate the form first
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with simulated user login

      // In a real app, you would perform API calls here.

      // Navigate to HomeScreen:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _handleAdminLogin() {
    // 1. Validate the form first
    if (_formKey.currentState!.validate()) {
      // Form is valid, check for admin credentials
      final email = _emailController.text;
      final password = _passwordController.text;

      // Dummy Admin Check:
      if (email == 'admin@uni.edu' && password == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminWelcome()),
        );
      } else {
        // Show error for unauthorized access
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin credentials required for this login route.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
  // --- End Login Logic Functions ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Main background gradient (DARKER)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkBackgroundStart, // New Dark Start
              darkBackgroundEnd, // New Dark End
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Heart icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.1,
                    ), // Adjusted for dark background
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white, // Text in dark section is WHITE
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Welcome Back! (Text in dark section is WHITE)
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline (Text in dark section is WHITE)
                const Text(
                  "Login to continue helping your community",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),
                // Main white card container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  // Form widget wrapping the inputs
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email label (Text in white section is DARK BLUE)
                        const Text(
                          "University Email / Student ID",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkBlueText, // Dark blue text
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email input field (TextFormField with validation)
                        TextFormField(
                          controller: _emailController,
                          // Validator to check if field is empty
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email or student ID.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "your.email@university.edu",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            // DARK BLUE OUTLINE styling
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: darkBlueText.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password label (Text in white section is DARK BLUE)
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 14,
                            color: darkBlueText, // Dark blue text
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Password input field (TextFormField with validation)
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          // Validator to check if field is empty
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            suffixIcon: Icon(
                              Icons.visibility_off_outlined,
                              color: darkBlueText.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            // DARK BLUE OUTLINE styling
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: darkBlueText.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: darkBlueText,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // Custom error border style
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Forgot Password link (Text in white section is DARK BLUE)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Navigates to the forgot password screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // Assuming 'forget_password.dart' defines 'ResetPasswordScreen'
                                      const ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: darkBlueText, // Dark blue text
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Button (Gradient) - Calls _handleLogin
                        GestureDetector(
                          onTap: _handleLogin,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(
                                    255,
                                    28,
                                    110,
                                    143,
                                  ), // Dark blue start
                                  Color.fromARGB(
                                    255,
                                    15,
                                    91,
                                    136,
                                  ), // Indigo end
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Login as Admin Button (Bordered - Updated to dark blue) - Calls _handleAdminLogin
                        GestureDetector(
                          onTap: _handleAdminLogin,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: darkAccentBlue, // Dark blue border
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: darkBlueText, // Dark blue icon
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Login as Admin",
                                    style: TextStyle(
                                      color: darkBlueText, // Dark blue text
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                const SizedBox(height: 30),
                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ), // Text in dark section is WHITE
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Navigates to the sign up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white, // Text in dark section is WHITE
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
>>>>>>> 6ab63f62a024b9d7eb22240c0a0c2d3890c511c1
