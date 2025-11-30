import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

// --- Theme Color Definitions ---
// Light Theme
const Color _kPrimaryBrightBlue = Color(0xFF1E88E5);
const Color _kLightBg = Color(0xFFF5F7FA);
const Color _kLightCard = Colors.white;
const Color _kLightTextPrimary = Color(0xFF0D47A1);
const Color _kLightTextSecondary = Color(0xFF546E7A);

// Dark Theme
const Color _kDarkPrimaryColor = Color(0xFF3949AB);
const Color _kDarkBg = Color(0xFF121212);
const Color _kDarkCard = Color(0xFF1E1E1E);
const Color _kDarkTextPrimary = Color(0xFFE3F2FD);
const Color _kDarkTextSecondary = Color(0xFFB0BEC5);

class TermsPrivacyScreen extends StatefulWidget {
  const TermsPrivacyScreen({super.key});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen> {
  int _selectedIndex = 0; // 0 for Terms, 1 for Privacy

  // --- Helper Widgets ---

  /// Builds a section header text (e.g., "Last Updated")
  Widget _buildMetaInfo(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// Builds a modern expandable legal section
  Widget _buildExpandableSection({
    required String title,
    required String content,
    required IconData icon,
    required bool isDarkMode,
    bool initiallyExpanded = false,
  }) {
    final Color cardColor = isDarkMode ? _kDarkCard : _kLightCard;
    final Color titleColor = isDarkMode ? _kDarkTextPrimary : _kLightTextPrimary;
    final Color contentColor = isDarkMode ? _kDarkTextSecondary : _kLightTextSecondary;
    final Color iconColor = isDarkMode ? _kDarkPrimaryColor : _kPrimaryBrightBlue;
    final Color borderColor = isDarkMode ? Colors.white10 : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: titleColor,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(
              content,
              style: TextStyle(
                color: contentColor,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Content Generators ---

  Widget _buildTermsContent(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaInfo('Last Updated: November 30, 2025', isDarkMode),
        
        // Introduction Card
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDarkMode ? _kDarkPrimaryColor.withOpacity(0.2) : _kPrimaryBrightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDarkMode ? _kDarkPrimaryColor.withOpacity(0.3) : _kPrimaryBrightBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Tracelink",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? _kDarkTextPrimary : _kLightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "By accessing or using our application, you agree to be bound by these Terms of Service. These terms constitute a legally binding agreement.",
                style: TextStyle(
                  color: isDarkMode ? _kDarkTextSecondary : _kLightTextSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // Legal Sections
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "1. Acceptance of Terms",
          icon: Icons.check_circle_outline,
          content: "By creating an account and using Tracelink, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, you may not access or use the application.",
          initiallyExpanded: true,
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "2. User Responsibilities",
          icon: Icons.person_outline,
          content: "You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account. You are solely responsible for all activities that occur under your account.",
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "3. Prohibited Activities",
          icon: Icons.block_outlined,
          content: "Users may not use the app to post false claims, harass other users, or upload malicious content. Any fraudulent activity regarding lost or found items will result in immediate account termination.",
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "4. Intellectual Property",
          icon: Icons.copyright_outlined,
          content: "The design, trademarks, and content of the Tracelink app are the property of the Owners. You may not copy, modify, or distribute any part of this application without prior written consent.",
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "5. Termination",
          icon: Icons.gavel_outlined,
          content: "We reserve the right to suspend or terminate your account at our sole discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users.",
        ),
      ],
    );
  }

  Widget _buildPrivacyContent(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaInfo('Effective Date: November 30, 2025', isDarkMode),

        Text(
          "Your Privacy Matters",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _kDarkTextPrimary : _kLightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We are committed to protecting your personal information and your right to privacy. Here is a transparent breakdown of how we handle your data.",
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? _kDarkTextSecondary : _kLightTextSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "Data We Collect",
          icon: Icons.data_usage_outlined,
          content: "• Personal Data: Name, Student ID, Email Address.\n• Item Data: Photos and descriptions of lost/found items.\n• Usage Data: App interaction history and crash logs for performance improvement.",
          initiallyExpanded: true,
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "How We Use Data",
          icon: Icons.settings_suggest_outlined,
          content: "We use your data strictly to:\n1. Facilitate the return of lost items.\n2. Verify your identity within the organization.\n3. Communicate updates regarding your reports.\n\nWe do not sell your data to third-party advertisers.",
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "Data Security",
          icon: Icons.lock_outline,
          content: "We implement industry-standard security measures including encryption and secure server storage to protect your personal information from unauthorized access, alteration, or destruction.",
        ),
        _buildExpandableSection(
          isDarkMode: isDarkMode,
          title: "Your Rights",
          icon: Icons.accessibility_new_outlined,
          content: "You have the right to request access to the personal data we hold about you, request corrections, or request deletion of your account and associated data via the Settings menu.",
        ),
      ],
    );
  }

  // --- Tab Button Widget ---
  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required int index,
    required bool isDarkMode,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color primaryColor = isDarkMode ? _kDarkPrimaryColor : _kPrimaryBrightBlue;
    final Color selectedBg = primaryColor;
    final Color unselectedBg = Colors.transparent;
    
    final Color selectedText = Colors.white;
    final Color unselectedText = isDarkMode ? _kDarkTextSecondary : _kLightTextSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                color: isSelected ? selectedText : unselectedText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? selectedText : unselectedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Main Build ---

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    final Color scaffoldBg = isDarkMode ? _kDarkBg : _kLightBg;
    final Color headerStart = isDarkMode ? const Color(0xFF1A237E) : const Color(0xFF1E88E5);
    final Color headerEnd = isDarkMode ? const Color(0xFF283593) : const Color(0xFF42A5F5);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // 1. Professional Gradient Header
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: headerStart,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [headerStart, headerEnd],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.gavel,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 90, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Terms and Privacy',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Your rights, responsibilities & privacy',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2. Floating Tab Bar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDarkMode ? _kDarkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      label: 'Terms of Service',
                      icon: Icons.description,
                      index: 0,
                      isDarkMode: isDarkMode,
                    ),
                    _buildTabButton(
                      label: 'Privacy Policy',
                      icon: Icons.security,
                      index: 1,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AnimatedCrossFade(
                  firstChild: _buildTermsContent(isDarkMode),
                  secondChild: _buildPrivacyContent(isDarkMode),
                  crossFadeState: _selectedIndex == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}