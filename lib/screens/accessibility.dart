import 'package:flutter/material.dart';
import 'profile_page.dart';

// --- Theme Colors ---
const Color _primaryColor = Color(0xFF00B0FF); // Bright Blue

// --- Static Icon Colors ---
const Color _deepPurpleColor = Color(0xFF673AB7);
const Color _greenIconColor = Color(0xFF43A047);
const Color _greyTextColor = Color(0xFF757575);

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  // Initial values for settings that were previously in GlobalSettings
  String _selectedLanguage = 'English'; // Default
  String _selectedTextSize = 'Medium'; // Default

  // Mock data for dropdown options (since we can no longer get them from GlobalSettings)
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];
  final List<String> _textSizes = ['Small', 'Medium', 'Large', 'Extra Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),

      body: CustomScrollView(
        slivers: <Widget>[
          // Custom AppBar
          SliverAppBar(
            backgroundColor: _primaryColor,
            toolbarHeight: 100,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            title: const Text(
              'Accessibility',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Main scrollable content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // Language Card (Dropdown)
              _buildCard(
                children: [
                  _buildDropdownTile<String>(
                    icon: Icons.language,
                    iconColor: _deepPurpleColor,
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

              // Text Size Card (Dropdown)
              _buildCard(
                children: [
                  _buildDropdownTile<String>(
                    icon: Icons.text_fields,
                    iconColor: _greenIconColor,
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
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // --- Reusable Widget Builders (Unchanged) ---

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
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _greyTextColor,
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
              border: Border.all(color: _primaryColor.withOpacity(0.5)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: _primaryColor,
                ),
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
