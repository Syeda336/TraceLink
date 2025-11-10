import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'home.dart';
import 'profile_page.dart';
import 'community_feed.dart';
import 'upload_image.dart';
import 'search_lost.dart';
import 'messages.dart';
import '../theme_provider.dart'; // Import the ThemeProvider

// --- Color Palette for Blue Theme (Used as Primary/Accent) ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// ----------------------------------------------------------------------
// --- REPORT FOUND ITEM SCREEN (THE MAIN CLASS) --------------------------
// ----------------------------------------------------------------------

class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({super.key});

  @override
  State<ReportFoundItemScreen> createState() => _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  int _selectedIndex = 0;

  void _navigateToScreen(BuildContext context, Widget screen) {
    // This is generally safe for navigating to a detail page
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    // Using pushReplacement for main tabs to prevent back-stack buildup
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1: // Browse
        _navigateToScreen(context, const SearchLost());
        break;
      case 2: // Feed
        _navigateToScreen(context, const CommunityFeed());
        break;
      case 3: // Chat
        _navigateToScreen(context, const MessagesListScreen());
        break;
      case 4: // Profile
        _navigateToScreen(context, const ProfileScreen());
        break;
    }
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }
  // --- END BOTTOM NAV LOGIC ---

  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State for checkboxes
  bool _reportAnonymously = false;
  bool _leftWithSecurity = false;

  // Placeholder for uploaded image path (received from UploadPhotosScreen)
  String? _uploadedImagePath;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Function to handle opening the image upload screen
  Future<void> _openImageUploadScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadPhotosScreen()),
    );

    if (result is String) {
      setState(() {
        _uploadedImagePath =
            result; // Assuming it returns the path of the first image
      });
    }
  }

  // Function to handle form submission
  void _submitReport() {
    // Basic validation check for required fields
    if (_formKey.currentState!.validate()) {
      // If validation passes, show the submission message popup
      _showSubmissionMessage();
    }
  }

  // Function to show the submission success message dialog
  void _showSubmissionMessage() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap OK to dismiss
      builder: (BuildContext context) {
        // Use Theme.of(context) here for dynamic colors
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: theme.scaffoldBackgroundColor, // Dynamic background
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: primaryBlue,
              ), // Blue icon
              const SizedBox(width: 8),
              Text(
                'Thank You!',
                style: TextStyle(color: theme.textTheme.titleLarge?.color),
              ), // Dynamic text color
            ],
          ),
          content: Text(
            'Your report has been submitted. We appreciate your help!',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ), // Dynamic text color
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to home.dart after closing the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: darkBlue),
              ), // Blue text button
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define dynamic colors based on the theme
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color inputHintColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Blue Gradient) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false, // Handle back button custom
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Blue gradient remains constant regardless of dark mode for branding
                gradient: LinearGradient(
                  colors: [primaryBlue, darkBlue], // Blue shades
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Back Arrow Button (Top Left Corner Button)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Functionality to open home.dart
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Report Found Item',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Thank you Card (Light Blue/Dynamic) ---
                      Card(
                        elevation: 0,
                        // Use lightBlueBackground or a dynamic color in dark mode
                        color: isDarkMode
                            ? darkBlue.withOpacity(0.3)
                            : lightBlueBackground.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: primaryBlue.withOpacity(
                              0.3,
                            ), // Light blue border
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.archive_outlined,
                                color:
                                    darkBlue, // Dark blue icon (Constant branding)
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thank you for helping!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            darkBlue, // Dark blue text (Constant branding)
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Your report will help reunite someone with their lost item',
                                      style: TextStyle(
                                        color: darkBlue.withOpacity(
                                          0.8,
                                        ), // Slightly lighter dark blue text
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

                      // --- Upload Image Section ---
                      _buildLabel('Upload Image', textColor),
                      GestureDetector(
                        onTap: _openImageUploadScreen, // Use the new function
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? inputFillColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: primaryBlue, // Bright blue border
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.upload_outlined,
                                size: 40,
                                color: primaryBlue, // Bright blue icon
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Upload Photo',
                                style: TextStyle(
                                  color: darkBlue, // Dark blue text
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _uploadedImagePath != null
                                    ? '1 photo uploaded'
                                    : 'Clear photo helps identification',
                                style: TextStyle(
                                  color: _uploadedImagePath != null
                                      ? darkBlue
                                      : inputHintColor, // Dynamic hint color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Description ---
                      _buildLabel('Description', textColor),
                      _buildInputField(
                        controller: _descriptionController,
                        hintText: 'Describe the item you found...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 20),

                      // --- Where did you find it? ---
                      _buildLabel('Where did you find it?', textColor),
                      _buildInputField(
                        controller: _locationController,
                        hintText: 'e.g., Cafeteria Entrance',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 20),

                      // --- Report Anonymously Checkbox ---
                      _buildCheckboxCard(
                        title: 'Report anonymously',
                        subtitle: 'Your identity will remain private',
                        value: _reportAnonymously,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _reportAnonymously = newValue ?? false;
                          });
                        },
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),

                      // --- Left with campus security Checkbox ---
                      _buildCheckboxCard(
                        title: 'Left with campus security',
                        subtitle:
                            'Item has been turned in to campus guard/security',
                        value: _leftWithSecurity,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _leftWithSecurity = newValue ?? false;
                          });
                        },
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button (Blue Gradient) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style:
                            ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              // Transparent background is needed for the Ink widget's gradient
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                              side: WidgetStateProperty.all(BorderSide.none),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 18),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryBlue, darkBlue], // Blue shades
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(minHeight: 50.0),
                            child: const Text(
                              'Submit Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, color: _getIconColor(2)),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, color: _getIconColor(3)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: inputHintColor, // Dynamic grey color
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor, // Dynamic background
        elevation: 10,
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isDarkMode,
    String? validatorText,
    IconData? icon,
    int maxLines = 1,
  }) {
    final Color inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color inputHintColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey;
    final Color inputTextColor = isDarkMode ? Colors.white : Colors.black;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: inputTextColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: inputHintColor),
        prefixIcon: icon != null ? Icon(icon, color: inputHintColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: (maxLines > 1 ? 12 : 0) + 8.0,
          horizontal: 10.0,
        ),
      ),
      validator: (value) {
        if (validatorText != null && (value == null || value.isEmpty)) {
          return validatorText;
        }
        return null;
      },
    );
  }

  Widget _buildCheckboxCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isDarkMode,
  }) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subtitleColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final Color cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;

    return Card(
      elevation: 0,
      color: cardColor, // Dynamic card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDarkMode ? Colors.grey.shade700 : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: primaryBlue, // Bright blue checkbox color
              checkColor: isDarkMode
                  ? Colors.black
                  : Colors.white, // Ensure visibility of check mark
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor, // Dynamic text color
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ), // Dynamic text color
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
