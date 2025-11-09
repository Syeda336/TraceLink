import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/global_settings.dart';
import 'profile_page.dart';

// --- Theme Colors ---
const Color _primaryColor = Color(0xFF00B0FF); // Bright Blue
const Color _secondaryColor = Color(0xFFB3E5FC); // Light Blue

// --- Static Icon Colors ---
const Color _deepPurpleColor = Color(0xFF673AB7);
const Color _blueIconColor = Color(0xFF1E88E5);
const Color _greenIconColor = Color(0xFF43A047);
const Color _amberIconColor = Color(0xFFFFB300);
const Color _pinkIconColor = Color(0xFFFF80AB);
const Color _redIconColor = Color(0xFFEF5350);
const Color _greyTextColor = Color(0xFF757575);

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  // Local state variables for switch tiles and dropdowns
  bool _voiceModeEnabled = false;
  bool _screenReaderEnabled = false;
  bool _reduceMotionEnabled = false;

  // These variables will be initialized from the Provider in initState/build
  String _selectedLanguage = '';
  String _selectedTextSize = '';
  bool _highContrastEnabled = false;

  // Lists for dropdown options are retrieved from GlobalSettings
  final List<String> _languages = GlobalSettings().languageLocales.keys
      .toList();
  final List<String> _textSizes = GlobalSettings().textSizeFactors.keys
      .toList();

  @override
  Widget build(BuildContext context) {
    // 1. Read the settings from the provider (This widget rebuilds when settings change)
    final settings = Provider.of<GlobalSettings>(context);

    // 2. Initialize or update local state from the global state
    _selectedLanguage = settings.selectedLanguage;
    _selectedTextSize = settings.selectedTextSize;
    _highContrastEnabled = settings.highContrastEnabled;

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
                      // 3. WRITE the new value back to the provider (listen: false)
                      Provider.of<GlobalSettings>(
                        context,
                        listen: false,
                      ).selectedLanguage = newValue!;
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
                    iconColor: _blueIconColor,
                    title: 'Voice Mode',
                    subtitle:
                        'Enable voice commands and feedback (Activates voice typing)',
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
                    iconColor: _greenIconColor,
                    title: 'Text Size',
                    subtitle: 'Adjust text size for better readability',
                    value: _selectedTextSize,
                    items: _textSizes,
                    onChanged: (newValue) {
                      // 3. WRITE the new value back to the provider (listen: false)
                      Provider.of<GlobalSettings>(
                        context,
                        listen: false,
                      ).selectedTextSize = newValue!;
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
                    iconColor: _amberIconColor,
                    title: 'High Contrast Mode',
                    subtitle: 'Increase contrast for better visibility',
                    value: _highContrastEnabled,
                    onChanged: (value) {
                      // 3. WRITE the new value back to the provider (listen: false)
                      Provider.of<GlobalSettings>(
                        context,
                        listen: false,
                      ).highContrastEnabled = value;
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
                    iconColor: _pinkIconColor,
                    title: 'Screen Reader Support',
                    subtitle: 'Optimize for screen readers (Accessibility API)',
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
                    iconColor: _redIconColor,
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
                  style: const TextStyle(color: _greyTextColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _primaryColor,
            activeTrackColor: _secondaryColor,
            inactiveThumbColor: Colors.grey.shade300,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
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
