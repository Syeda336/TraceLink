import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:tracelink/firebase_service.dart';

import 'logout.dart';
import 'change_password.dart';
import 'privacy_security.dart';
import 'help_support.dart';
import 'terms_privacy.dart';

// --- Theme Color Definitions ---
const brightBlueAccent = Color(0xFF1976D2);
const darkBlueTextColor = Color(0xFF0D47A1);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  // Removed _emailNotifications
  bool _emergencyAlerts = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await FirebaseService.getNotificationSettings();
    if (settings != null && mounted) {
      setState(() {
        _pushNotifications = settings['pushEnabled'] ?? true;
        // Removed emailEnabled check
        _emergencyAlerts = settings['emergencyEnabled'] ?? false;
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSettings() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    
    try {
      await FirebaseService.updateNotificationPreferences(
        pushEnabled: _pushNotifications,
        // Removed emailEnabled argument
        emergencyEnabled: _emergencyAlerts,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Notification settings updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
        );
      }
      
      print(' Settings updated successfully');
      
    } catch (e) {
      print(' Error updating settings: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update settings. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          )
        );
        
        await _loadSettings();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  // --- Widget Builders ---

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    bool isDarkMode,
  ) {
    final Color color = isDarkMode
        ? Colors.lightBlue.shade300
        : brightBlueAccent;

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

  Widget _buildCard({
    required List<Widget> children,
    required bool isDarkMode,
  }) {
    final Color cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.grey.shade700
        : brightBlueAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
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
    required bool isDarkMode,
  }) {
    final Color primaryTextColor = isDarkMode
        ? Colors.white
        : darkBlueTextColor;
    final Color secondaryTextColor = primaryTextColor.withOpacity(
      isDarkMode ? 0.7 : 0.6,
    );

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: primaryTextColor),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: secondaryTextColor)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: secondaryTextColor,
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
    required bool isDarkMode,
  }) {
    final Color primaryTextColor = isDarkMode
        ? Colors.white
        : darkBlueTextColor;
    final Color secondaryTextColor = primaryTextColor.withOpacity(
      isDarkMode ? 0.7 : 0.6,
    );
    final Color activeSwitchColor = isDarkMode
        ? Colors.lightBlue.shade300
        : brightBlueAccent;

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: primaryTextColor),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: secondaryTextColor)),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      activeColor: activeSwitchColor,
      activeTrackColor: activeSwitchColor.withOpacity(0.5),
      inactiveThumbColor: isDarkMode
          ? Colors.grey.shade600
          : Colors.grey.shade400,
      inactiveTrackColor: isDarkMode
          ? Colors.grey.shade700
          : Colors.grey.shade200,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color accentColor = isDarkMode
        ? Colors.lightBlue.shade300
        : brightBlueAccent;
    final Color appBarAndCardColor = isDarkMode
        ? Colors.grey.shade900
        : Colors.white;
    final Color backgroundCanvasColor = isDarkMode
        ? Colors.black
        : Colors.grey.shade50;
    final Color appBarIconColor = isDarkMode ? Colors.white : darkBlueTextColor;
    final Color bodyTextColor = isDarkMode ? Colors.white : darkBlueTextColor;

    return Scaffold(
      backgroundColor: backgroundCanvasColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: appBarAndCardColor,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: appBarIconColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: appBarIconColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // --- Account Section ---
              _buildSectionHeader(context, 'Account', isDarkMode),
              _buildCard(
                isDarkMode: isDarkMode,
                children: [
                  _buildNavigationTile(
                    icon: Icons.lock_outline,
                    iconColor: accentColor,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      _navigateTo(context, const ChangePasswordScreen());
                    },
                    isDarkMode: isDarkMode,
                  ),
                  Divider(
                    height: 0,
                    indent: 20,
                    endIndent: 20,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  _buildNavigationTile(
                    icon: Icons.security,
                    iconColor: accentColor,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    onTap: () {
                      _navigateTo(context, const PrivacySecurityScreen());
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Notifications Section ---
              _buildSectionHeader(context, 'Notifications', isDarkMode),
              _buildCard(
                isDarkMode: isDarkMode,
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_none,
                    iconColor: accentColor,
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                      _updateSettings();
                    },
                    isDarkMode: isDarkMode,
                  ),
                  // Removed Email Notifications Switch and its Divider
                  Divider(
                    height: 0,
                    indent: 20,
                    endIndent: 20,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: Colors.redAccent,
                    title: 'Emergency Alerts',
                    subtitle: 'High priority notifications',
                    value: _emergencyAlerts,
                    onChanged: (value) {
                      setState(() {
                        _emergencyAlerts = value;
                      });
                      _updateSettings();
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Appearance Section ---
              _buildSectionHeader(context, 'Appearance', isDarkMode),
              _buildCard(
                isDarkMode: isDarkMode,
                children: [
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: accentColor,
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Support Section ---
              _buildSectionHeader(context, 'Support', isDarkMode),
              _buildCard(
                isDarkMode: isDarkMode,
                children: [
                  _buildNavigationTile(
                    icon: Icons.help_outline,
                    iconColor: accentColor,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () {
                      _navigateTo(context, const HelpSupportScreen());
                    },
                    isDarkMode: isDarkMode,
                  ),
                  Divider(
                    height: 0,
                    indent: 20,
                    endIndent: 20,
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  _buildNavigationTile(
                    icon: Icons.article_outlined,
                    iconColor: accentColor,
                    title: 'Terms & Privacy',
                    subtitle: 'Read our policies',
                    onTap: () {
                      _navigateTo(context, const TermsPrivacyScreen());
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- Log Out Button ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigateTo(context, const LogoutConfirmationScreen());
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarAndCardColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: accentColor, width: 1.5),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Version Number
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: bodyTextColor.withOpacity(0.5),
                    fontSize: 16,
                  ),
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