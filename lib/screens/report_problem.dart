import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package

import 'package:tracelink/firebase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import your custom ThemeProvider
import '../theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'bottom_navigation.dart';

final supabase = Supabase.instance.client;

class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblem> {
  // Map for Firebase data: 'fullName', 'studentId', 'email' are expected keys
  Map<String, dynamic>? userData;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load real data when screen starts
  }

  // This will refresh the data when you come back to the profile page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only reload if data is null or if the provider/route changes significantly
    // We already load in initState, so calling it here too ensures refresh on navigation back
    if (userData == null && !isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    // Assuming FirebaseService.getUserData() fetches the required data (full name, student ID, email)
    Map<String, dynamic>? data = await FirebaseService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  // --- Define Color Palettes ---

  // Light Mode Colors (Based on original request)
  static const Color _light_brightBlue = Color(0xFF1E88E5);
  static const Color _light_lightBlueBackground = Color(0xFFE3F2FD);
  static const Color _light_darkBlueText = Color(0xFF0D47A1);
  static const Color _light_warningRed = Color(0xFFC70039);
  static const Color _light_cardColor = Colors.white;

  // Dark Mode Colors (Custom dark mode interpretation)
  static const Color _dark_brightBlue = Color(
    0xFF42A5F5,
  ); // Lighter bright blue for contrast
  static const Color _dark_darkBlueBackground = Color(
    0xFF121212,
  ); // Primary dark background
  static const Color _dark_lightBlueText = Color(
    0xFFE3F2FD,
  ); // Light blue for main text
  static const Color _dark_warningRed = Color(
    0xFFFF5252,
  ); // Brighter red for visibility
  static const Color _dark_cardColor = Color(
    0xFF1E1E1E,
  ); // Darker card background

  // Global key to uniquely identify the form and enable validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers for the input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _itemController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (userData == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User data not loaded.")));
        return;
      }

      final String fullName = userData!['fullName'];
      final String studentId = userData!['studentId'];

      try {
        await supabase.from('ReportProblems').insert({
          'created_at': DateTime.now().toIso8601String(),
          'Item Name': _itemController.text.trim(),
          'Description': _descriptionController.text.trim(),
          'Reported_User_ID': studentId,
          'Reported_User_name': fullName,
          'Complaint_User_Name': _usernameController.text.trim(),
        });

        // If insert succeeds → show success message
        _showSuccessDialog();
      } catch (e) {
        // Insert failed → show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to submit report: $e")));
      }
    }
  }

  // Function to show the success message dialog
  void _showSuccessDialog() {
    // Get the current theme mode to style the dialog correctly
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    final Color brightBlue = isDarkMode ? _dark_brightBlue : _light_brightBlue;
    final Color darkText = isDarkMode
        ? _dark_lightBlueText
        : _light_darkBlueText;
    final Color dialogBackground = isDarkMode
        ? _dark_cardColor
        : _light_cardColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: brightBlue),
              const SizedBox(width: 8),
              Text('Success!', style: TextStyle(color: darkText)),
            ],
          ),
          content: Text(
            'Report submitted successfully! Admin will review it.',
            style: TextStyle(color: darkText),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Clear the form fields
                _formKey.currentState!.reset();
                _usernameController.clear();
                _itemController.clear();
                _descriptionController.clear();
              },
              child: Text('OK', style: TextStyle(color: brightBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme provider and determine the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Set dynamic colors based on the theme mode
    final Color brightBlue = isDarkMode ? _dark_brightBlue : _light_brightBlue;
    final Color background = isDarkMode
        ? _dark_darkBlueBackground
        : _light_lightBlueBackground;
    final Color darkText = isDarkMode
        ? _dark_lightBlueText
        : _light_darkBlueText;
    final Color warningRed = isDarkMode ? _dark_warningRed : _light_warningRed;
    final Color cardColor = isDarkMode ? _dark_cardColor : _light_cardColor;
    final Color appBarGradientEnd = isDarkMode
        ? const Color(0xFF64B5F6)
        : const Color(0xFF42A5F5);
    final Color textFieldFill = isDarkMode
        ? const Color(0xFF2C2C2C)
        : Colors.white;
    final Color unselectedIconColor = isDarkMode ? Colors.white54 : Colors.grey;
    final Color appBarTextColor = isDarkMode
        ? Colors.black
        : Colors.white; // Text on the bright blue header

    return Scaffold(
      // Set the overall background dynamically
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Bright Blue Theme) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                // Use the bright blue for the header with a slight gradient
                gradient: LinearGradient(
                  colors: [
                    brightBlue,
                    appBarGradientEnd,
                  ], // Dynamic Bright Blue with a variation
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Back Arrow Button
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color:
                                  appBarTextColor, // Text/icon color on the app bar
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavScreen(),
                                ),
                              );
                            },
                          ),
                          Text(
                            'Report a Problem',
                            style: TextStyle(
                              color:
                                  appBarTextColor, // Text color on the app bar
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Help us keep the community safe and fair',
                        style: TextStyle(
                          color: appBarTextColor.withOpacity(
                            0.7,
                          ), // Subtext color on the app bar
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Form Content Section ---
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card: Report User Misconduct
                      Card(
                        elevation: isDarkMode ? 4 : 0,
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Icon
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: warningRed, // Dynamic warning red
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Report User Misconduct',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: darkText, // Dynamic text color
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Let us know if someone isn\'t cooperating',
                                style: TextStyle(
                                  color: darkText.withOpacity(0.6),
                                ), // Dynamic grey/faded text
                              ),
                              const SizedBox(height: 16),

                              // Username or ID Field
                              Text(
                                'Username or ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkText, // Dynamic text color
                                ),
                              ),
                              _buildInputField(
                                controller: _usernameController,
                                hintText: 'e.g., john_doe or STU123456',
                                icon: Icons.person_outline,
                                validatorText: 'Username or ID is required.',
                                darkText: darkText,
                                textFieldFill: textFieldFill,
                              ),
                              const SizedBox(height: 16),

                              // Item Name or ID Field
                              Text(
                                'Item Name or ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkText, // Dynamic text color
                                ),
                              ),
                              _buildInputField(
                                controller: _itemController,
                                hintText: 'e.g., Black Wallet',
                                icon: Icons.inventory_2_outlined,
                                validatorText: 'Item Name or ID is required.',
                                darkText: darkText,
                                textFieldFill: textFieldFill,
                              ),
                              const SizedBox(height: 16),

                              // Description of Issue Field
                              Text(
                                'Description of Issue',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkText, // Dynamic text color
                                ),
                              ),
                              _buildInputField(
                                controller: _descriptionController,
                                hintText:
                                    'Describe what happened and why you\'re reporting this user...',
                                icon: Icons.description_outlined,
                                maxLines: 4,
                                validatorText: 'Description is required.',
                                darkText: darkText,
                                textFieldFill: textFieldFill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Warning Box ---
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: brightBlue.withOpacity(
                              0.5,
                            ), // Dynamic bright blue border
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: warningRed, // Dynamic warning red
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please only submit genuine reports. False reports may result in action against your account.',
                                style: TextStyle(
                                  color: darkText, // Dynamic text color
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Submit Report Button (Bright Blue Theme) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor:
                              brightBlue, // Dynamic bright blue button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit Report',
                          style: TextStyle(
                            color:
                                appBarTextColor, // White/Black text on the bright blue button
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Helper function to build the custom TextFormField widgets
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String validatorText,
    required Color darkText,
    required Color textFieldFill,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      // Ensure the text input itself is the dynamic dark/light text color
      style: TextStyle(color: darkText),
      decoration: InputDecoration(
        hintText: hintText,
        // Icons should be the dynamic dark/light text color
        prefixIcon: Icon(icon, color: darkText),
        hintStyle: TextStyle(color: darkText.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: textFieldFill, // Dynamic fill color for text fields
        contentPadding: EdgeInsets.symmetric(
          vertical: (maxLines > 1 ? 12 : 0) + 8.0,
          horizontal: 10.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }
}
