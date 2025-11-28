import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'settings.dart'; // Import the settings page
import '../../../theme_provider.dart'; // Import the ThemeProvider
import 'package:tracelink/firebase_service.dart';


// Define theme colors
const Color _brightBlue = Color(
  0xFF007AFF,
); // Bright Blue for the header/primary
const Color _darkBlue = Color(
  0xFF003C8F,
); // Dark Blue for text/accents in white sections
const Color _whiteText = Colors.white;

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  _PrivacySecurityScreenState createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // State variables for the switch toggles
  bool _profileVisibility = true;
  bool _showEmail = false;
  bool _showPhoneNumber = false;
  bool _twoFactorAuth = false;
  bool _loginNotifications = true;

  // --- Utility Functions ---

  // Function to show and hide a temporary pop-up message
  void _showStatusMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // Hide previous snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: _darkBlue.withOpacity(0.9), // Dark blue snackbar
      ),
    );
  }

  // Update the _handleSwitchChange function in privacy_security.dart
void _handleSwitchChange(String settingName, bool newValue) async {
  setState(() {
    // Update the correct state variable based on the setting name
    if (settingName == 'Profile Visibility') {
      _profileVisibility = newValue;
    } else if (settingName == 'Show Email') {
      _showEmail = newValue;
    } else if (settingName == 'Show Phone Number') {
      _showPhoneNumber = newValue;
    } else if (settingName == 'Two-Factor Authentication') {
      _twoFactorAuth = newValue;
    } else if (settingName == 'Login Notifications') {
      _loginNotifications = newValue;
    }
  });

  // Save to Firebase
  bool success = await FirebaseService.updatePrivacySettings(
    showEmail: _showEmail,
    showPhoneNumber: _showPhoneNumber,
    loginNotifications: _loginNotifications,
    profileVisibility: _profileVisibility,
    twoFactorAuth: _twoFactorAuth,
  );

  // Determine the action for the popup message
  String action = newValue ? 'enabled' : 'disabled';
  String message = success 
      ? '$settingName $action.'
      : 'Failed to update $settingName. Please try again.';
  
  _showStatusMessage(message);
}

// Add this method to load privacy settings when the screen initializes
@override
void initState() {
  super.initState();
  _loadPrivacySettings();
}

Future<void> _loadPrivacySettings() async {
  Map<String, dynamic>? privacySettings = await FirebaseService.getPrivacySettings();
  
  if (privacySettings != null) {
    setState(() {
      _profileVisibility = privacySettings['profileVisibility'] ?? true;
      _showEmail = privacySettings['showEmail'] ?? false;
      _showPhoneNumber = privacySettings['showPhoneNumber'] ?? false;
      _twoFactorAuth = privacySettings['twoFactorAuth'] ?? false;
      _loginNotifications = privacySettings['loginNotifications'] ?? true;
    });
  }
}

  // --- Widget Builders ---

  // Builds a card row with a title, subtitle, icon, and a Switch
  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _darkBlue,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _brightBlue, // Bright blue active color
            activeThumbColor: _darkBlue, // Dark blue thumb color
          ),
        ],
      ),
    );
  }

  // Builds a full section (Title, icon, and content)
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    Color? titleBackgroundColor,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkBlue, // Section title is dark blue
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 0),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: _darkBlue.withOpacity(0.1),
                width: 1.0,
              ), // Dark blue outline
            ),
            child: Container(
              padding: contentPadding ?? EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: titleBackgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider (not strictly used for colors here, but for context)
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set status bar color for consistent look
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness
            .light, // Icons are light because the header is dark (bright blue)
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Bright Blue Header Bar
          SliverAppBar(
            expandedHeight: 140.0,
            pinned: true,
            backgroundColor: _brightBlue, // Solid Bright Blue
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: _whiteText), // White icon
              onPressed: () {
                // Navigate to SettingsPage when top left button is clicked
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _brightBlue, // Solid Bright Blue background
              ),
              titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              centerTitle: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy & Security',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: _whiteText, // White text
                    ),
                  ),
                  Text(
                    'Manage your privacy settings and account security',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: _whiteText.withOpacity(0.7),
                    ), // Slightly faded white text
                  ),
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- 1. Privacy Settings ---
                _buildSection(
                  title: 'Privacy Settings',
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: _brightBlue, // Bright blue icon
                  children: [
                    // Profile Visibility
                    _buildSwitchRow(
                      icon: Icons.person_outline,
                      iconColor: _brightBlue, // Bright blue icon
                      title: 'Profile Visibility',
                      subtitle: 'Make your profile visible to other users',
                      value: _profileVisibility,
                      onChanged: (newValue) =>
                          _handleSwitchChange('Profile Visibility', newValue),
                    ),
                    Divider(height: 1),
                    // Show Email
                    _buildSwitchRow(
                      icon: Icons.public,
                      iconColor:
                          Colors.teal, // Kept different for visual separation
                      title: 'Show Email',
                      subtitle: 'Display email on your public profile',
                      value: _showEmail,
                      onChanged: (newValue) =>
                          _handleSwitchChange('Show Email', newValue),
                    ),
                    Divider(height: 1),
                    // Show Phone Number
                    _buildSwitchRow(
                      icon: Icons.phone_android_outlined,
                      iconColor:
                          Colors.green, // Kept different for visual separation
                      title: 'Show Phone Number',
                      subtitle: 'Display phone on your public profile',
                      value: _showPhoneNumber,
                      onChanged: (newValue) =>
                          _handleSwitchChange('Show Phone Number', newValue),
                    ),
                  ],
                ),

                // --- 2. Security Settings ---
                _buildSection(
                  title: 'Security Settings',
                  icon: Icons.security_outlined,
                  iconColor: _brightBlue, // Bright blue icon
                  children: [
                    // Two-Factor Authentication
                    _buildSwitchRow(
                      icon: Icons.lock_outline,
                      iconColor: _brightBlue, // Bright blue icon
                      title: 'Two-Factor Authentication',
                      subtitle: 'Enable to allow login via Student ID',
                      value: _twoFactorAuth,
                      onChanged: (newValue) => _handleSwitchChange(
                        'Two-Factor Authentication',
                        newValue,
                      ),
                    ),
                    Divider(height: 1),
                    // Login Notifications
                    _buildSwitchRow(
                      icon: Icons.notification_important_outlined,
                      iconColor: Colors.redAccent,
                      title: 'Login Notifications',
                      subtitle: 'Get notified of new login attempts',
                      value: _loginNotifications,
                      onChanged: (newValue) =>
                          _handleSwitchChange('Login Notifications', newValue),
                    ),
                  ],
                ),
                // --- 6. Privacy Notice ---
                _buildSection(
                  title: 'Privacy Notice',
                  icon: Icons.lock_outlined,
                  iconColor: _brightBlue, // Bright blue icon
                  titleBackgroundColor: Color(
                    0xFFF0F5FF,
                  ), // Light blue background
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'We take your privacy seriously. Your data is encrypted and never shared with third parties without your consent.',
                        style: TextStyle(
                          fontSize: 15,
                          color: _darkBlue,
                        ), // Dark blue text
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30), // Extra space at the bottom
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
