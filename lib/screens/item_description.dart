<<<<<<< HEAD
import 'package:flutter/material.dart';

// Assuming these are defined in their respective files
import 'home.dart';
import 'messages.dart';
import 'claim_submit.dart';
import 'search_lost.dart';
import 'community_feed.dart';
import 'profile_page.dart';

// Define the new color palette
const Color primaryBlue = Color(
  0xFF42A5F5,
); // Bright Blue (A light-medium blue)
const Color darkBlue = Color(0xFF1976D2); // Dark Blue (A darker, deeper blue)
const Color lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue for section backgrounds

// --- Main Item Detail Screen (Converted to StatefulWidget) ---
class ItemDetailScreen extends StatefulWidget {
  final String itemName;
  const ItemDetailScreen({super.key, required this.itemName});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  // Correctly define state variables within the State class
  int _selectedIndex =
      0; // Set to 0 initially, or choose an appropriate index for Alerts screen

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors
        .green, // Home (Index 0) - Using favorite icon, but navigating to home.dart
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _navigateToScreen(BuildContext context, Widget screen) {
    // Using pushReplacement for main tab navigation to avoid deep stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Define _onItemTapped correctly within the State class
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    // Context is available in State class methods.
    switch (index) {
      case 0:
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Default screen background
      // The body is wrapped in a Stack to place the content and action buttons
      body: Stack(
        children: [
          // Screen Content (Scrollable)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Image 4: Item Header with Image, Title, Location, Date ---
                _buildItemImageHeader(context),
                // This Padding helps to align the content below the image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ), // Spacing after the image header card
                      // --- Image 1: Posted By Section ---
                      _buildPostedBySection(),
                      const SizedBox(height: 20),

                      // --- Image 2: Description Section ---
                      _buildDescriptionSection(),
                      const SizedBox(height: 20),

                      // --- Image 3: Additional Details Section ---
                      _buildAdditionalDetailsSection(),
                      const SizedBox(
                        height: 100,
                      ), // Space for the floating action buttons to overlap
                    ],
                  ),
                ),
              ],
            ),
          ),
          // --- Floating Action Buttons (Message & Claim Item) ---
          _buildBottomActionButtons(context),
        ],
      ),
      // --- Bottom Navigation Bar (Moved here) ---
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _getIconColor(0),
            ), // Changed to home icon
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

  // --- Widget for Image 4: Item Header ---
  Widget _buildItemImageHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Placeholder for the image
            Image.asset(
              'lib/images/black_wallet.jfif', // Placeholder image URL
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay for better readability of icons
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            // Top Left Back Button
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  10, // Adjust for status bar
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ),
            // Top Right Bookmark/Flag Button
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  10, // Adjust for status bar
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.flag_outlined, color: Colors.black),
                  onPressed: () {
                    // Handle flag/bookmark action
                  },
                ),
              ),
            ),
          ],
        ),
        // Details card overlaying the bottom of the image
        Transform.translate(
          offset: const Offset(0, -30), // Pull the card up
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: darkBlue,
                width: 1,
              ), // Dark blue outline
              boxShadow: [
                BoxShadow(
                  color: darkBlue.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Black Leather Wallet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ), // Dark Blue Text
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(
                      0.15,
                    ), // Light background for the tag
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Lost Item',
                    style: TextStyle(
                      color: primaryBlue, // Bright Blue Text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: darkBlue, // Dark Blue Icon
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Library, 2nd Floor near Study Room 12',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: darkBlue, // Dark Blue Icon
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'October 10, 2025',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget for Image 1: Posted By Section ---
  Widget _buildPostedBySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: lightBlueBackground, // Light Blue Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBlue, width: 1), // Dark blue outline
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Posted By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ), // Dark Blue Text
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: primaryBlue, // Bright Blue Avatar background
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white, // White Text on bright blue
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // User Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                    Text(
                      'Student • Verified',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.8), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.green.shade100, // Keep light green for "Verified"
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 2: Description Section ---
  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: lightBlueBackground, // Light Blue Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBlue, width: 1), // Dark blue outline
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ), // Dark Blue Text
          ),
          const SizedBox(height: 15),
          Text(
            'Black leather wallet with multiple card slots. Contains student ID, driver\'s license, and credit cards. Has a small Nike logo on the front. Very sentimental value as it was a gift from my parents.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: darkBlue.withOpacity(0.8), // Dark Blue Text
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 3: Additional Details Section ---
  Widget _buildAdditionalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ), // Dark Blue Text
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlueBackground.withOpacity(
                    0.7,
                  ), // Slightly darker light blue
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.6), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Accessories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlueBackground.withOpacity(
                    0.7,
                  ), // Slightly darker light blue
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.6), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Black',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Widget for Bottom Action Buttons ---
  Widget _buildBottomActionButtons(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: darkBlue.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to chat screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MessagesListScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      color: primaryBlue, // Bright Blue Border
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        color: darkBlue, // Dark Blue Icon
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Message',
                        style: TextStyle(
                          color: darkBlue, // Dark Blue Text
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to claim verification screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyOwnershipScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: primaryBlue, // Bright Blue Button
                    elevation: 0,
                  ),
                  child: const Text(
                    'Claim Item',
                    style: TextStyle(
                      color: Colors.white, // White Text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';

// Assuming these are defined in their respective files
import 'home.dart';
import 'messages.dart';
import 'claim_submit.dart';
import 'search_lost.dart';
import 'community_feed.dart';
import 'profile_page.dart';

// Define the new color palette
const Color primaryBlue = Color(
  0xFF42A5F5,
); // Bright Blue (A light-medium blue)
const Color darkBlue = Color(0xFF1976D2); // Dark Blue (A darker, deeper blue)
const Color lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue for section backgrounds

// --- Main Item Detail Screen (Converted to StatefulWidget) ---
class ItemDetailScreen extends StatefulWidget {
  final String itemName;
  const ItemDetailScreen({super.key, required this.itemName});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  // Correctly define state variables within the State class
  int _selectedIndex =
      0; // Set to 0 initially, or choose an appropriate index for Alerts screen

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors
        .green, // Home (Index 0) - Using favorite icon, but navigating to home.dart
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _navigateToScreen(BuildContext context, Widget screen) {
    // Using pushReplacement for main tab navigation to avoid deep stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Define _onItemTapped correctly within the State class
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    // Context is available in State class methods.
    switch (index) {
      case 0:
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Default screen background
      // The body is wrapped in a Stack to place the content and action buttons
      body: Stack(
        children: [
          // Screen Content (Scrollable)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Image 4: Item Header with Image, Title, Location, Date ---
                _buildItemImageHeader(context),
                // This Padding helps to align the content below the image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ), // Spacing after the image header card
                      // --- Image 1: Posted By Section ---
                      _buildPostedBySection(),
                      const SizedBox(height: 20),

                      // --- Image 2: Description Section ---
                      _buildDescriptionSection(),
                      const SizedBox(height: 20),

                      // --- Image 3: Additional Details Section ---
                      _buildAdditionalDetailsSection(),
                      const SizedBox(
                        height: 100,
                      ), // Space for the floating action buttons to overlap
                    ],
                  ),
                ),
              ],
            ),
          ),
          // --- Floating Action Buttons (Message & Claim Item) ---
          _buildBottomActionButtons(context),
        ],
      ),
      // --- Bottom Navigation Bar (Moved here) ---
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _getIconColor(0),
            ), // Changed to home icon
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

  // --- Widget for Image 4: Item Header ---
  Widget _buildItemImageHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Placeholder for the image
            Image.asset(
              'lib/images/black_wallet.jfif', // Placeholder image URL
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay for better readability of icons
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            // Top Left Back Button
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  10, // Adjust for status bar
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ),
            // Top Right Bookmark/Flag Button
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  10, // Adjust for status bar
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.flag_outlined, color: Colors.black),
                  onPressed: () {
                    // Handle flag/bookmark action
                  },
                ),
              ),
            ),
          ],
        ),
        // Details card overlaying the bottom of the image
        Transform.translate(
          offset: const Offset(0, -30), // Pull the card up
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: darkBlue,
                width: 1,
              ), // Dark blue outline
              boxShadow: [
                BoxShadow(
                  color: darkBlue.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Black Leather Wallet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ), // Dark Blue Text
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(
                      0.15,
                    ), // Light background for the tag
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Lost Item',
                    style: TextStyle(
                      color: primaryBlue, // Bright Blue Text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: darkBlue, // Dark Blue Icon
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Library, 2nd Floor near Study Room 12',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: darkBlue, // Dark Blue Icon
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'October 10, 2025',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget for Image 1: Posted By Section ---
  Widget _buildPostedBySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: lightBlueBackground, // Light Blue Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBlue, width: 1), // Dark blue outline
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Posted By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ), // Dark Blue Text
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: primaryBlue, // Bright Blue Avatar background
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white, // White Text on bright blue
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // User Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                    Text(
                      'Student • Verified',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.8), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.green.shade100, // Keep light green for "Verified"
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 2: Description Section ---
  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: lightBlueBackground, // Light Blue Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBlue, width: 1), // Dark blue outline
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ), // Dark Blue Text
          ),
          const SizedBox(height: 15),
          Text(
            'Black leather wallet with multiple card slots. Contains student ID, driver\'s license, and credit cards. Has a small Nike logo on the front. Very sentimental value as it was a gift from my parents.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: darkBlue.withOpacity(0.8), // Dark Blue Text
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 3: Additional Details Section ---
  Widget _buildAdditionalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ), // Dark Blue Text
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlueBackground.withOpacity(
                    0.7,
                  ), // Slightly darker light blue
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.6), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Accessories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlueBackground.withOpacity(
                    0.7,
                  ), // Slightly darker light blue
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color',
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.6), // Dark Blue Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Black',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkBlue, // Dark Blue Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Widget for Bottom Action Buttons ---
  Widget _buildBottomActionButtons(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: darkBlue.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to chat screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MessagesListScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      color: primaryBlue, // Bright Blue Border
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        color: darkBlue, // Dark Blue Icon
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Message',
                        style: TextStyle(
                          color: darkBlue, // Dark Blue Text
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to claim verification screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyOwnershipScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: primaryBlue, // Bright Blue Button
                    elevation: 0,
                  ),
                  child: const Text(
                    'Claim Item',
                    style: TextStyle(
                      color: Colors.white, // White Text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
>>>>>>> 6ab63f62a024b9d7eb22240c0a0c2d3890c511c1
