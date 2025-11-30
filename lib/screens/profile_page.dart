// profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/firebase_service.dart';
// Import your existing Supabase services
import 'package:tracelink/supabase_found_service.dart';
import 'package:tracelink/supabase_claims_service.dart';
import '../theme_provider.dart';
import 'settings.dart';
import 'logout.dart';
import 'edit_profile.dart';
import 'rewards.dart';
import 'bottom_navigation.dart';

// --- COLOR PALETTE ---
const Color brightBlueStart = Color(0xFF4A90E2);
const Color brightBlueEnd = Color(0xFF50E3C2);
const Color lightBackground = Color(0xFFF5F8FF);
const Color darkBackground = Color(0xFF121212);
const Color darkBlueText = Color(0xFF1E3A8A);
const Color lightBlueText = Color(0xFFE0E0E0);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Refresh data whenever dependencies change or we return to this page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoading) {
      setState(() {}); // Trigger rebuild to re-run FutureBuilders
    }
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

  void _navigateTo(BuildContext context, Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    // Refresh the profile when returning
    setState(() {});
  }

  // --- HELPER: Get Initials correctly ---
  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'U';
    List<String> nameParts = fullName.trim().split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0]; // First letter of first name
      if (nameParts.length > 1) {
        initials += nameParts[nameParts.length - 1][0]; // First letter of last name
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor = isDarkMode ? lightBlueText : darkBlueText;
    final bodyBackgroundColor = isDarkMode ? darkBackground : lightBackground;
    final cardBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Get the current user's Student ID to filter data
    final String myStudentId = userData?['studentId'] ?? '';
    final String fullName = userData?['fullName'] ?? 'User Name';
    final String userInitials = _getInitials(fullName);

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirebaseService.getPrivacySettings(),
        builder: (context, snapshot) {
          final privacySettings = snapshot.data;
          final showEmail = privacySettings?['showEmail'] ?? false;
          final showPhoneNumber = privacySettings?['showPhoneNumber'] ?? false;

          return CustomScrollView(
            slivers: [
              // --- Header Section ---
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 320.0,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Nav Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const BottomNavScreen()),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.settings, color: Colors.white, size: 30),
                                    onPressed: () => _navigateTo(context, const SettingsScreen()),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // Avatar with FIXED Initials Logic
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    gradient: const LinearGradient(colors: [brightBlueStart, brightBlueEnd]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      userInitials, // Using the fixed variable
                                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _navigateTo(context, const EditProfileScreen()),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.edit, color: brightBlueStart, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // User Info
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${userData?['studentId'] ?? '---'}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                if (showEmail && userData?['email'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(userData!['email'], style: const TextStyle(color: Colors.white70, fontSize: 15)),
                                  ),
                                if (showPhoneNumber && userData?['phoneNumber'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text('Phone: ${userData!['phoneNumber']}', style: const TextStyle(color: Colors.white70, fontSize: 15)),
                                  ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Body Content ---
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Impact',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
                        ),
                        const SizedBox(height: 15),

                        // --- LIVE DATA FETCHING ---
                        FutureBuilder<List<List<Map<String, dynamic>>>>(
                          // Fetch ALL items from Supabase
                          future: Future.wait([
                            SupabaseFoundService.fetchFoundItems(),
                            SupabaseClaimService.fetchClaimedItems(),
                          ]),
                          builder: (context, snapshot) {
                            int foundCount = 0;
                            int returnedCount = 0;

                            if (snapshot.hasData) {
                              final allFound = snapshot.data![0];
                              final allClaims = snapshot.data![1];

                              // FILTERING: Count only items where student_id matches current user
                              if (myStudentId.isNotEmpty) {
                                foundCount = allFound.where((item) {
                                  final id = item['student_id'] ?? item['studentId'];
                                  return id.toString() == myStudentId;
                                }).length;

                                returnedCount = allClaims.where((item) {
                                  final id = item['student_id'] ?? item['studentId'];
                                  return id.toString() == myStudentId;
                                }).length;
                              }
                            }

                            // Calculate Points for passing to Rewards Page
                            int totalPoints = (foundCount * 15) + (returnedCount * 25);
                            int level = (totalPoints / 100).floor();

                            return Column(
                              children: [
                                // Stats Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: _StatItem(
                                        count: '$foundCount',
                                        label: 'Items Found',
                                        icon: Icons.inventory_2_outlined,
                                        color: brightBlueStart,
                                        isDarkMode: isDarkMode,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _StatItem(
                                        count: '$returnedCount',
                                        label: 'Items Returned',
                                        icon: Icons.check_circle_outline,
                                        color: brightBlueEnd,
                                        isDarkMode: isDarkMode,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                
                                // Rewards Banner
                                GestureDetector(
                                  onTap: () {
                                    // Pass actual counts to Rewards Page
                                    _navigateTo(
                                      context, 
                                      RewardsPage(
                                        foundCount: foundCount, 
                                        returnedCount: returnedCount
                                      )
                                    );
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
                                          children: [
                                            const Text(
                                              'Rewards & Level',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Level $level • $totalPoints Points',
                                              style: const TextStyle(
                                                color: Colors.white,
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
                                            Icons.emoji_events_outlined,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
                          onTap: () => _navigateTo(context, const EditProfileScreen()),
                        ),
                        const SizedBox(height: 10),
                        _SettingsItem(
                          title: 'Notification Settings',
                          subtitle: 'Manage your notifications',
                          icon: Icons.notifications_none,
                          iconColor: const Color.fromARGB(255, 26, 180, 147),
                          isOutlined: true,
                          cardBackgroundColor: cardBackgroundColor,
                          onTap: () => _navigateTo(context, const SettingsScreen()),
                        ),
                        const SizedBox(height: 30),

                        // Log Out
                        OutlinedButton(
                          onPressed: () => _navigateTo(context, const LogoutConfirmationScreen()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: Colors.red, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 10),
                              Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
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
    final textColor = isDarkMode ? lightBlueText : const Color.fromARGB(255, 16, 46, 129);
    final secondaryTextColor = isDarkMode ? lightBlueText.withOpacity(0.7) : const Color.fromARGB(255, 17, 44, 121).withOpacity(0.7);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: secondaryTextColor, fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    final mainTextColor = cardBackgroundColor == Colors.white ? const Color.fromARGB(255, 17, 48, 134) : Colors.white;
    final subTextColor = mainTextColor.withOpacity(0.7);
    final outlineColor = const Color.fromARGB(255, 20, 51, 134).withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: isOutlined ? Border.all(color: outlineColor, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: mainTextColor, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}