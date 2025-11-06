import 'package:flutter/material.dart';

import 'logout.dart'; // Import the file containing LogoutConfirmationScreen

// Import the new destination pages (ensure these files exist)
import 'change_password.dart';
import 'privacy_security.dart';
import 'help_support.dart';
import 'terms_privacy.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Example state variables for the SwitchListTiles
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _emergencyAlerts = false;
  bool _darkMode = false;

  void _navigateTo(BuildContext context, Widget screen) {
    // Using push replacement for the back arrow (to go back to ProfileScreen)
    // Using push for all other navigation tiles
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  // --- Widget Builders (Your existing helpers) ---

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      activeColor: Colors.black, // Color for the 'on' state of the switch
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Add a slight background color for card contrast
      body: CustomScrollView(
        slivers: <Widget>[
          // Custom AppBar with a back button and title
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Navigate to 'profile_page.dart'
                Navigator.of(
                  context,
                ).pop(); // Simple pop, assuming Settings was pushed from ProfileScreen
                // If you want to force navigate to ProfileScreen (as in your original logic):
                // _navigateTo(context, const ProfileScreen());
              },
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Use SliverList for the rest of the content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // --- Account Section ---
              _buildSectionHeader(context, 'Account', Colors.deepPurple),
              _buildCard(
                children: [
                  _buildNavigationTile(
                    icon: Icons.lock_outline,
                    iconColor: Colors.deepPurple.shade300,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      // **NAVIGATION ADDED: Change Password**
                      _navigateTo(context, ChangePasswordScreen());
                    },
                  ),
                  const Divider(height: 0, indent: 20, endIndent: 20),
                  _buildNavigationTile(
                    icon: Icons.security,
                    iconColor: Colors.blue.shade300,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    onTap: () {
                      // **NAVIGATION ADDED: Privacy & Security**
                      _navigateTo(context, PrivacySecurityScreen());
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Notifications Section ---
              _buildSectionHeader(context, 'Notifications', Colors.deepPurple),
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_none,
                    iconColor: Colors.deepPurple.shade300,
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 0, indent: 20, endIndent: 20),
                  _buildSwitchTile(
                    icon: Icons.email_outlined,
                    iconColor: Colors.green.shade300,
                    title: 'Email Notifications',
                    subtitle: 'Receive email updates',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 0, indent: 20, endIndent: 20),
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: Colors.red.shade300,
                    title: 'Emergency Alerts',
                    subtitle: 'High priority notifications',
                    value: _emergencyAlerts,
                    onChanged: (value) {
                      setState(() {
                        _emergencyAlerts = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Appearance Section ---
              _buildSectionHeader(context, 'Appearance', Colors.deepPurple),
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.blueGrey.shade300,
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Support Section ---
              _buildSectionHeader(context, 'Support', Colors.green),
              _buildCard(
                children: [
                  _buildNavigationTile(
                    icon: Icons.help_outline,
                    iconColor: Colors.green.shade300,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () {
                      // **NAVIGATION ADDED: Help & Support**
                      _navigateTo(context, const HelpSupportScreen());
                    },
                  ),
                  const Divider(height: 0, indent: 20, endIndent: 20),
                  _buildNavigationTile(
                    icon: Icons.article_outlined,
                    iconColor: Colors.amber.shade300,
                    title: 'Terms & Privacy',
                    subtitle: 'Read our policies',
                    onTap: () {
                      // **NAVIGATION ADDED: Terms & Privacy**
                      _navigateTo(context, const TermsPrivacyScreen());
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- Log Out Button ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // NAVIGATION TO LOGOUT.DART
                    _navigateTo(context, const LogoutConfirmationScreen());
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.red, width: 0.5),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Version Number
              const Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }
}
