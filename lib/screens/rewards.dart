import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Import provider
import 'profile_page.dart';
import '../theme_provider.dart'; // 2. Import ThemeProvider

// --- Theme Colors (Light Mode Defaults) ---
const Color _primaryColorLight = Color(0xFF00B0FF); // Bright Blue
const Color _accentColorLight = Color.fromARGB(255, 31, 155, 177); // Light Blue
const Color _darkTextColorLight = Color(0xFF0D47A1); // Dark Blue

// --- Theme Colors (Dark Mode Alternatives) ---
const Color _primaryColorDark = Color(
  0xFF4FC3F7,
); // Lighter Blue for visibility
const Color _accentColorDark = Color(0xFF1E88E5); // Mid Blue
const Color _textColorDark = Colors.white70; // General text on dark background
const Color _cardColorDark = Color(0xFF2C2C2C); // Dark card background

// Helper to get dynamic colors
Color _getPrimaryColor(bool isDarkMode) =>
    isDarkMode ? _primaryColorDark : _primaryColorLight;
Color _getAccentColor(bool isDarkMode) =>
    isDarkMode ? _accentColorDark : _accentColorLight;
Color _getDarkTextColor(bool isDarkMode) =>
    isDarkMode ? _textColorDark : _darkTextColorLight;
Color _getCardColor(bool isDarkMode) =>
    isDarkMode ? _cardColorDark : Colors.white;

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Use Consumer to listen to theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDarkMode = themeProvider.isDarkMode;
        final Color primaryColor = _getPrimaryColor(isDarkMode);
        final Color accentColor = _getAccentColor(isDarkMode);
        final Color darkTextColor = _getDarkTextColor(isDarkMode);

        return Scaffold(
          backgroundColor: isDarkMode
              ? Theme.of(context)
                    .colorScheme
                    .background // Use system dark BG
              : Colors.grey.shade50, // Slightly off-white background for body
          body: CustomScrollView(
            slivers: <Widget>[
              // The top gradient and main content section
              SliverToBoxAdapter(child: RewardsHeader(isDarkMode: isDarkMode)),

              // The Badges Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Your Badges',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),

              // Horizontal list of badges
              SliverToBoxAdapter(child: BadgesRow(isDarkMode: isDarkMode)),

              // The Rating History Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                  child: Text(
                    'Rating History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),

              // The Rating Card
              SliverToBoxAdapter(
                child: RatingHistoryCard(isDarkMode: isDarkMode),
              ),

              // The Recent Activity Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                  child: Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),

              // List of recent activities
              SliverList(
                delegate: SliverChildListDelegate([
                  ActivityItem(
                    title: 'Found wallet',
                    date: 'Oct 10, 2025',
                    points: 15,
                    isDarkMode: isDarkMode,
                  ),
                  ActivityItem(
                    title: 'Item returned successfully',
                    date: 'Oct 9, 2025',
                    points: 25,
                    isDarkMode: isDarkMode,
                  ),
                  // Add more ActivityItem widgets here
                  const SizedBox(height: 10),
                ]),
              ),

              // Add some bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
          // Use the AppBar to handle the back button and "profile" button
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent to show header
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: darkTextColor,
              ), // Dynamic color
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              // The square button to open profile_page.dart
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor, // Dynamic light blue background
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor, // Dynamic Blue border
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(
                              255,
                              187,
                              224,
                              241,
                            ), // Dynamic icon color
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          extendBodyBehindAppBar: true, // Allow body to go behind AppBar
        );
      },
    );
  }
}

// ------------------------------------
// ## Custom Widgets (Updated for Theming)
// ------------------------------------

class RewardsHeader extends StatelessWidget {
  final bool isDarkMode;
  const RewardsHeader({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(isDarkMode);
    final Color accentColor = _getAccentColor(isDarkMode);
    final Color darkTextColor = _getDarkTextColor(isDarkMode);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
        bottom: 40,
      ),
      decoration: BoxDecoration(
        color: accentColor, // Dynamic accent color
      ),
      child: Column(
        children: <Widget>[
          // Header Text
          Text(
            'Rewards & Badges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? Colors.white
                  : const Color.fromARGB(255, 236, 244, 255), // Light text
            ),
          ),
          const SizedBox(height: 30),

          // Main Points Card
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: _getCardColor(isDarkMode), // Dynamic card color
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: primaryColor,
                  width: 2,
                ), // Dynamic bright blue outline
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor, // Dynamic bright blue circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Total Points',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Level 3 • Community Helper',
                    style: TextStyle(
                      color: darkTextColor, // Dynamic Dark/Light text color
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to Level 4',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.black54,
                        ),
                      ),
                      Text(
                        '75/100',
                        style: TextStyle(color: darkTextColor),
                      ), // Dynamic Dark/Light text color
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.75, // 75/100
                      backgroundColor: accentColor.withOpacity(
                        0.5,
                      ), // Dynamic accent color
                      valueColor: AlwaysStoppedAnimation<Color>(
                        primaryColor, // Dynamic primary color
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BadgesRow extends StatelessWidget {
  final bool isDarkMode;
  const BadgesRow({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(isDarkMode);

    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          BadgeItem(
            color: const Color(0xFF42A5F5), // Blue
            icon: Icons.bookmark_outline,
            title: 'First Find',
            subtitle: 'Found your first item',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
          ),
          const SizedBox(width: 15),
          BadgeItem(
            color: const Color(0xFFFF69B4), // Pink
            icon: Icons.favorite_border,
            title: 'Helper Hero',
            subtitle: 'Returned 5 items',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
          ),
          const SizedBox(width: 15),
          BadgeItem(
            color: const Color(0xFFFFC107), // Amber/Yellow
            icon: Icons.star_outline,
            title: 'Top Contributor',
            subtitle: 'Helped 10 people',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
          ),
          const SizedBox(width: 15),
          // Add more badges as needed
        ],
      ),
    );
  }
}

class BadgeItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDarkMode;
  final Color primaryColor; // Primary color passed down

  const BadgeItem({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, // Keep the width fixed
      decoration: BoxDecoration(
        color: _getCardColor(isDarkMode), // Dynamic card color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: primaryColor.withOpacity(0.5), // Dynamic primary color outline
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(), // Pushes "Earned" to the bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(
                0.1,
              ), // Dynamic light blue background
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Text(
              'Earned',
              style: TextStyle(
                color: primaryColor, // Dynamic bright blue text
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class RatingHistoryCard extends StatelessWidget {
  final bool isDarkMode;
  const RatingHistoryCard({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(isDarkMode);
    final Color cardColor = _getCardColor(isDarkMode);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor, // Dynamic card color
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: primaryColor,
            width: 2,
          ), // Dynamic bright blue outline
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rating History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_half,
                          color: Colors.amber,
                          size: 25,
                        );
                      }),
                    ),
                    Text(
                      'Overall Rating',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _buildRatingBar(5, 17, primaryColor, isDarkMode),
                      _buildRatingBar(4, 2, primaryColor, isDarkMode),
                      _buildRatingBar(3, 1, primaryColor, isDarkMode),
                      _buildRatingBar(2, 0, primaryColor, isDarkMode),
                      _buildRatingBar(1, 0, primaryColor, isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(
    int star,
    int count,
    Color primaryColor,
    bool isDarkMode,
  ) {
    // Total number of ratings is 17 + 2 + 1 = 20
    const int totalRatings = 20;
    double percentage = totalRatings > 0 ? count / totalRatings : 0.0;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color barBackground = isDarkMode
        ? Colors.grey[700]!
        : Colors.grey[300]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Text(
            '$star',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: barBackground,
                valueColor: AlwaysStoppedAnimation<Color>(
                  primaryColor,
                ), // Dynamic primary color
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final int points;
  final bool isDarkMode;

  const ActivityItem({
    super.key,
    required this.title,
    required this.date,
    required this.points,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(isDarkMode);
    final Color cardColor = _getCardColor(isDarkMode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor, // Dynamic card color
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primaryColor,
            width: 2,
          ), // Dynamic bright blue outline
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor, // Dynamic Primary Color
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+$points',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
