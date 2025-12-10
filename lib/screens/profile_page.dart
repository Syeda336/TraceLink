// 📁 profile_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/firebase_service.dart';
// Import your existing Supabase services
import 'package:tracelink/supabase_found_service.dart';
import 'package:tracelink/supabase_claims_service.dart';
// NEW IMPORT: Assuming this service handles fetching the image URL from Supabase
import 'package:tracelink/supabase_profile_service.dart';
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

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  Map<String, dynamic>? userData;
  // **NEW FIELD**
  String? profileImageUrl;
  bool isLoading = true;

  // 💡 Initialize Supabase service to call the Firestore method
  final SupabaseFoundService _foundService = SupabaseFoundService();
  final SupabaseClaimService _claimService = SupabaseClaimService();

  // 🔑 KEY ADDITION: Future to hold the result of both count fetches
  Future<List<int>>? _countFuture;

  @override
  void initState() {
    super.initState();
    // Start the initial data load
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Note: The logic in _loadUserData handles the refresh needed here
  }

  // MODIFIED: Now fetches main data, profile image URL, and initializes the count future
  Future<void> _loadUserData() async {
    // Set loading to true before fetching
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    Map<String, dynamic>? data = await FirebaseService.getUserData();
    String? imageUrl;
    String? studentId = data?['studentId']?.toString();

    // --- Data Fetching Logic ---
    if (data != null && studentId != null && studentId.isNotEmpty) {
      // 1. Fetch the image URL from Supabase
      imageUrl = await SupabaseProfileService.getProfileImage(studentId);

      // 2. Prepare the Future for item counts (Found and Claimed)
      _countFuture = Future.wait([
        _foundService.getUserFoundCount(studentId),
        _claimService.getUserClaimCount(studentId),
      ]);
    } else {
      // If no data or studentId, use a default empty future (0, 0)
      _countFuture = Future.value([0, 0]);
    }

    if (mounted) {
      setState(() {
        userData = data;
        profileImageUrl = imageUrl;
        isLoading = false; // Set loading to false once initial data is fetched
      });
    }
  }

  void _navigateTo(BuildContext context, Widget page) async {
    // Navigator.push returns a Future that completes when the pushed route is popped.
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => page));
    // Refresh the profile when returning, which re-initializes _countFuture
    if (mounted) {
      await _loadUserData();
    }
  }

  // --- HELPER: Get Initials correctly ---
  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'U';
    List<String> nameParts = fullName.trim().split(
      RegExp(r'\s+'),
    ); // Use regex to handle multiple spaces
    String initials = '';
    if (nameParts.isNotEmpty) {
      // Filter out empty strings that might result from splitting
      nameParts = nameParts.where((s) => s.isNotEmpty).toList();
      if (nameParts.isNotEmpty) {
        initials += nameParts.first[0]; // First letter of first name
        if (nameParts.length > 1) {
          initials += nameParts.last[0]; // First letter of last name
        }
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor = isDarkMode ? lightBlueText : darkBlueText;
    final bodyBackgroundColor = isDarkMode ? darkBackground : lightBackground;
    final cardBackgroundColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    // 🔑 CHECK for both main loading and future existence before building the screen
    if (isLoading || _countFuture == null) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String fullName = userData?['fullName'] ?? 'User Name';
    final String userInitials = _getInitials(fullName);

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirebaseService.getPrivacySettings(),
        builder: (context, privacySnapshot) {
          final privacySettings = privacySnapshot.data;
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
                                    onPressed: () => _navigateTo(
                                      context,
                                      const SettingsScreen(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // Avatar (Conditional Image/Initials Display)
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // Conditional Avatar Logic
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    gradient:
                                        (profileImageUrl == null ||
                                            profileImageUrl!.isEmpty)
                                        ? const LinearGradient(
                                            colors: [
                                              brightBlueStart,
                                              brightBlueEnd,
                                            ],
                                          )
                                        : null, // No gradient if image is present
                                    color:
                                        (profileImageUrl != null &&
                                            profileImageUrl!.isNotEmpty)
                                        ? Colors.transparent
                                        : brightBlueStart,
                                  ),
                                  child:
                                      (profileImageUrl != null &&
                                          profileImageUrl!.isNotEmpty)
                                      ? ClipOval(
                                          child: Image.network(
                                            profileImageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  // Fallback to initials if network image fails to load
                                                  return Center(
                                                    child: Text(
                                                      userInitials,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            userInitials,
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

                            // User Info
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${userData?['studentId'] ?? '---'}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
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
                                if (showPhoneNumber &&
                                    userData?['phoneNumber'] != null)
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // --- LIVE DATA FETCHING: Using the pre-initialized _countFuture ---
                        FutureBuilder<List<int>>(
                          future:
                              _countFuture, // 🔑 Uses the Future initialized in _loadUserData
                          builder: (context, countSnapshot) {
                            int foundCount = 0;
                            int returnedCount = 0;

                            if (countSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Use a subtle indicator since the rest of the screen is loaded
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(),
                                ),
                              );
                            } else if (countSnapshot.hasError) {
                              // Handle error case
                              return Center(
                                child: Text(
                                  'Error loading stats: ${countSnapshot.error}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            } else if (countSnapshot.hasData) {
                              // Correctly assign the data from the snapshot
                              foundCount = countSnapshot.data![0];
                              returnedCount = countSnapshot.data![1];
                            }

                            // Calculate Points for passing to Rewards Page
                            int totalPoints =
                                (foundCount * 15) + (returnedCount * 25);
                            // Basic level calculation
                            int level = totalPoints > 0
                                ? (totalPoints / 100).floor() + 1
                                : 1;

                            return Column(
                              children: [
                                // Stats Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: _StatItem(
                                        count:
                                            '$foundCount', // Displays fetched count
                                        label: 'Items Found',
                                        icon: Icons.inventory_2_outlined,
                                        color: brightBlueStart,
                                        isDarkMode: isDarkMode,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _StatItem(
                                        count:
                                            '$returnedCount', // Displays fetched count
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
                                        returnedCount: returnedCount,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          brightBlueStart,
                                          brightBlueEnd,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: brightBlueStart.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
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
                          cardBackgroundColor: cardBackgroundColor,
                          onTap: () =>
                              _navigateTo(context, const SettingsScreen()),
                        ),
                        const SizedBox(height: 30),

                        // Log Out
                        OutlinedButton(
                          onPressed: () => _navigateTo(
                            context,
                            const LogoutConfirmationScreen(),
                          ),
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

// -----------------------------------------------------------------------------
// --- Helper Widgets (Unchanged) ---
// -----------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    // Basic implementation placeholder
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? lightBlueText : darkBlueText,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.cardBackgroundColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color cardBackgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Determine text color based on the card background color
    final calculatedTextColor = cardBackgroundColor == darkBackground
        ? lightBlueText
        : darkBlueText;

    return Card(
      color: cardBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: calculatedTextColor, // Use calculated color
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: calculatedTextColor.withOpacity(0.7)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: calculatedTextColor.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
