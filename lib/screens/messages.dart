import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen
import 'chat.dart'; // Import the ChatScreen
import 'profile_page.dart';
import 'search_lost.dart';
import 'community_feed.dart';

// --- Define the Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// 1. CONVERTED TO STATEFULWIDGET
class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  // Moved state variables here
  int _selectedIndex = 3; // Chat index

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3) - kept to distinguish tab
    Colors.purple, // Profile (Index 4)
  ];

  // 2. CORRECTLY DEFINED NAVIGATION LOGIC
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget screenToNavigate;

    switch (index) {
      case 0: // Home
        screenToNavigate = const HomeScreen();
        break;
      case 1: // Browse
        screenToNavigate = const SearchLost();
        break;
      case 2: // Feed
        screenToNavigate = const CommunityFeed();
        break;
      case 3: // Chat (Current Screen) - Prevent navigation to self
        return;
      case 4: // Profile
        screenToNavigate = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screenToNavigate),
    );
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // THEME CHANGE: AppBar background set to Primary Blue
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // THEME CHANGE: Icon set to White
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white, // THEME CHANGE: Text set to White
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                // THEME CHANGE: Search box background set to Light Blue
                color: lightBlueBackground,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Colors.grey),
                  // THEME CHANGE: Search icon set to Dark Blue
                  prefixIcon: Icon(Icons.search, color: darkBlue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(
                  color: darkBlue,
                ), // THEME CHANGE: Input text color
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // Conversation list items using Dark Blue for body text
                _ConversationListItem(
                  userInitials: 'SJ',
                  userName: 'Sarah Johnson',
                  lastMessage: 'Yes, I still have the keys with me',
                  timeAgo: '2m ago',
                  unreadCount: 2,
                  isOnline: true,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
                const Divider(height: 1, color: lightBlueBackground),
                _ConversationListItem(
                  userInitials: 'MC',
                  userName: 'Mike Chen',
                  lastMessage: 'Can we meet at the library?',
                  timeAgo: '1h ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
                const Divider(height: 1, color: lightBlueBackground),
                _ConversationListItem(
                  userInitials: 'EW',
                  userName: 'Emma Wilson',
                  lastMessage: 'Thank you so much for finding ...',
                  timeAgo: '3h ago',
                  unreadCount: 1,
                  isOnline: true,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
                const Divider(height: 1, color: lightBlueBackground),
                _ConversationListItem(
                  userInitials: 'AB',
                  userName: 'Alex Brown',
                  lastMessage: 'Is this the blue backpack?',
                  timeAgo: '1d ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
                const Divider(height: 1, color: lightBlueBackground),
                _ConversationListItem(
                  userInitials: 'JR',
                  userName: 'John Ryan',
                  lastMessage: 'Sounds good, thanks!',
                  timeAgo: '2d ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
                const Divider(height: 1, color: lightBlueBackground),
                _ConversationListItem(
                  userInitials: 'KP',
                  userName: 'Kate Perry',
                  lastMessage: 'I found your glasses!',
                  timeAgo: '3d ago',
                  unreadCount: 3,
                  isOnline: true,
                  avatarColor: primaryBlue.withOpacity(0.2),
                  initialsColor: darkBlue,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, color: _getIconColor(2)),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, color: _getIconColor(3)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}

class _ConversationListItem extends StatelessWidget {
  final String userInitials;
  final String userName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;
  final Color avatarColor;
  final Color initialsColor;

  const _ConversationListItem({
    required this.userInitials,
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
    // Removed unused avatarColor and initialsColor since we're using theme colors
    required this.avatarColor, // Now uses theme-based opacity
    required this.initialsColor, // Now uses theme-based dark blue
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // When clicking on a message, navigate to the ChatScreen
        // Note: You must define ChatScreen in chat.dart for this to work fully.
        // Using temporary default colors for the ChatScreen arguments
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: userName,
              chatPartnerInitials: userInitials,
              isOnline: isOnline,
              avatarColor: avatarColor,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  // THEME CHANGE: Avatar background is light blue
                  backgroundColor: lightBlueBackground,
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                      // THEME CHANGE: Initials color is Dark Blue
                      color: darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green, // Standard online indicator color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkBlue, // THEME CHANGE: Dark Blue for user name
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      color: darkBlue.withOpacity(0.7),
                      fontSize: 14,
                    ), // THEME CHANGE: Dark Blue opacity for message
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: darkBlue.withOpacity(0.6),
                    fontSize: 12,
                  ), // THEME CHANGE: Dark Blue opacity for time
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          primaryBlue, // THEME CHANGE: Bright Blue count bubble
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
