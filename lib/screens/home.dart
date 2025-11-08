import 'package:flutter/material.dart';
// Import all destination screens
import 'notifications.dart';
import 'search_bar.dart';
import 'alerts.dart';
import 'report_problem.dart';
import 'report_lost.dart';
import 'report_found.dart';
import 'messages.dart';
import 'profile_page.dart';
import 'community_feed.dart';
import 'search_lost.dart';

// 1. IMPORT YOUR ITEM DESCRIPTION SCREEN HERE
import 'item_description.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0: Home (this screen), 1: Browse/Search, 2: Feed, 3: Chat, 4: Profile
  int _selectedIndex = 0;

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    switch (index) {
      case 0:
        break;
      case 1: // Browse
        _navigateToScreen(context, SearchLost());
        break;
      case 2: // Feed
        _navigateToScreen(context, CommunityFeed());
        break;
      case 3: // Chat
        _navigateToScreen(context, MessagesListScreen());
        break;
      case 4: // Profile
        _navigateToScreen(context, ProfileScreen());
        break;
    }
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }

  // 1. Builds the main gradient header area (Bright Blue Theme)
  Widget _buildHeader(BuildContext context) {
    const Color brightBlueTop = Color(0xFF1E90FF); // Dodger Blue
    const Color deepBlueBottom = Color(0xFF007FFF); // Azure Blue
    const Color darkSearchTextColor = Color(
      0xFF4a148c,
    ); // Using the original dark purple for contrast

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [brightBlueTop, deepBlueBottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hello, Student! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Notifications Button with Red Dot
              GestureDetector(
                onTap: () => _navigateToScreen(context, NotificationsScreen()),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white,
                      ),
                    ),
                    // ✅ Red Notification Dot
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Let's find what you're looking for",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 25),
          // Search Bar
          GestureDetector(
            onTap: () => _navigateToScreen(context, SearchScreen()),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                // ✅ Search bar hint text color changed to dark blue
                hintText: 'Search for items...',
                hintStyle: const TextStyle(color: darkSearchTextColor),
                prefixIcon: const Icon(Icons.search, color: deepBlueBottom),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Builds the card for "Report Lost" or "Report Found"
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Widget destination,
  }) {
    // Determine text color based on background (always white for blue sections)
    const Color textColor = Colors.white;

    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        color: backgroundColor,
        child: InkWell(
          onTap: () => _navigateToScreen(context, destination),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 30, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ Text color changed to white
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ), // ✅ Subtitle color changed to white
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Builds the Recent Post item card
  Widget _buildRecentPostCard({
    required String title,
    required String location,
    required String time,
    required String status,
    required Color statusColor,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: const Color.fromARGB(255, 206, 232, 247),
                    child: const Icon(
                      Icons.broken_image,
                      color: Color.fromARGB(255, 158, 158, 158),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 26, 94, 182),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 99, 147, 209),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundLightColor = Color.fromARGB(
      255,
      201,
      228,
      252,
    ); // Light Azure Blue
    const Color brightBlueTop = Color(0xFF1E90FF); // Dodger Blue
    const Color deepBlueBottom = Color(0xFF007FFF); // Azure Blue
    const Color whiteTextColor = Colors.white;

    // Existing colors for other elements
    const Color lostStatusColor = Color(0xFF2980b9);
    const Color foundStatusColor = Color(0xFF2ecc71);

    return Scaffold(
      backgroundColor: backgroundLightColor,
      body: Stack(
        children: [
          // 1. The main content area with scrolling enabled
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 250),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Emergency Alert Card (Bright Blue Gradient, White Text) ---
                  GestureDetector(
                    onTap: () => _navigateToScreen(context, EmergencyAlerts()),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [brightBlueTop, deepBlueBottom],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: whiteTextColor,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '3 Emergency Alerts',
                                  style: TextStyle(
                                    color:
                                        whiteTextColor, // ✅ Text color is white
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lost student IDs & laptops',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ), // ✅ Subtitle color is white
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Report Lost / Report Found Row (Solid Blue, White Text) ---
                  Row(
                    children: [
                      _buildActionCard(
                        context: context,
                        icon: Icons.search,
                        iconColor: whiteTextColor, // Icon color is white
                        title: 'Report Lost',
                        subtitle: 'Lost something?',
                        backgroundColor: const Color.fromARGB(
                          255,
                          69,
                          160,
                          252,
                        ),
                        destination: ReportLostItemScreen(),
                      ),
                      const SizedBox(width: 15),
                      _buildActionCard(
                        context: context,
                        icon: Icons.inventory_2_outlined,
                        iconColor: whiteTextColor, // Icon color is white
                        title: 'Report Found',
                        subtitle: 'Found something?',
                        backgroundColor: const Color.fromARGB(255, 0, 183, 255),
                        destination: ReportFoundItemScreen(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // --- Report a Problem Card (Blue Gradient, White Text) ---
                  GestureDetector(
                    onTap: () => _navigateToScreen(context, ReportProblem()),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [deepBlueBottom, brightBlueTop],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: whiteTextColor,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report a Problem',
                                style: TextStyle(
                                  color:
                                      whiteTextColor, // ✅ Text color is white
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'User not returning an item?',
                                style: TextStyle(
                                  color: Colors.white70,
                                ), // ✅ Subtitle color is white
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Recent Posts Section ---
                  const Text(
                    'Recent Posts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildRecentPostCard(
                    title: 'Black Wallet',
                    location: 'Library, 2nd Floor',
                    time: '2h ago',
                    status: 'Lost',
                    statusColor: lostStatusColor,
                    imageUrl: 'lib/images/black_wallet.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      ItemDetailScreen(itemName: 'Black Wallet'),
                    ),
                  ),
                  _buildRecentPostCard(
                    title: 'Set of Keys',
                    location: 'Cafeteria Entrance',
                    time: '4h ago',
                    status: 'Found',
                    statusColor: foundStatusColor,
                    imageUrl: 'lib/images/key.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      ItemDetailScreen(itemName: 'Set of Keys'),
                    ),
                  ),
                  _buildRecentPostCard(
                    title: 'Blue Backpack',
                    location: 'Science Building',
                    time: '5h ago',
                    status: 'Lost',
                    statusColor: lostStatusColor,
                    imageUrl: 'lib/images/blue_backpack.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      ItemDetailScreen(itemName: 'Blue Backpack'),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // 2. The gradient header is stacked on top and remains fixed
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),
        ],
      ),

      // 3. The Bottom Navigation Bar (Multi-Colored)
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
