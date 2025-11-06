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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    switch (index) {
      case 0:
        // Already on the Home screen. Can add functionality to scroll to top.
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

  // --- Widget Builders ---

  // 1. Builds the main gradient header area
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFF8e44ad), // Deeper Purple/Pink Top
            Color(0xFF4a148c), // Very Deep Violet/Indigo Middle
          ],
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
              // Notifications Button Functionality Added
              GestureDetector(
                onTap: () => _navigateToScreen(context, NotificationsScreen()),
                child: Container(
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
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Let's find what you're looking for",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 25),
          // Search Bar Functionality Added (Taps open SearchScreen)
          GestureDetector(
            onTap: () => _navigateToScreen(context, SearchScreen()),
            child: TextField(
              enabled: false, // Disable typing in the home screen search bar
              decoration: InputDecoration(
                hintText: 'Search for items...',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4a148c)),
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
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        color: backgroundColor,
        child: InkWell(
          onTap: () =>
              _navigateToScreen(context, destination), // Navigation Added
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
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
    // Add an onTap callback for the whole card
    required VoidCallback onTap,
  }) {
    // Wrap the Card with a GestureDetector or use InkWell/Card's onTap
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        // Using InkWell for a ripple effect on tap
        onTap: onTap, // <--- Use the new onTap callback
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
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
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
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(time, style: TextStyle(color: Colors.grey.shade400)),
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
    const Color backgroundLightColor = Color(0xFFf3f0f7);

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
                  // --- Emergency Alert Card Functionality Added ---
                  GestureDetector(
                    onTap: () => _navigateToScreen(context, EmergencyAlerts()),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD35400), Color(0xFFF39C12)],
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
                            color: Colors.white,
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
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lost student IDs & laptops',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Report Lost / Report Found Row Functionality Added ---
                  Row(
                    children: [
                      _buildActionCard(
                        context: context,
                        icon: Icons.search,
                        iconColor: const Color(0xFFa29bfe),
                        title: 'Report Lost',
                        subtitle: 'Lost something?',
                        backgroundColor: Colors.white,
                        destination: ReportLostItemScreen(),
                      ),
                      const SizedBox(width: 15),
                      _buildActionCard(
                        context: context,
                        icon: Icons.inventory_2_outlined,
                        iconColor: const Color(0xFFffb5d7),
                        title: 'Report Found',
                        subtitle: 'Found something?',
                        backgroundColor: Colors.white,
                        destination: ReportFoundItemScreen(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // --- Report a Problem Card Functionality Added ---
                  GestureDetector(
                    onTap: () => _navigateToScreen(context, ReportProblem()),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE67E22), Color(0xFFF9A825)],
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
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report a Problem',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'User not returning an item?',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Recent Posts Section (Navigation added to individual posts) ---
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
                    statusColor: const Color(0xFF9b59b6),
                    imageUrl: 'lib/images/black_wallet.jfif',
                    // Navigation to ItemDescriptionScreen on tap
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
                    statusColor: const Color(0xFF2ecc71),
                    imageUrl: 'lib/images/key.jfif',
                    // Navigation to ItemDescriptionScreen on tap
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
                    statusColor: const Color(0xFF9b59b6),
                    imageUrl: 'lib/images/blue_backpack.jfif',
                    // Navigation to ItemDescriptionScreen on tap
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

      // 3. The Bottom Navigation Bar (Fixed at the bottom)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery), // Browse/Search
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined), // Feed
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), // Chat
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Profile
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF9b59b6),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped, // All navigation handled here
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
