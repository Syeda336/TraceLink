// profile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:tracelink/firebase_service.dart';
import '../theme_provider.dart'; // Import your ThemeProvider
import 'settings.dart';
import 'logout.dart';
import 'edit_profile.dart';
import 'rewards.dart';
import 'bottom_navigation.dart';

// --- COLOR PALETTE ---
const Color brightBlueStart = Color(0xFF4A90E2);
const Color brightBlueEnd = Color(0xFF50E3C2);
// Define Dark Mode equivalents for static colors
const Color lightBackground = Color(0xFFF5F8FF);
const Color darkBackground = Color(0xFF121212); // Darker background for body
const Color darkBlueText = Color(0xFF1E3A8A);
const Color lightBlueText = Color(0xFFE0E0E0); // Light text for Dark Mode

// ---  USER DATA MODEL ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData; // ← NEW: For Firebase data
  bool isLoading = true; // ← NEW: Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // ← NEW: Load real data when screen starts
  }

  // This will refresh the data when you come back to the profile page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await FirebaseService.getUserData();
    if (mounted) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    }
  }

  // Manual refresh function
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _loadUserData();
  }

  void _navigateTo(BuildContext context, Widget page) async {
    // Wait for the pushed page to close
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => page));

    // Refresh data when returning from edit profile (whether successful or not)
    //if (page is EditProfileScreen) {
    //refresh always
    await _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    // Access ThemeProvider state
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor = isDarkMode ? lightBlueText : darkBlueText;
    final bodyBackgroundColor = isDarkMode ? darkBackground : lightBackground;
    final cardBackgroundColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bodyBackgroundColor, // Dynamic Background
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirebaseService.getPrivacySettings(),
        builder: (context, snapshot) {
          final privacySettings = snapshot.data;
          final showEmail = privacySettings?['showEmail'] ?? false;
          final showPhoneNumber = privacySettings?['showPhoneNumber'] ?? false;

          return CustomScrollView(
            slivers: [
              // --- Header Section (Profile Summary) ---
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                // UPDATED: Increased height to fit email and phone without overflow
                expandedHeight: 350.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
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
                          // UPDATED: Use start + spacers to control vertical layout better
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Top Row: Back and Settings Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      _navigateTo(
                                        context,
                                        const SettingsScreen(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

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
                                      userData?['fullName'] != null &&
                                              (userData!['fullName'] as String)
                                                  .contains(' ')
                                          ? '${(userData!['fullName'] as String).split(' ').first.substring(0, 1)}${(userData!['fullName'] as String).split(' ').last.substring(0, 1)}'
                                          : userData?['fullName'] != null
                                          ? (userData!['fullName'] as String)
                                                .substring(0, 1)
                                          : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
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

                            const SizedBox(height: 12),

                            // UPDATED: Grouped user info to prevent layout spread/overflow
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  userData?['fullName'] ?? 'User Name',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${userData?['studentId'] ?? 'STU000000'}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),

                                // Conditionally show email
                                if (showEmail && userData?['email'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      userData!['email'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                // Conditionally show phone
                                if (showPhoneNumber &&
                                    userData?['phoneNumber'] != null &&
                                    userData!['phoneNumber']
                                        .toString()
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Phone: ${userData!['phoneNumber']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 15),

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

                            const Spacer(),
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
                            color: primaryTextColor,
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
                              isDarkMode: isDarkMode,
                            ),
                            _StatItem(
                              count: '8',
                              label: 'Items Returned',
                              icon: Icons.check_circle_outline,
                              color: brightBlueEnd,
                              isDarkMode: isDarkMode,
                            ),
                            _StatItem(
                              count: '4.9',
                              label: 'Rating',
                              icon: Icons.star_border,
                              color: darkBlueText,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Rewards Banner
                        GestureDetector(
                          onTap: () {
                            _navigateTo(context, const RewardsPage());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
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

                        // Settings Items
                        _SettingsItem(
                          title: 'Edit Profile',
                          subtitle: 'Update your information',
                          icon: Icons.edit_note,
                          iconColor: const Color.fromARGB(255, 45, 129, 224),
                          isOutlined: true,
                          cardBackgroundColor: cardBackgroundColor,
                          onTap: () =>
                              _navigateTo(context, const EditProfileScreen()),
                        ),
                        const SizedBox(height: 10),
                        _SettingsItem(
                          title: 'Notification Settings',
                          subtitle: 'Manage your notifications',
                          icon: Icons.notifications_none,
                          iconColor: const Color.fromARGB(255, 26, 180, 147),
                          isOutlined: true,
                          cardBackgroundColor: cardBackgroundColor,
                          onTap: () =>
                              _navigateTo(context, const SettingsScreen()),
                        ),
                        const SizedBox(height: 30),

                        // Log Out
                        OutlinedButton(
                          onPressed: () {
                            _navigateTo(
                              context,
                              const LogoutConfirmationScreen(),
                            );
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
          );
        },
      ),
    );
  }
}

// --- Helper Widgets (Kept same as provided) ---
class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode
        ? lightBlueText
        : const Color.fromARGB(255, 16, 46, 129);
    final secondaryTextColor = isDarkMode
        ? lightBlueText.withOpacity(0.7)
        : const Color.fromARGB(255, 17, 44, 121).withOpacity(0.7);

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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
        Text(label, style: TextStyle(color: secondaryTextColor, fontSize: 14)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isOutlined;
  final Color cardBackgroundColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.isOutlined = false,
    required this.cardBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainTextColor = cardBackgroundColor == Colors.white
        ? const Color.fromARGB(255, 17, 48, 134)
        : Colors.white;
    final subTextColor = mainTextColor.withOpacity(0.7);
    final outlineColor = const Color.fromARGB(
      255,
      20,
      51,
      134,
    ).withOpacity(0.6);

    if (isOutlined) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: outlineColor, width: 1.5),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainTextColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: subTextColor, fontSize: 13),
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
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
