import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }) {
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content for the "Terms" tab
  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last Updated
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05), // Light blue background
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Last Updated: November 2, 2025',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Introduction
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                        color: const Color(0xFF8B42F8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Color(0xFF8B42F8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Introduction',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to Lost & Found. By accessing or using our application, you agree to be bound by these Terms of Service. Please read them carefully.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 1. Acceptance of Terms
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Acceptance of Terms',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'By creating an account and using Lost & Found, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, you may not use the application.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. User Responsibilities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Content for the "Privacy" tab
  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last Updated
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05), // Light blue background
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Last Updated: November 2, 2025',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Data We Collect
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.storage_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Data We Collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildPolicyPoint(
                  icon: Icons.person_outline,
                  iconColor: Colors.deepPurple,
                  title: 'Personal Information',
                  description:
                      'Name, email, student ID, and profile information you provide',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPolicyPoint(
                  icon: Icons.inventory_outlined,
                  iconColor: const Color(0xFFE94B8A), // Pink
                  title: 'Item Information',
                  description:
                      'Details about items reported, including photos and descriptions',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPolicyPoint(
                  icon: Icons.notifications_none,
                  iconColor: Colors.blueGrey,
                  title: 'Usage Data',
                  description:
                      'App interactions, preferences, and device information',
                ),
              ],
            ),
          ),
        ),
        // Additional simulated content to fill the screen if needed
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How We Use Data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'We use your data to provide, maintain, and improve our services, communicate with you, and ensure security.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
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
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color iconColor = isSelected ? Colors.white : Colors.black87;
    final Color textColor = isSelected ? Colors.white : Colors.black87;

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
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF8B42F8), Color(0xFFE94B8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
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
    // Set status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50], // Consistent light background
      body: CustomScrollView(
        slivers: [
          // Gradient Header Bar (SliverAppBar)
          SliverAppBar(
            expandedHeight: 200.0, // Adjusted height
            pinned: true,
            backgroundColor:
                Colors.transparent, // Required for gradient to show
            leadingWidth: 80.0, // Give more space for the custom leading widget
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 8.0,
              ), // Padding to match screenshot
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.2,
                  ), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8B42F8),
                      Color(0xFFE94B8A),
                    ], // Your gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Adjust titlePadding to move text higher
              titlePadding: const EdgeInsets.only(
                left: 100.0,
                top: kToolbarHeight + 20,
              ), // Adjusted top padding
              centerTitle: false,
              title: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align to start (top)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Privacy',
                    style: TextStyle(
                      fontSize: 22.0, // Slightly larger font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Your rights and our policies',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ), // Slightly larger font
                  ),
                ],
              ),
            ),
            // Tabs Section (Terms / Privacy) placed at the bottom of the AppBar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(
                80.0,
              ), // Height of the tabs container
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0, // Push tabs up onto the header
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(
                        label: 'Terms',
                        icon: Icons.description_outlined,
                        index: 0,
                      ),
                      _buildTabButton(
                        label: 'Privacy',
                        icon: Icons.security_outlined,
                        index: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area (Dynamically changes based on selected tab)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _selectedIndex == 0
                    ? _buildTermsContent()
                    : _buildPrivacyContent(),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
