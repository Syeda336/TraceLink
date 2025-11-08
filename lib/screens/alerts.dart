import 'package:flutter/material.dart';

import 'messages.dart';
import 'profile_page.dart';
import 'community_feed.dart';
import 'search_lost.dart';
import 'home.dart'; // Add original HomeScreen if needed

// Define the new color palette
const Color _brightBlue = Color(0xFF1E88E5); // A vibrant, bright blue
const Color _lightBlueBackground = Color(
  0xFFE3F2FD,
); // A very light blue for the body
const Color _darkBlueText = Color(
  0xFF0D47A1,
); // A dark blue for text on light background

class EmergencyAlerts extends StatefulWidget {
  const EmergencyAlerts({super.key});

  @override
  State<EmergencyAlerts> createState() => _EmergencyAlertsState();
}

class _EmergencyAlertsState extends State<EmergencyAlerts> {
  // --- BOTTOM NAV STATE/LOGIC INCLUDED ---
  // 0: Home (this screen), 1: Browse/Search, 2: Feed, 3: Chat, 4: Profile
  int _selectedIndex =
      0; // Set to 0 initially, or choose an appropriate index for Alerts screen

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

    // Handle navigation for Bottom Navigation Bar items (using placeholder navigation for context)
    switch (index) {
      case 0:
        // Navigating back to the original HomeScreen
        // Note: You should generally use Navigator.popUntil for main tab switches
        _navigateToScreen(context, HomeScreen());
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
  // --- END BOTTOM NAV LOGIC ---

  // Data structure for an alert item
  final List<Map<String, dynamic>> _alerts = [
    // Item 1: Student ID - John Martinez (High Priority)
    {
      'itemName': 'Student ID - John Martinez',
      'description':
          'Lost student ID card with photo. Urgent - needed for university entrance.',
      'location': 'Main Building, Room 305',
      'timeAgo': '15 min ago',
      'views': '45 views',
      'isHighPriority': true,
      'imageIcon': Icons.badge,
    },
    // Item 2: MacBook Pro 16" (High Priority)
    {
      'itemName': 'MacBook Pro 16"',
      'description':
          'Silver MacBook Pro left in library. Contains important project files.',
      'location': 'Library, Study Room 12',
      'timeAgo': '1h ago',
      'views': '89 views',
      'isHighPriority': true,
      'imageIcon': Icons.laptop_mac,
    },
    // Item 3: Prescription Glasses (Priority)
    {
      'itemName': 'Prescription Glasses',
      'description':
          'Black frame glasses in blue case. Cannot see without them - urgent.',
      'location': 'Cafeteria, Table near window',
      'timeAgo': '2h ago',
      'views': '34 views',
      'isHighPriority': false, // Priority
      'imageIcon': Icons.remove_red_eye,
    },
  ];

  // Functionality for "Mark as Seen"
  void _markAsSeen(int index) {
    // Check if the index is valid before removal
    if (index >= 0 && index < _alerts.length) {
      String itemName = _alerts[index]['itemName'];
      setState(() {
        _alerts.removeAt(index);
      });
      // Optionally show a confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemName marked as seen and removed.')),
      );
    }
  }

  // Functionality for "Report Sighting"
  void _reportSighting(String itemName) {
    // Implement navigation or a dialog here for the reporting process
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Sighting'),
          content: Text(
            'Thank you for reporting a sighting of the "$itemName". We will notify the owner.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: _brightBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _lightBlueBackground, // Light blue background for the body
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar: Header (Bright Blue) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Use a single bright blue color for a clean look, or a gradient for depth
                gradient: LinearGradient(
                  colors: [
                    _brightBlue,
                    Color(0xFF42A5F5),
                  ], // Bright Blue with a slight variation
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors
                                  .white, // Text/Icon on bright blue should be white
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Emergency Alerts',
                            style: TextStyle(
                              color: Colors.white, // White text on bright blue
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'High-priority lost items that need urgent attention',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ), // Sub-text in white70
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- SliverList: Alert Cards (Light Blue Section) ---
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final alert = _alerts[index];
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _AlertItemCard(
                  itemName: alert['itemName'],
                  description: alert['description'],
                  location: alert['location'],
                  timeAgo: alert['timeAgo'],
                  views: alert['views'],
                  isHighPriority: alert['isHighPriority'],
                  // Pass the functions to handle button actions
                  onMarkAsSeen: () => _markAsSeen(index),
                  onReportSighting: () => _reportSighting(alert['itemName']),
                  // Using PlaceholderImage with dynamic icon
                  imageWidget: PlaceholderImage(
                    color: _darkBlueText,
                    icon: alert['imageIcon'],
                  ),
                ),
              );
            }, childCount: _alerts.length),
          ),
          // Add padding to the very bottom
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),

      // --- BOTTOM NAVIGATION BAR ADDED ---
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
      // --- END BOTTOM NAVIGATION BAR ADDED ---
    );
  }
}

// --- Alert Item Card Widget ---
class _AlertItemCard extends StatelessWidget {
  final String itemName;
  final String description;
  final String location;
  final String timeAgo;
  final String views;
  final bool isHighPriority;
  final Widget imageWidget;
  final VoidCallback onMarkAsSeen; // New callback for Mark as Seen
  final VoidCallback onReportSighting; // New callback for Report Sighting

  const _AlertItemCard({
    required this.itemName,
    required this.description,
    required this.location,
    required this.timeAgo,
    required this.views,
    required this.isHighPriority,
    required this.imageWidget,
    required this.onMarkAsSeen, // Required in constructor
    required this.onReportSighting, // Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    // Determine the priority tag text and color
    final String priorityText = isHighPriority ? 'High Priority' : 'Priority';
    final Color priorityColor = isHighPriority
        ? const Color(0xFFDC3545) // Keep a distinct red for High Priority
        : Colors.orange; // Keep orange for regular Priority

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(
                  0.2,
                ), // Increased shadow opacity for separation
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Image/Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            _lightBlueBackground, // Use light blue as background for placeholder
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageWidget,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  priorityText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: _darkBlueText, // Dark blue text
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Location and Time/Views Row
                          _InfoRow(icon: Icons.location_on, text: location),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _InfoRow(
                                icon: Icons.watch_later_outlined,
                                text: timeAgo,
                              ),
                              const SizedBox(width: 16),
                              _InfoRow(
                                icon: Icons.remove_red_eye_outlined,
                                text: views,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onMarkAsSeen, // Use the callback
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: _darkBlueText,
                          ), // Dark blue outline
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mark as Seen',
                          style: TextStyle(
                            color: _darkBlueText,
                            fontSize: 16,
                          ), // Dark blue text
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onReportSighting, // Use the callback
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: _brightBlue, // Bright blue fill
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Report Sighting',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ), // White text
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widget for Info Rows
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: _darkBlueText.withOpacity(0.7), // Subtle dark blue icon
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: _darkBlueText.withOpacity(0.8), // Dark blue text
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// --- Placeholder Widget for Images ---
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _lightBlueBackground,
      child: Center(
        child: Icon(
          icon,
          size: 40,
          color: color, // Icon color is dark blue
        ),
      ),
    );
  }
}
