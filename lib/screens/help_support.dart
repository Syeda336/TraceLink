import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:url_launcher/url_launcher.dart'; // REQUIRED for canLaunchUrl and launchUrl

import 'settings.dart'; // Import your settings.dart file

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // --- Utility Functions ---

  // Function to show and hide a temporary pop-up message
  void _showStatusMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // Hide any previous snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
      ),
    );
  }

  // Function to launch email client
  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Support Request'},
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
      _showStatusMessage('Opening email client...');
    } else {
      _showStatusMessage('Could not open email client.');
    }
  }

  // Function to launch phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
      _showStatusMessage('Opening phone dialer...');
    } else {
      _showStatusMessage('Could not open phone dialer.');
    }
  }

  // Placeholder for "Live Chat" action
  void _startLiveChat() {
    _showStatusMessage('Starting live chat...');
    // In a real app, you would navigate to a chat screen or open a webview.
  }

  // Placeholder for "View FAQs" action
  void _viewFAQs() {
    _showStatusMessage('Navigating to FAQs...');
    // In a real app, you would navigate to an FAQ screen or open a webview.
  }

  // Placeholder for "User Guide" action
  void _viewUserGuide() {
    _showStatusMessage('Opening user guide...');
    // Navigate to a user guide screen or open a PDF/webpage.
  }

  // Placeholder for "Video Tutorials" action
  void _viewVideoTutorials() {
    _showStatusMessage('Opening video tutorials...');
    // Navigate to a video list screen or YouTube channel.
  }

  // Placeholder for "Documentation" action
  void _viewDocumentation() {
    _showStatusMessage('Opening technical documentation...');
    // Navigate to a documentation screen or open a webpage.
  }

  // Placeholder for "Share Feedback" action
  void _shareFeedback() {
    _showStatusMessage('Opening feedback form...');
    // Navigate to a feedback form or compose an email.
  }

  // --- Helper Widgets ---

  // Builds a full section card with a title and list of children
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    Color? cardColor,
    Color? titleColor,
    bool isGradient = false, // For common questions card
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: isGradient ? Colors.transparent : (cardColor ?? Colors.white),
      child: Container(
        decoration: isGradient
            ? BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B42F8),
                    Color(0xFFE94B8A),
                  ], // Your gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.0),
              )
            : null,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  // Builds a contact support tile (Email/Phone)
  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String info,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
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
                  Text(value, style: TextStyle(color: Colors.grey[800])),
                  Text(
                    info,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  // Builds a general resource tile
  Widget _buildResourceTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // Builds a Common Question expansion panel
  Widget _buildCommonQuestion({
    required String question,
    required String answer,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // Lighter color within gradient
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    // Set status bar color for consistent look with your design
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors
            .transparent, // Making it transparent to use appbar's gradient
        statusBarIconBrightness:
            Brightness.light, // For dark icons on light status bar content
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50], // Consistent light background
      body: CustomScrollView(
        slivers: [
          // Gradient Header Bar
          SliverAppBar(
            expandedHeight: 140.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Navigate back to SettingsPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
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
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              centerTitle: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "We're here to help you!",
                    style: TextStyle(fontSize: 12.0, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Quick Help Section ---
                _buildSectionCard(
                  title: 'Quick Help',
                  icon: Icons.help_outline,
                  iconColor: const Color(0xFFE94B8A), // Pink icon
                  children: [
                    Text(
                      'Need immediate assistance? Check out our quick help resources below.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 15),

                    // **FIXED: Replaced faulty ElevatedButton.icon with GestureDetector + Container for gradient**
                    GestureDetector(
                      onTap: _viewFAQs,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B42F8),
                              Color(0xFFE94B8A),
                            ], // Your gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B42F8).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'View FAQs',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // --- Contact Us Section ---
                _buildSectionCard(
                  title: 'Contact Us',
                  icon: Icons.chat_bubble_outline,
                  iconColor: Colors.blueAccent, // Blue icon
                  children: [
                    // Live Chat
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.chat_outlined,
                          color: Colors.blueAccent,
                        ),
                      ),
                      title: const Text(
                        'Live Chat',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'Chat with our support team',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: const Text(
                              'Online now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            backgroundColor: Colors.green,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.open_in_new,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      onTap: _startLiveChat,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    // Email Support
                    _buildContactTile(
                      icon: Icons.email_outlined,
                      iconColor: const Color(0xFF8B42F8), // Purple icon
                      title: 'Email Support',
                      value: 'support@lostandfound.edu',
                      info: 'Response within 24 hours',
                      onTap: () => _launchEmail('support@lostandfound.edu'),
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    // Phone Support
                    _buildContactTile(
                      icon: Icons.phone_outlined,
                      iconColor: Colors.green, // Green icon
                      title: 'Phone Support',
                      value: '+1 (555) 123-4567',
                      info: 'Mon-Fri, 9AM-5PM EST',
                      onTap: () => _launchPhone('+15551234567'),
                    ),
                  ],
                ),

                // --- Help Resources Section ---
                _buildSectionCard(
                  title: 'Help Resources',
                  icon: Icons.menu_book_outlined,
                  iconColor: Colors.green, // Green icon
                  cardColor: Colors.green.withOpacity(
                    0.05,
                  ), // Light green background
                  titleColor: Colors.green,
                  children: [
                    // User Guide
                    _buildResourceTile(
                      icon: Icons.bookmark_outline,
                      iconColor: Colors.blueAccent,
                      title: 'User Guide',
                      subtitle: 'Complete guide to using the app',
                      onTap: _viewUserGuide,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    // Video Tutorials
                    _buildResourceTile(
                      icon: Icons.play_circle_outline,
                      iconColor: const Color(0xFF8B42F8), // Purple icon
                      title: 'Video Tutorials',
                      subtitle: 'Step-by-step video guides',
                      onTap: _viewVideoTutorials,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    // Documentation
                    _buildResourceTile(
                      icon: Icons.assignment_outlined,
                      iconColor: const Color(0xFFE94B8A), // Pink icon
                      title: 'Documentation',
                      subtitle: 'Technical documentation',
                      onTap: _viewDocumentation,
                    ),
                  ],
                ),

                // --- Common Questions Section ---
                _buildSectionCard(
                  title: 'Common Questions',
                  icon: Icons.question_mark_outlined,
                  iconColor: Colors.white,
                  titleColor: Colors.white,
                  isGradient: true, // Use gradient background for this card
                  children: [
                    _buildCommonQuestion(
                      question: 'How do I report a lost item?',
                      answer:
                          "Tap the '+' button on the home screen and select 'Report Lost Item'.",
                      textColor: Colors.white,
                    ),
                    _buildCommonQuestion(
                      question: 'How do I claim an item?',
                      answer:
                          "Find the item in the list, tap 'Claim Item', and provide verification details.",
                      textColor: Colors.white,
                    ),
                    _buildCommonQuestion(
                      question: 'How do I contact the finder?',
                      answer:
                          "Use the 'Message' button on the item details screen to start a conversation.",
                      textColor: Colors.white,
                    ),
                  ],
                ),

                // --- Send Feedback Section ---
                _buildSectionCard(
                  title: 'Send Feedback',
                  icon: Icons.feedback_outlined,
                  iconColor: Colors.orange, // Orange icon
                  children: [
                    Text(
                      'Help us improve! Share your thoughts and suggestions.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _shareFeedback,
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          'Share Feedback',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          backgroundColor: Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),

                // --- Version Info Section ---
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: const Color(0xFFF0F5FF), // Light blue background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Lost & Found App',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '© 2025 University. All rights reserved.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Extra space at the bottom
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
