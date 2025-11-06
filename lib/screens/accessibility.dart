import 'package:flutter/material.dart';

// Placeholder for the page to navigate to.
// Ensure you have 'profile_page.dart' in your project.
import 'profile_page.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  // State variables for the switch tiles and dropdowns
  bool _voiceModeEnabled = false;
  bool _highContrastEnabled = false;
  bool _screenReaderEnabled = false;
  bool _reduceMotionEnabled = false;

  String _selectedLanguage = 'English';
  String _selectedTextSize = 'Medium (Default)';

  // Lists for dropdown options
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Korean',
  ];

  final List<String> _textSizes = [
    'Small',
    'Medium (Default)',
    'Large',
    'Extra Large',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is a very light subtle color
      backgroundColor: const Color(0xFFF5F5F9),

      body: CustomScrollView(
        slivers: <Widget>[
          // Custom AppBar with back button and title
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Navigate to 'profile_page.dart' when the back button is clicked
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            title: const Text(
              'Accessibility',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
          ),

          // Main scrollable content using SliverList
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // Language Card (Dropdown)
              _buildCard(
                children: [
                  _buildDropdownTile<String>(
                    icon: Icons.language,
                    iconColor: Colors.deepPurple,
                    title: 'Language',
                    subtitle: 'Choose your preferred language',
                    value: _selectedLanguage,
                    items: _languages,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Voice Mode Card (Switch)
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.volume_up_outlined,
                    iconColor: Colors.blue.shade600,
                    title: 'Voice Mode',
                    subtitle: 'Enable voice commands and feedback',
                    value: _voiceModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _voiceModeEnabled = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Text Size Card (Dropdown)
              _buildCard(
                children: [
                  _buildDropdownTile<String>(
                    icon: Icons.text_fields,
                    iconColor: Colors.green.shade600,
                    title: 'Text Size',
                    subtitle: 'Adjust text size for better readability',
                    value: _selectedTextSize,
                    items: _textSizes,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTextSize = newValue!;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // High Contrast Mode Card (Switch)
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.remove_red_eye_outlined,
                    iconColor: Colors.amber.shade600,
                    title: 'High Contrast Mode',
                    subtitle: 'Increase contrast for better visibility',
                    value: _highContrastEnabled,
                    onChanged: (value) {
                      setState(() {
                        _highContrastEnabled = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Screen Reader Support Card (Switch)
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.volume_up,
                    iconColor: Colors.pink.shade50,
                    title: 'Screen Reader Support',
                    subtitle: 'Optimize for screen readers',
                    value: _screenReaderEnabled,
                    onChanged: (value) {
                      setState(() {
                        _screenReaderEnabled = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Reduce Motion Card (Switch)
              _buildCard(
                children: [
                  _buildSwitchTile(
                    icon: Icons.visibility_off_outlined,
                    iconColor: Colors.red.shade400,
                    title: 'Reduce Motion',
                    subtitle: 'Minimize animations and transitions',
                    value: _reduceMotionEnabled,
                    onChanged: (value) {
                      setState(() {
                        _reduceMotionEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // --- Reusable Widget Builders ---

  // Card wrapper widget for the distinct visual separation
  Widget _buildCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(children: children),
      ),
    );
  }

  // Widget for options with a Switch (e.g., Voice Mode)
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          // Custom leading icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // The Switch component
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
            inactiveThumbColor: Colors.grey.shade300,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  // Widget for options with a Dropdown (e.g., Language, Text Size)
  Widget _buildDropdownTile<T>({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Custom leading icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Dropdown Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                items: items.map<DropdownMenuItem<T>>((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
