import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Import your ThemeProvider

// Import all destination screens (keeping original names for completeness)
import 'notifications.dart';
import 'search_bar.dart';
import 'alerts.dart';
import 'report_problem.dart';
import 'report_lost.dart';
import 'report_found.dart';
import 'package:tracelink/notifications_service.dart';
// 1. IMPORT YOUR ITEM DESCRIPTION SCREEN HERE
import 'item_description.dart'; // Assuming ItemDetailScreen is defined here


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation helper function (kept for card actions)
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // NOTE: Bottom Navigation State and Logic (selectedIndex, _navItemColors,
  // _onItemTapped, _getIconColor) were removed as they are no longer needed
  // without the BottomNavigationBar.

  // 1. Builds the main gradient header area
  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    // Dynamic Gradient Colors
    const Color lightBlueTop = Color(0xFF1E90FF);
    const Color lightDeepBlueBottom = Color(0xFF007FFF);

    // Dark Mode version of the gradient (slightly deeper/different contrast)
    final Color brightBlueTop = isDarkMode
        ? Colors.lightBlue.shade700
        : lightBlueTop;
    final Color deepBlueBottom = isDarkMode
        ? Colors.blue.shade900
        : lightDeepBlueBottom;

    // Dynamic Text Color for Search Hint
    final Color searchHintColor = isDarkMode
        ? Colors.white70
        : const Color(0xFF4a148c);

    // Dynamic Search Icon Color (uses deep blue in light mode, white in dark mode)
    final Color searchIconColor = isDarkMode ? Colors.white : deepBlueBottom;

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
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
                  color: Colors.white, // Keep white on the dark gradient
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              
              // --- Notifications Button with Dynamic Red Dot ---
            // --- START OF REPLACEMENT ---
              StreamBuilder<int>(
                stream: NotificationsService.getUnreadCountStream(),
                builder: (context, snapshot) {
                  // If we have data, use it. Otherwise 0.
                  int unreadCount = snapshot.data ?? 0;

                  return GestureDetector(
                    onTap: () => _navigateToScreen(context, const NotificationsScreen()),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        // 1. Your Original Button Style (White Box)
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

                        // 2. The Red Dot (Only shows if count > 0)
                        if (unreadCount > 0)
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
                  );
                },
              ),
            ],
          ),
              // --- END OF REPLACEMENT ---
          const SizedBox(height: 5),
          const Text(
            "Let's find what you're looking for",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ), // Keep white70
          ),
          const SizedBox(height: 25),
          // Search Bar
          GestureDetector(
            onTap: () => _navigateToScreen(context, const SearchScreen()),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                // Dynamic Search bar colors
                hintText: 'Search for items...',
                hintStyle: TextStyle(color: searchHintColor),
                prefixIcon: Icon(Icons.search, color: searchIconColor),
                filled: true,
                // Use the theme's card color for the text field background
                fillColor: Theme.of(context).cardColor,
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
    required Color
    backgroundColor, // This color will be dynamically set in build()
    required Widget destination,
  }) {
    // Text color remains white as the background is a saturated blue color
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
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 13,
                  ),
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
    required BuildContext context,
    required bool
    isDarkMode, // Pass the mode directly for simpler conditional logic
    required String title,
    required String location,
    required String time,
    required String status,
    required Color statusColor,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    // Dynamic text colors based on theme
    final Color primaryTextColor =
        Theme.of(context).textTheme.titleMedium?.color ?? Colors.black;

    // Adjusted location/time text colors for better contrast
    final Color locationTextColor = isDarkMode
        ? Colors.lightBlue.shade300
        : const Color.fromARGB(255, 26, 94, 182);
    final Color timeTextColor = isDarkMode
        ? Colors.grey.shade400
        : const Color.fromARGB(255, 99, 147, 209);

    return Card(
      // Use the Theme's Card Color (White in Light, Dark Grey in Dark)
      color: Theme.of(context).cardColor,
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
                    // Dynamic fallback color for missing image
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : const Color.fromARGB(255, 206, 232, 247),
                    child: Icon(
                      Icons.broken_image,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : const Color.fromARGB(255, 158, 158, 158),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor, // Dynamic Text Color
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: locationTextColor, // Dynamic Location Color
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: timeTextColor, // Dynamic Time Color
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
                    color:
                        statusColor, // Status color remains fixed (Lost/Found color)
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
    // Access the ThemeProvider state
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Dynamic Colors derived from Theme/Conditional logic
    final Color backgroundCanvasColor = Theme.of(
      context,
    ).scaffoldBackgroundColor;

    // Consistent white text color for all action cards and alerts
    const Color whiteTextColor = Colors.white;

    // **MODIFIED COLORS START HERE**
    // 1. Emergency Alerts: Red Gradient
    const Color emergencyAlertColor1 = Color(0xFFE53935); // Bright Red
    const Color emergencyAlertColor2 = Color(0xFFB71C1C); // Deep Red

    // 2. Report Lost: Orange Solid Color (Dynamic based on theme for contrast)
    final Color reportLostColor = isDarkMode
        ? const Color.fromARGB(255, 64, 173, 236) // Darker orange for dark mode
        : const Color.fromARGB(
            255,
            132,
            199,
            238,
          ); // Bright orange for light mode

    // 3. Report Found: Green Solid Color (Dynamic based on theme for contrast)
    final Color reportFoundColor = isDarkMode
        ? const Color.fromARGB(255, 64, 173, 236) // Darker green for dark mode
        : const Color.fromARGB(
            255,
            132,
            199,
            238,
          ); // Bright green for light mode

    // 4. Report Problem: Grey Gradient
    final Color reportProblemColor1 = isDarkMode
        ? Colors
              .blueGrey
              .shade700 // Dark grey/blue for dark mode
        : Colors.grey.shade500; // Light grey for light mode
    final Color reportProblemColor2 = isDarkMode
        ? Colors
              .blueGrey
              .shade900 // Deep grey/blue for dark mode
        : Colors.grey.shade700; // Dark grey for light mode
    // **MODIFIED COLORS END HERE**

    // Fixed colors for status tags (can remain the original lost/found colors)
    const Color lostStatusColor = Color(0xFF2980b9);
    const Color foundStatusColor = Color(0xFF2ecc71);

    return Scaffold(
      // Use the theme's background color
      backgroundColor: backgroundCanvasColor,
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
                  // --- Emergency Alert Card (Red Gradient, White Text) ---
                  GestureDetector(
                    onTap: () =>
                        _navigateToScreen(context, const EmergencyAlerts()),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          // RED GRADIENT
                          colors: [emergencyAlertColor1, emergencyAlertColor2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.transparent
                                : Colors.black.withOpacity(0.1),
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
                                    color: whiteTextColor,
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

                  // --- Report Lost / Report Found Row (Orange/Green Solid, White Text) ---
                  Row(
                    children: [
                      _buildActionCard(
                        context: context,
                        icon: Icons.search,
                        iconColor: whiteTextColor,
                        title: 'Report Lost',
                        subtitle: 'Lost something?',
                        backgroundColor: reportLostColor, // **ORANGE**
                        destination: const ReportLostItemScreen(),
                      ),
                      const SizedBox(width: 15),
                      _buildActionCard(
                        context: context,
                        icon: Icons.inventory_2_outlined,
                        iconColor: whiteTextColor,
                        title: 'Report Found',
                        subtitle: 'Found something?',
                        backgroundColor: reportFoundColor, // **GREEN**
                        destination: const ReportFoundItemScreen(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // --- Report a Problem Card (Grey Gradient, White Text) ---
                  GestureDetector(
                    onTap: () =>
                        _navigateToScreen(context, const ReportProblem()),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          // GREY GRADIENT
                          colors: [reportProblemColor1, reportProblemColor2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.transparent
                                : Colors.black.withOpacity(0.1),
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
                                  color: whiteTextColor,
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

                  // --- Recent Posts Section ---
                  Text(
                    'Recent Posts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // Use the theme's body text color (Black/White)
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Passing context and isDarkMode to recent post cards
                  _buildRecentPostCard(
                    context: context,
                    isDarkMode: isDarkMode,
                    title: 'Black Wallet',
                    location: 'Library, 2nd Floor',
                    time: '2h ago',
                    status: 'Lost',
                    statusColor: lostStatusColor,
                    imageUrl: 'lib/images/black_wallet.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      const ItemDetailScreen(itemName: 'Black Wallet'),
                    ),
                  ),
                  _buildRecentPostCard(
                    context: context,
                    isDarkMode: isDarkMode,
                    title: 'Set of Keys',
                    location: 'Cafeteria Entrance',
                    time: '4h ago',
                    status: 'Found',
                    statusColor: foundStatusColor,
                    imageUrl: 'lib/images/key.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      const ItemDetailScreen(itemName: 'Set of Keys'),
                    ),
                  ),
                  _buildRecentPostCard(
                    context: context,
                    isDarkMode: isDarkMode,
                    title: 'Blue Backpack',
                    location: 'Science Building',
                    time: '5h ago',
                    status: 'Lost',
                    statusColor: lostStatusColor,
                    imageUrl: 'lib/images/blue_backpack.jfif',
                    onTap: () => _navigateToScreen(
                      context,
                      const ItemDetailScreen(itemName: 'Blue Backpack'),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // 2. The gradient header is stacked on top and remains fixed
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, isDarkMode),
          ),
        ],
      ),

      // 3. The Bottom Navigation Bar has been removed from this file.
    );
  }
}
