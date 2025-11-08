import 'package:flutter/material.dart';
import 'home.dart';
import 'settings.dart';
import 'accessibility.dart';
import 'logout.dart';
import 'edit_profile.dart';
import 'rewards.dart';

// --- COLOR PALETTE ---
const Color brightBlueStart = Color(0xFF4A90E2); // Bright Blue
const Color brightBlueEnd = Color(0xFF50E3C2); // Teal/Cyan End
const Color lightBackground = Color(0xFFF5F8FF); // Very Light Blue/White
const Color darkBlueText = Color(0xFF1E3A8A); // Darker Blue for content text

// --- DUMMY USER DATA MODEL ---
class _UserData {
  final String fullName;
  final String studentId;
  final String email;

  // Constructor updated to use required POSITIONAL arguments
  const _UserData(this.fullName, this.studentId, this.email);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key}); // Added key for best practice

  final _UserData userData = const _UserData(
    'Jane Doe',
    'STU789012',
    'jane.doe@uni.edu',
  );

  // --- Helper function for navigation ---
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        239,
        246,
        250,
      ), // Set main background to light blue
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Profile Summary) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 300.0, // Height to accommodate profile details
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                // Bright Blue Gradient
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [brightBlueStart, brightBlueEnd],
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ), // Added horizontal padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back Button (Top Left Corner Button)
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // Navigating back usually uses pop, but since there's a HomeScreen import,
                                  // I'm keeping the original logic to replace the current route.
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                },
                              ),
                              // Settings Button (Top Right Corner Button)
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _navigateTo(context, const SettingsScreen());
                                },
                              ),
                            ],
                          ),
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
                                  colors: [brightBlueStart, brightBlueEnd],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  // Safely get initials, assuming two words
                                  userData.fullName.contains(' ')
                                      ? '${userData.fullName.split(' ').first.substring(0, 1)}${userData.fullName.split(' ').last.substring(0, 1)}'
                                      : userData.fullName.substring(0, 1),
                                  style: const TextStyle(
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
                              child: GestureDetector(
                                onTap: () => _navigateTo(
                                  context,
                                  const EditProfileScreen(),
                                ),
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    color: brightBlueStart,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // User Info (DYNAMIC DATA)
                        Text(
                          userData.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${userData.studentId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          userData.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
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
                    Text(
                      'Your Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlueText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Stats Card (3 columns)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          count: '12',
                          label: 'Items Found',
                          icon: Icons.inventory_2_outlined,
                          color: brightBlueStart,
                        ),
                        _StatItem(
                          count: '8',
                          label: 'Items Returned',
                          icon: Icons.check_circle_outline,
                          color: brightBlueEnd,
                        ),
                        _StatItem(
                          count: '4.9',
                          label: 'Rating',
                          icon: Icons.star_border,
                          color: darkBlueText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // --- Rewards & Badges Banner (BRIGHT BLUE) ---
                    GestureDetector(
                      onTap: () {
                        _navigateTo(context, RewardsPage()); // Added const
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          // Bright Blue Gradient for Rewards section
                          gradient: const LinearGradient(
                            colors: [brightBlueStart, brightBlueEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: brightBlueStart.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
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

                    // --- Settings List Items (WITH DARK BLUE OUTLINE) ---

                    // Edit Profile
                    _SettingsItem(
                      title: 'Edit Profile',
                      subtitle: 'Update your information',
                      icon: Icons.edit_note,
                      iconColor: const Color.fromARGB(255, 45, 129, 224),
                      isOutlined: true, // Use outlined style
                      onTap: () {
                        _navigateTo(context, const EditProfileScreen());
                      },
                    ),
                    const SizedBox(height: 10),

                    // Notification Settings
                    _SettingsItem(
                      title: 'Notification Settings',
                      subtitle: 'Manage your notifications',
                      icon: Icons.notifications_none,
                      iconColor: const Color.fromARGB(255, 26, 180, 147),
                      isOutlined: true, // Use outlined style
                      onTap: () {
                        _navigateTo(context, const SettingsScreen());
                      },
                    ),
                    const SizedBox(height: 10),

                    // Language & Accessibility
                    _SettingsItem(
                      title: 'Language & Accessibility',
                      subtitle: 'Change language and accessibility options',
                      icon: Icons.language,
                      iconColor: const Color.fromARGB(255, 154, 47, 173),
                      isOutlined: true, // Use outlined style
                      onTap: () {
                        _navigateTo(context, const AccessibilityScreen());
                      },
                    ),

                    const SizedBox(height: 30),

                    // --- Log Out Button ---
                    OutlinedButton(
                      onPressed: () {
                        _navigateTo(context, const LogoutConfirmationScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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

// --- Helper Widgets (Updated for Outline Style) ---

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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(255, 16, 46, 129),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 17, 44, 121).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isOutlined; // New property to trigger the outlined style
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.isOutlined = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      // Outlined Card Style (for Edit Profile, Notifications, Language)
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white, // White background for the card
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromARGB(
                255,
                20,
                51,
                134,
              ).withOpacity(0.6), // Dark Blue Outline
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 48, 134),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          19,
                          51,
                          139,
                        ).withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      );
    }

    // Fallback: Default ListTile style (not used in this final version, but kept for logic safety)
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
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: darkBlueText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: darkBlueText.withOpacity(0.7)),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
