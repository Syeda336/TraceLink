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

// --- Static Icon Colors ---
const Color _deepPurpleColor = Color(0xFF673AB7);
const Color _primaryColor = Color(0xFF00B0FF); // Bright Blue

// --- USER DATA MODEL ---
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
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  // Manual refresh function
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _loadUserData();
  }

  void _navigateTo(BuildContext context, Widget page) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => page));

    // Refresh data when returning from edit profile (whether successful or not)
    if (page is EditProfileScreen) {
      await _refreshData();
    }
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

    //NEW
    if (isLoading) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bodyBackgroundColor, // Dynamic Background
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Profile Summary) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                // Bright Blue Gradient (remains the same as it's the brand color)
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back Button
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
                              // Settings Button
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

                              //CHANGEDDDDD
                              child: Center(
                                child: Text(
                                  // Safely get initials from Firebase data
                                  userData?['fullName'] != null &&
                                          (userData!['fullName'] as String)
                                              .contains(' ')
                                      ? '${(userData!['fullName'] as String).split(' ').first.substring(0, 1)}${(userData!['fullName'] as String).split(' ').last.substring(0, 1)}'
                                      : userData?['fullName'] != null
                                      ? (userData!['fullName'] as String)
                                            .substring(0, 1)
                                      : 'U', // Default if no name
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
                          userData?['fullName'] ?? 'User Name', // ← NEW
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${userData?['studentId'] ?? 'STU000000'}', // ← NEW
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          userData?['email'] ?? 'user@email.com', // ← NEW
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
                        color: primaryTextColor, // Dynamic Text Color
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
                          isDarkMode: isDarkMode, // Pass theme state
                        ),
                        _StatItem(
                          count: '8',
                          label: 'Items Returned',
                          icon: Icons.check_circle_outline,
                          color: brightBlueEnd,
                          isDarkMode: isDarkMode, // Pass theme state
                        ),
                        _StatItem(
                          count: '4.9',
                          label: 'Rating',
                          icon: Icons.star_border,
                          color: darkBlueText,
                          isDarkMode: isDarkMode, // Pass theme state
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // --- Rewards & Badges Banner (BRIGHT BLUE) ---
                    GestureDetector(
                      onTap: () {
                        _navigateTo(context, const RewardsPage());
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
                      isOutlined: true,
                      cardBackgroundColor: cardBackgroundColor, // Dynamic
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
                      isOutlined: true,
                      cardBackgroundColor: cardBackgroundColor, // Dynamic
                      onTap: () {
                        _navigateTo(context, const SettingsScreen());
                      },
                    ),
                    const SizedBox(height: 10),

                    // Language Dropdown (REPLACEMENT FOR Language & Accessibility)
                    _LanguageSettingTile(
                      cardBackgroundColor: cardBackgroundColor,
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

// --- Helper Widgets (Updated with dynamic colors) ---

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDarkMode; // New parameter

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
            color: textColor, // Dynamic Text Color
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: secondaryTextColor, // Dynamic Text Color
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
  final bool isOutlined;
  final Color cardBackgroundColor; // New parameter
  final VoidCallback? onTap;
  final Widget? trailingWidget; // New optional parameter for custom trailing

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.isOutlined = false,
    required this.cardBackgroundColor,
    this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text colors dynamically based on the card background
    final mainTextColor = cardBackgroundColor == Colors.white
        ? const Color.fromARGB(255, 17, 48, 134)
        : Colors.white;
    final subTextColor = mainTextColor.withOpacity(0.7);

    // The dark blue outline color
    final outlineColor = const Color.fromARGB(
      255,
      20,
      51,
      134,
    ).withOpacity(0.6);

    final actualTrailing =
        trailingWidget ??
        (onTap != null
            ? const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
            : null);

    if (isOutlined) {
      // Outlined Card Style
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardBackgroundColor, // Dynamic background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: outlineColor, // Static outline, or could be dynamic
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainTextColor, // Dynamic Text Color
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subTextColor, // Dynamic Text Color
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (actualTrailing != null) actualTrailing,
            ],
          ),
        ),
      );
    }

    // Fallback: Default ListTile style (not used in the current screen but kept for safety)
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
        style: TextStyle(fontWeight: FontWeight.bold, color: mainTextColor),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: subTextColor)),
      trailing: actualTrailing,
      onTap: onTap,
    );
  }
}

// --- NEW Widget for Language Setting with Dropdown (Stateful to manage selection) ---

class _LanguageSettingTile extends StatefulWidget {
  final Color cardBackgroundColor;

  const _LanguageSettingTile({required this.cardBackgroundColor});

  @override
  State<_LanguageSettingTile> createState() => __LanguageSettingTileState();
}

class __LanguageSettingTileState extends State<_LanguageSettingTile> {
  // Initial values for settings
  String _selectedLanguage = 'English'; // Default
  final List<String> _languages = ['English', 'Urdu'];

  @override
  Widget build(BuildContext context) {
    // The dark blue outline color
    final outlineColor = const Color.fromARGB(
      255,
      20,
      51,
      134,
    ).withOpacity(0.6);

    // Determine text colors dynamically based on the card background
    final mainTextColor = widget.cardBackgroundColor == Colors.white
        ? const Color.fromARGB(255, 17, 48, 134)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.cardBackgroundColor, // Dynamic background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: outlineColor, // Static outline, or could be dynamic
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _deepPurpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.language,
              color: _deepPurpleColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainTextColor, // Dynamic Text Color
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                // Dropdown Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: mainTextColor.withOpacity(
                      0.05,
                    ), // Light background for dropdown
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _primaryColor.withOpacity(0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLanguage,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: _primaryColor,
                      ),
                      dropdownColor: widget
                          .cardBackgroundColor, // Dynamic dropdown background
                      style: TextStyle(color: mainTextColor, fontSize: 16),
                      items: _languages.map<DropdownMenuItem<String>>((
                        String item,
                      ) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(color: mainTextColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                          // TODO: Implement actual language change logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Language set to $newValue'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
