import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen

import 'settings.dart'; // File for Settings
import 'accessibility.dart';
import 'rewards.dart'; // File for Rewards & Badges screen
import 'logout.dart'; // Placeholder for the Logout Confirmation Screen
import 'edit_profile.dart';

// ---------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- Helper function for navigation ---
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Profile Summary) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 300.0, // Height to accommodate profile details
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                // Purple/Pink Gradient
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCC2B5E), Color(0xFF753A88)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Top Row: Back and Settings Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button (Top Left Corner Button) - Navigates to home.dart
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                // Functionality to open home.dart (using pushReplacement for clean stack)
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                            ),
                            // Settings Button (Top Right Corner Button) - Navigates to settings_page.dart
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                // Navigate to settings_page.dart
                                _navigateTo(context, const SettingsScreen());
                              },
                            ),
                          ],
                        ),
                        // Profile Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFCC2B5E),
                                    Color(0xFF753A88),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'JD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Edit Icon
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF753A88),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // User Info
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Student ID: STU123456',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        // Verified Student Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✓ Verified Student',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- Body Content (Stats and Settings) ---
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Stats Card (3 columns)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          count: '12',
                          label: 'Items Found',
                          icon: Icons.inventory_2_outlined,
                          color: Color(0xFF753A88),
                        ),
                        _StatItem(
                          count: '8',
                          label: 'Items Returned',
                          icon: Icons.show_chart,
                          color: Color(0xFFCC2B5E),
                        ),
                        _StatItem(
                          count: '4.9',
                          label: 'Rating',
                          icon: Icons.star_border,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // --- Rewards & Badges Banner (ADDED TAP FUNCTIONALITY) ---
                    GestureDetector(
                      onTap: () {
                        // Navigate to rewards.dart (RewardsScreen)
                        _navigateTo(context, RewardsPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          // Orange/Yellow Gradient
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFB743), Color(0xFFFF8C00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Rewards & Badges',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You have 3 new badges! Tap to view',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- Settings List Items ---

                    // Edit Profile
                    _SettingsItem(
                      title: 'Edit Profile',
                      subtitle: 'Update your information',
                      icon: Icons.edit_note,
                      iconColor: const Color(0xFF753A88),
                      onTap: () {
                        _navigateTo(context, const EditProfileScreen());
                      },
                    ),
                    const Divider(height: 1),

                    // Notification Settings
                    _SettingsItem(
                      title: 'Notification Settings',
                      subtitle: 'Manage your notifications',
                      icon: Icons.notifications_none,
                      iconColor: const Color(0xFF8DA3E9), // Light Blue/Purple
                      onTap: () {
                        _navigateTo(context, const SettingsScreen());
                      },
                    ),
                    const Divider(height: 1),

                    // Language & Accessibility
                    _SettingsItem(
                      title: 'Language & Accessibility',
                      subtitle: 'Change language and accessibility options',
                      icon: Icons.language,
                      iconColor: const Color(0xFF28B463), // Green
                      onTap: () {
                        _navigateTo(context, const AccessibilityScreen());
                      },
                    ),
                    const Divider(height: 1),

                    // Admin Dashboard (If applicable)
                    const _SettingsItem(
                      title: 'Admin Dashboard',
                      subtitle: 'Manage reports & users',
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: Color(0xFF753A88),
                      isButton: true,
                      // Add onTap: () { ... } if you have an AdminScreen
                    ),
                    const SizedBox(height: 30),

                    // --- Log Out Button (ADDED TAP FUNCTIONALITY) ---
                    OutlinedButton(
                      onPressed: () {
                        // Navigate to logout.dart (LogoutScreen)
                        _navigateTo(context, const LogoutConfirmationScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets (No changes needed, kept for completeness) ---

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isButton;
  final VoidCallback? onTap; // Added optional onTap callback

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.isButton = false,
    this.onTap, // Initialize the new parameter
  });

  @override
  Widget build(BuildContext context) {
    if (isButton) {
      // Special styling for Admin Dashboard
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: onTap, // Use the onTap callback
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              // Purple/Blue Gradient
              gradient: const LinearGradient(
                colors: [Color(0xFF8B45B4), Color(0xFF4B0082)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Standard list item style
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap, // Use the onTap callback for standard list items
    );
  }
}
