import 'package:flutter/material.dart';
import 'home.dart';
import 'profile_page.dart';
import 'search_lost.dart';
import 'messages.dart';
import 'item_description.dart';

// --- Define the NEW Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// 1. Convert StatelessWidget to StatefulWidget
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  // Move state variables here
  int _selectedIndex = 2; // Set to 2 (Feed) since this is the Feed screen

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  // 2. Correctly define _onItemTapped using setState
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    // Using pushReplacement for simplicity in this example to replace the current screen
    // Note: In a real app with a main navigation, you would use a controller (like PageView) or Navigator.popUntil for tab switches.
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
        return;
      case 3: // Chat
        screenToNavigate = const MessagesListScreen();
        break;
      case 4: // Profile
        screenToNavigate = const ProfileScreen();
        break;
      default:
        return;
    }

    // Use widget.context if not explicitly passed, though context from build is safer
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
      body: CustomScrollView(
        slivers: [
          // --- Fixed Header (Community Feed) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  // Back Arrow Button (Top Left Corner Button)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Community Feed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Feed Content ---
          SliverList(
            delegate: SliverChildListDelegate([
              _FeedPostCard(
                userInitials: 'SJ',
                userName: 'Sarah Johnson',
                timeAgo: '2h ago',
                status: 'Found',
                isVerified: true,
                postText:
                    'Found these keys near the cafeteria entrance. They have a blue keychain.',
                location: 'Cafeteria Entrance',
                likes: 12,
                comments: 3,
                imageWidget: Image.asset(
                  'lib/images/key.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 8,
                color: lightBlueBackground,
              ),
              _FeedPostCard(
                userInitials: 'MC',
                userName: 'Mike Chen',
                timeAgo: '5h ago',
                status: 'Lost',
                isVerified: true,
                postText:
                    'Lost my blue Jansport backpack in the Science Building. Contains textbooks and a laptop.',
                location: 'Science Building',
                likes: 8,
                comments: 5,
                imageWidget: Image.asset(
                  'lib/images/blue_backpack.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 8,
                color: lightBlueBackground,
              ),
              _FeedPostCard(
                userInitials: 'EW',
                userName: 'Emma Wilson',
                timeAgo: '1d ago',
                status: 'Found',
                isVerified: false,
                postText:
                    'Found a student ID card at the main gate. Please DM me to claim.',
                location: 'Main Gate',
                likes: 24,
                comments: 7,
                imageWidget: Image.asset(
                  'lib/images/card.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 8,
                color: lightBlueBackground,
              ),
              _FeedPostCard(
                userInitials: 'EW',
                userName: 'Emma Wilson',
                timeAgo: '1d ago',
                status: 'Found',
                isVerified: false,
                postText:
                    'Found a black wallet near the main entrance. It contains several cards. Please contact me to describe and claim.',
                location: 'Main Entrance',
                likes: 42,
                comments: 11,
                imageWidget: Image.asset(
                  'lib/images/black_wallet.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
      // 3. Move BottomNavigationBar to its correct location in the Scaffold
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

// --- Feed Post Card Widget (No changes needed here) ---
class _FeedPostCard extends StatelessWidget {
  final String userInitials;
  final String userName;
  final String timeAgo;
  final String status;
  final bool isVerified;
  final String postText;
  final String location;
  final int likes;
  final int comments;
  final Widget imageWidget;

  const _FeedPostCard({
    required this.userInitials,
    required this.userName,
    required this.timeAgo,
    required this.status,
    required this.isVerified,
    required this.postText,
    required this.location,
    required this.likes,
    required this.comments,
    required this.imageWidget,
  });

  String _itemNameFromPostText(String text) {
    if (text.startsWith('Found these keys')) return 'Set of Keys';
    if (text.startsWith('Lost my blue')) return 'Blue Backpack';
    if (text.startsWith('Found a student ID')) return 'Student ID';
    if (text.startsWith('Found a black wallet')) return 'Black Wallet';
    return 'Item';
  }

  void _openItemDescription(BuildContext context) {
    final itemName = _itemNameFromPostText(postText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(itemName: itemName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLost = status == 'Lost';
    final Color statusColor = isLost ? darkBlue : primaryBlue;
    final Color initialsColor = primaryBlue;
    final String itemName = _itemNameFromPostText(postText);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info and Status Tag
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: initialsColor,
                  child: Text(
                    userInitials,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          if (isVerified)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.check_circle,
                                color: primaryBlue,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(color: darkBlue.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Post Image/Content
          GestureDetector(
            onTap: () => _openItemDescription(context),
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: ClipRRect(child: imageWidget),
            ),
          ),

          // Post Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${status}: $itemName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  postText,
                  style: const TextStyle(fontSize: 14, color: darkBlue),
                ),
              ],
            ),
          ),

          // Footer: Location and Actions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: darkBlue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(color: darkBlue.withOpacity(0.8)),
                    ),
                  ],
                ),
                const Divider(color: lightBlueBackground),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Likes
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: darkBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$likes',
                          style: const TextStyle(fontSize: 16, color: darkBlue),
                        ),
                      ],
                    ),
                    // Comments
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: darkBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$comments',
                          style: const TextStyle(fontSize: 16, color: darkBlue),
                        ),
                      ],
                    ),
                    // Share
                    const Icon(Icons.share_outlined, color: darkBlue, size: 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The PlaceholderImage class remains the same
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({required this.color, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.3),
      child: Center(child: Icon(icon, size: 60, color: color)),
    );
  }
}
