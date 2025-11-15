import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/theme_provider.dart';

// Import the hypothetical screens
import 'home.dart';
import 'chat.dart';
import 'profile_page.dart';
import 'search_lost.dart';
import 'community_feed.dart';

// --- Define the Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// --- Define Dark Theme Colors (New) ---
const Color darkBackgroundColor = Color(0xFF121212); // Deep Dark
const Color darkSurfaceColor = Color(0xFF1E1E1E); // Darker surface
const Color darkPrimaryColor = Color(0xFF90CAF9); // Light Blue for accents
const Color darkTextColor = Colors.white;
const Color darkHintColor = Color(0xFFB0B0B0); // Light Grey for hints

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
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  // 2. CORRECTLY DEFINED NAVIGATION LOGIC
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

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
      case 3: // Chat (Current Screen) - Should be handled by the check above
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
    // 3. CONSUME THE THEME PROVIDER
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the current theme mode
    final appbarColor = isDarkMode ? darkSurfaceColor : primaryBlue;
    final iconTextColor = isDarkMode ? darkTextColor : Colors.white;
    final backgroundColor = isDarkMode ? darkBackgroundColor : Colors.white;
    final searchBoxColor = isDarkMode ? darkSurfaceColor : lightBlueBackground;
    final searchIconColor = isDarkMode ? darkPrimaryColor : darkBlue;
    final inputTextColor = isDarkMode ? darkTextColor : darkBlue;
    final unselectedIconColor = isDarkMode ? darkHintColor : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor, // THEME CHANGE
      appBar: AppBar(
        backgroundColor: appbarColor, // THEME CHANGE
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: iconTextColor, // THEME CHANGE
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: iconTextColor, // THEME CHANGE
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          // Added a theme switch button for demonstration
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
              color: iconTextColor,
            ),
            onPressed: () {
              themeProvider.toggleTheme(isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: searchBoxColor, // THEME CHANGE
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: darkHintColor), // THEME CHANGE
                  prefixIcon: Icon(
                    Icons.search,
                    color: searchIconColor,
                  ), // THEME CHANGE
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(
                  color: inputTextColor, // THEME CHANGE
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // Pass theme-aware colors to list items
                _ConversationListItem(
                  userInitials: 'SJ',
                  userName: 'Sarah Johnson',
                  lastMessage: 'Yes, I still have the keys with me',
                  timeAgo: '2m ago',
                  unreadCount: 2,
                  isOnline: true,
                  receiverId: 'sj_user_id_123'
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
                ), // THEME CHANGE
                _ConversationListItem(
                  userInitials: 'MC',
                  userName: 'Mike Chen',
                  lastMessage: 'Can we meet at the library?',
                  timeAgo: '1h ago',
                  unreadCount: 0,
                  isOnline: false,
                  receiverId: 'mc_user_id_456'
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
                ), // THEME CHANGE
                _ConversationListItem(
                  userInitials: 'EW',
                  userName: 'Emma Wilson',
                  lastMessage: 'Thank you so much for finding ...',
                  timeAgo: '3h ago',
                  unreadCount: 1,
                  isOnline: true,
                  receiverId: 'ew_user_id_456'
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
                ), // THEME CHANGE
                _ConversationListItem(
                  userInitials: 'AB',
                  userName: 'Alex Brown',
                  lastMessage: 'Is this the blue backpack?',
                  timeAgo: '1d ago',
                  unreadCount: 0,
                  isOnline: false,
                  receiverId: 'ab_user_id_456'
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
                ), // THEME CHANGE
                _ConversationListItem(
                  userInitials: 'JR',
                  userName: 'John Ryan',
                  lastMessage: 'Sounds good, thanks!',
                  timeAgo: '2d ago',
                  unreadCount: 0,
                  isOnline: false,
                  receiverId: 'jr_user_id_456'
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
                ), // THEME CHANGE
                _ConversationListItem(
                  userInitials: 'KP',
                  userName: 'Kate Perry',
                  lastMessage: 'I found your glasses!',
                  timeAgo: '3d ago',
                  unreadCount: 3,
                  isOnline: true,
                  receiverId: 'kp_user_id_456'
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
        unselectedItemColor: unselectedIconColor, // THEME CHANGE
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDarkMode
            ? darkSurfaceColor
            : Colors.white, // THEME CHANGE
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
  final String? receiverId; // Add this line

  const _ConversationListItem({
    required this.userInitials,
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
    this.receiverId,
    // Removed avatarColor and initialsColor from constructor since they are theme-derived now
  });

  @override
  Widget build(BuildContext context) {
    // 4. CONSUME THE THEME PROVIDER IN LIST ITEM
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the current theme mode
    final avatarBg = isDarkMode ? darkSurfaceColor : lightBlueBackground;
    final initialsColor = isDarkMode ? darkPrimaryColor : darkBlue;
    final userNameColor = isDarkMode ? darkTextColor : darkBlue;
    final messageColor = isDarkMode ? darkHintColor : darkBlue.withOpacity(0.7);
    final timeColor = isDarkMode
        ? darkHintColor.withOpacity(0.6)
        : darkBlue.withOpacity(0.6);
    final unreadColor = isDarkMode ? darkPrimaryColor : primaryBlue;

    return InkWell(
      onTap: () {
        // When clicking on a message, navigate to the ChatScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: userName,
              chatPartnerInitials: userInitials,
              isOnline: isOnline,
              // Pass theme-aware colors to the ChatScreen for consistency
              avatarColor: avatarBg,
              receiverId: receiverId, // Pass the receiver ID
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
                  backgroundColor: avatarBg, // THEME CHANGE
                  child: Text(
                    userInitials,
                    style: TextStyle(
                      color: initialsColor, // THEME CHANGE
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
                        border: Border.all(
                          color: isDarkMode
                              ? darkBackgroundColor
                              : Colors.white,
                          width: 2,
                        ), // THEME CHANGE
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: userNameColor, // THEME CHANGE
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      color: messageColor, // THEME CHANGE
                      fontSize: 14,
                    ),
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
                    color: timeColor, // THEME CHANGE
                    fontSize: 12,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: unreadColor, // THEME CHANGE
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