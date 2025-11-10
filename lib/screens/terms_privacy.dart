import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

// --- Light Theme Colors (Bright Blue) ---
const Color _kPrimaryBrightBlue = Color(0xFF1E88E5); // Bright Blue
const Color _kDarkBlueText = Color(0xFF0D47A1); // Darker Blue for text
const Color _kLightBackgroundColor = Colors.white;

// --- Dark Theme Colors (Dark/Grey) ---
const Color _kDarkPrimaryColor = Color(
  0xFF303F9F,
); // A deep indigo for dark mode
const Color _kDarkBackgroundColor = Color(0xFF121212); // True black/dark grey
const Color _kDarkCardColor = Color(0xFF1F1F1F);
const Color _kDarkHighlightColor = Color(
  0xFFBBDEFB,
); // Light text color for dark mode

class TermsPrivacyScreen extends StatefulWidget {
  const TermsPrivacyScreen({super.key});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen> {
  int _selectedIndex = 0; // 0 for Terms, 1 for Privacy

  // --- Helper Widgets ---

  // Builds a card containing a single policy point with icon, title, and description
  Widget _buildPolicyPoint({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isDarkMode, // Pass dark mode status
  }) {
    final Color titleColor = isDarkMode ? _kDarkHighlightColor : _kDarkBlueText;
    // FIX: Added '!' for null safety assertion
    final Color descriptionColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: titleColor, // Dynamic title color
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: descriptionColor,
                    fontSize: 14,
                  ), // Dynamic description color
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content for the "Terms" tab
  Widget _buildTermsContent(bool isDarkMode) {
    final Color lastUpdatedBg = isDarkMode
        ? _kDarkCardColor
        : _kPrimaryBrightBlue.withOpacity(0.05);
    final Color lastUpdatedText = isDarkMode
        ? _kDarkHighlightColor
        : _kDarkBlueText;
    final Color cardOutlineColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kDarkBlueText;
    final Color primaryColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kPrimaryBrightBlue;
    final Color cardTitleColor = isDarkMode
        ? _kDarkHighlightColor
        : _kDarkBlueText;
    final Color cardBackground = isDarkMode
        ? _kDarkCardColor
        : _kLightBackgroundColor;

    // FIX: Added '!' for null safety assertion
    final Color cardBodyColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last Updated
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lastUpdatedBg,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Last Updated: November 2, 2025',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: lastUpdatedText,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Introduction
        Card(
          elevation: 0,
          color: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: cardOutlineColor), // Dynamic outline color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Introduction',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: cardTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to Lost & Found. By accessing or using our application, you agree to be bound by these Terms of Service. Please read them carefully.',
                  style: TextStyle(color: cardBodyColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 1. Acceptance of Terms
        Card(
          elevation: 0,
          color: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: cardOutlineColor), // Dynamic outline color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Acceptance of Terms',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: cardTitleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'By creating an account and using Lost & Found, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, you may not use the application.',
                  style: TextStyle(color: cardBodyColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: cardOutlineColor), // Dynamic outline color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2. User Responsibilities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: cardTitleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account.',
                  style: TextStyle(color: cardBodyColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Content for the "Privacy" tab
  Widget _buildPrivacyContent(bool isDarkMode) {
    final Color lastUpdatedBg = isDarkMode
        ? _kDarkCardColor
        : _kPrimaryBrightBlue.withOpacity(0.05);
    final Color lastUpdatedText = isDarkMode
        ? _kDarkHighlightColor
        : _kDarkBlueText;
    final Color cardOutlineColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kDarkBlueText;
    final Color primaryColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kPrimaryBrightBlue;
    final Color cardTitleColor = isDarkMode
        ? _kDarkHighlightColor
        : _kDarkBlueText;
    final Color cardBackground = isDarkMode
        ? _kDarkCardColor
        : _kLightBackgroundColor;

    // FIX: Added '!' for null safety assertion
    final Color cardBodyColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last Updated
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lastUpdatedBg,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Last Updated: November 2, 2025',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: lastUpdatedText,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Data We Collect
        Card(
          elevation: 0,
          color: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: cardOutlineColor), // Dynamic outline color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.storage_outlined, color: primaryColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Data We Collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: cardTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildPolicyPoint(
                  icon: Icons.person_outline,
                  iconColor: primaryColor,
                  title: 'Personal Information',
                  description:
                      'Name, email, student ID, and profile information you provide',
                  isDarkMode: isDarkMode,
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPolicyPoint(
                  icon: Icons.inventory_outlined,
                  iconColor: primaryColor,
                  title: 'Item Information',
                  description:
                      'Details about items reported, including photos and descriptions',
                  isDarkMode: isDarkMode,
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPolicyPoint(
                  icon: Icons.notifications_none,
                  iconColor: primaryColor,
                  title: 'Usage Data',
                  description:
                      'App interactions, preferences, and device information',
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
        // Additional simulated content to fill the screen if needed
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: cardOutlineColor), // Dynamic outline color
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How We Use Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: cardTitleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We use your data to provide, maintain, and improve our services, communicate with you, and ensure security.',
                  style: TextStyle(color: cardBodyColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // New Widget to build the tab button cleanly
  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required int index,
    required bool isDarkMode, // Pass dark mode status
  }) {
    final bool isSelected = _selectedIndex == index;

    // Dynamic tab colors
    final Color primaryColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kPrimaryBrightBlue;
    final Color selectedBg = primaryColor;
    final Color unselectedBg = isDarkMode
        ? _kDarkCardColor
        : _kLightBackgroundColor;

    final Color iconColor = isSelected
        ? Colors.white
        : (isDarkMode ? _kDarkHighlightColor : _kDarkBlueText);
    final Color textColor = isSelected
        ? Colors.white
        : (isDarkMode ? _kDarkHighlightColor : _kDarkBlueText);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(15.0) : Radius.zero,
              right: index == 1 ? const Radius.circular(15.0) : Radius.zero,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    // 1. Get the theme state
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // 2. Define dynamic main colors based on theme
    final Color primaryColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kPrimaryBrightBlue;
    final Color scaffoldBg = isDarkMode
        ? _kDarkBackgroundColor
        : Colors.grey[50]!;
    final Color tabBorderColor = isDarkMode
        ? _kDarkPrimaryColor
        : _kDarkBlueText;

    // Set status bar icon brightness
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: scaffoldBg, // Dynamic background
      body: CustomScrollView(
        slivers: [
          // Header Bar (SliverAppBar)
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: primaryColor, // Dynamic primary color background
            leadingWidth: 80.0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: primaryColor, // Dynamic color background
              ),
              titlePadding: const EdgeInsets.only(
                left: 100.0,
                top: kToolbarHeight + 20,
              ),
              centerTitle: false,
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Privacy',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Your rights and our policies',
                    style: TextStyle(fontSize: 14.0, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Tabs Section (Terms / Privacy)
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? _kDarkCardColor
                        : _kLightBackgroundColor, // Dynamic tab background
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          isDarkMode ? 0.3 : 0.15,
                        ),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: tabBorderColor,
                    ), // Dynamic border color
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(
                        label: 'Terms',
                        icon: Icons.description_outlined,
                        index: 0,
                        isDarkMode: isDarkMode,
                      ),
                      _buildTabButton(
                        label: 'Privacy',
                        icon: Icons.security_outlined,
                        index: 1,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _selectedIndex == 0
                    ? _buildTermsContent(isDarkMode) // Pass theme state
                    : _buildPrivacyContent(isDarkMode), // Pass theme state
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
