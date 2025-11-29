import 'package:flutter/material.dart';

// Import all required destination screens (using dummy screens for demonstration)
// NOTE: You must replace these placeholder imports with your actual file imports
// once you integrate this file into your project structure.
// For now, we define simple placeholder widgets below.
import 'search_lost.dart';
import 'community_feed.dart';
import 'messages.dart';
import 'profile_page.dart';
import 'home.dart';
//NEW
import '../notifications_service.dart'; 

/// A wrapper StatefulWidget to manage the visible screen based on the navigation bar state.
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  // 0: Home (this screen), 1: Browse/Search, 2: Feed, 3: Chat, 4: Profile
  int _selectedIndex = 0;

  // -----------------------------------------------------------
  // PASTE THIS PART HERE (Step 3) NEW
  // -----------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // This starts the listener when the user logs in and sees the menu
    NotificationsService.initializeNotificationListener();
  }

  // IMPORTANT: Remove _navigateToScreen for bottom bar items.
  // We use IndexedStack for non-Home tabs.
  // The push navigation logic is only needed for internal page transitions
  // (e.g., opening a post detail from the Home tab).

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  // Helper function to get the icon color
  Color _getIconColor(int index, BuildContext context) {
    // Use the theme's unselected color for non-active icons
    return _selectedIndex == index
        ? _navItemColors[index]
        : Theme.of(context).unselectedWidgetColor;
  }

  // Define the list of screen content widgets.
  // All screens MUST be listed here to be managed by IndexedStack.
  final List<Widget> _screenContent = const [
    HomeScreen(),
    SearchLost(), // Now the actual widget is here
    CommunityFeed(), // Now the actual widget is here
    MessagesListScreen(), // Now the actual widget is here
    ProfileScreen(), // Now the actual widget is here
  ];

  // The logic is simplified: tapping any item just changes the index.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // No more Navigator.push() is needed for tab switching.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screenContent),

      // The Bottom Navigation Bar definition remains the same
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _getIconColor(0, context)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1, context)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2_outlined,
              color: _getIconColor(2, context),
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: _getIconColor(3, context),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4, context)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        // Use the theme's card color (White in Light, Dark Grey in Dark)
        backgroundColor: Theme.of(context).cardColor,
        elevation: 10,
      ),
    );
  }
}
