import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'settings.dart'; // Import the settings page
import '../theme_provider.dart'; // Import the ThemeProvider

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
  bool _anonymousData = true;

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

  // Generic function to handle switch changes
  void _handleSwitchChange(String settingName, bool newValue) {
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
      } else if (settingName == 'Anonymous Data Collection') {
        _anonymousData = newValue;
      }
    });

    // Determine the action for the popup message
    String action = newValue ? 'enabled' : 'disabled';
    _showStatusMessage('$settingName $action.');
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
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
                      subtitle: 'Add an extra layer of security',
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

                // --- 3. Data & Analytics ---
                _buildSection(
                  title: 'Data & Analytics',
                  icon: Icons.analytics_outlined,
                  iconColor: Colors.green, // Kept green
                  children: [
                    // Anonymous Data Collection
                    _buildSwitchRow(
                      icon: Icons.public_off,
                      iconColor: Colors.green,
                      title: 'Anonymous Data Collection',
                      subtitle:
                          'Help us improve the app with anonymous usage data',
                      value: _anonymousData,
                      onChanged: (newValue) => _handleSwitchChange(
                        'Anonymous Data Collection',
                        newValue,
                      ),
                    ),
                  ],
                ),

                // --- 4. Active Sessions ---
                _buildSection(
                  title: 'Active Sessions',
                  icon: Icons.laptop_mac_outlined,
                  iconColor: _brightBlue, // Bright blue icon
                  children: [
                    // Current Device (Green background)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Current Device',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: _darkBlue, // Dark blue text
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        'Active',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  ],
                                ),
                                Text(
                                  'iPhone 14 Pro • iOS 17',
                                  style: TextStyle(
                                    color: _darkBlue,
                                  ), // Dark blue text
                                ),
                                Text(
                                  'Last active: Just now',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    // MacBook Pro Session
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MacBook Pro',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _darkBlue, // Dark blue text
                                  ),
                                ),
                                Text(
                                  'Chrome • macOS',
                                  style: TextStyle(
                                    color: _darkBlue,
                                  ), // Dark blue text
                                ),
                                Text(
                                  'Last active: 2 hours ago',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _showStatusMessage(
                                'MacBook Pro session revoked!',
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Revoke',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15),
                    // Revoke All Other Sessions Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _showStatusMessage('All other sessions revoked!');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          'Revoke All Other Sessions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // --- 5. Your Data ---
                _buildSection(
                  title: 'Your Data',
                  icon: Icons.shield_outlined,
                  iconColor: _brightBlue, // Bright blue icon
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _darkBlue,
                            _brightBlue,
                          ], // Dark Blue to Bright Blue gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: _whiteText,
                              ), // White icon
                              SizedBox(width: 10),
                              Text(
                                'Your Data',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _whiteText, // White text
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Download or delete your personal data',
                            style: TextStyle(
                              color: _whiteText.withOpacity(0.7),
                            ), // Slightly faded white text
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showStatusMessage(
                                      'Data Download Initiated!',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Download Data',
                                    style: TextStyle(
                                      color: _darkBlue,
                                    ), // Dark blue text on white button
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showStatusMessage(
                                      'Account Deletion Requested!',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete Account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
