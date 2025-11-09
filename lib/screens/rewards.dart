import 'package:flutter/material.dart';
import 'profile_page.dart';

// --- Theme Colors ---
const Color _primaryColor = Color(
  0xFF00B0FF,
); // Bright Blue (Primary theme color)
const Color _accentColor = Color.fromARGB(
  255,
  31,
  155,
  177,
); // Light Blue (Header/background color)
const Color _darkTextColor = Color(
  0xFF0D47A1,
); // Dark Blue (For text on light blue background)
const Color _cardBorderColor = _primaryColor; // Use bright blue for outlines

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade50, // Slightly off-white background for body
      body: CustomScrollView(
        slivers: <Widget>[
          // The top gradient and main content section
          const SliverToBoxAdapter(child: RewardsHeader()),

          // The Badges Section
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Your Badges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Horizontal list of badges
          const SliverToBoxAdapter(child: BadgesRow()),

          // The Rating History Section
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
              child: Text(
                'Rating History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // The Rating Card
          const SliverToBoxAdapter(child: RatingHistoryCard()),

          // The Recent Activity Section
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // List of recent activities
          SliverList(
            delegate: SliverChildListDelegate([
              const ActivityItem(
                title: 'Found wallet',
                date: 'Oct 10, 2025',
                points: 15,
              ),
              const ActivityItem(
                title: 'Item returned successfully',
                date: 'Oct 9, 2025',
                points: 25,
              ),
              // Add more ActivityItem widgets here
            ]),
          ),

          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
      // Use the AppBar to handle the back button and "profile" button
      appBar: AppBar(
        // 'Rewards & Badges' is part of the header, so the AppBar is simplified
        backgroundColor:
            Colors.transparent, // Transparent to show light blue header
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _darkTextColor),
          onPressed: () =>
              Navigator.of(context).pop(), // Standard back behavior
        ),
        actions: [
          // The square button to open profile_page.dart
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _accentColor, // Light blue background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _cardBorderColor,
                  width: 1,
                ), // Blue border
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person_outline,
                  color: Color.fromARGB(255, 187, 224, 241),
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Allow body to go behind AppBar
    );
  }
}

// ------------------------------------
// ## Custom Widgets
// ------------------------------------

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
        bottom: 40,
      ),
      decoration: const BoxDecoration(
        color: _accentColor, // Light blue solid background
      ),
      child: Column(
        children: <Widget>[
          // Header Text
          const Text(
            'Rewards & Badges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 236, 244, 255),
            ),
          ),
          const SizedBox(height: 30),

          // Main Points Card
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white, // White card
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _cardBorderColor,
                  width: 2,
                ), // Bright blue outline
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    decoration: const BoxDecoration(
                      color: _primaryColor, // Bright blue circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Total Points',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const Text(
                    'Level 3 • Community Helper',
                    style: TextStyle(
                      color: _darkTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to Level 4',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text('75/100', style: TextStyle(color: _darkTextColor)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.75, // 75/100
                      backgroundColor: _accentColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        _primaryColor,
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
  const BadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const <Widget>[
          BadgeItem(
            color: Color(0xFF42A5F5), // Blue
            icon: Icons.bookmark_outline,
            title: 'First Find',
            subtitle: 'Found your first item',
          ),
          SizedBox(width: 15),
          BadgeItem(
            color: Color(0xFFFF69B4), // Pink
            icon: Icons.favorite_border,
            title: 'Helper Hero',
            subtitle: 'Returned 5 items',
          ),
          SizedBox(width: 15),
          BadgeItem(
            color: Color(0xFFFFC107), // Amber/Yellow
            icon: Icons.star_outline,
            title: 'Top Contributor',
            subtitle: 'Helped 10 people',
          ),
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

  const BadgeItem({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, // Keep the width fixed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _cardBorderColor.withOpacity(0.5),
          width: 1,
        ), // Light blue outline
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Container(
            width: 50, // Reduced icon container size slightly
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ), // Reduced icon size
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10, // Reduced font size
              color: Colors.grey[600],
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
              color: _primaryColor.withOpacity(
                0.1,
              ), // Light blue background for earned status
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: const Text(
              'Earned',
              style: TextStyle(
                color: _primaryColor, // Bright blue text
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
  const RatingHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _cardBorderColor,
            width: 2,
          ), // Bright blue outline
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Kept the original title styling for the Rating History Card
            const Text(
              'Rating History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4
                              ? Icons.star
                              : Icons.star_half, // 4 full, 1 half for 4.9
                          color: Colors.amber,
                          size: 25,
                        );
                      }),
                    ),
                    Text(
                      'Overall Rating',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _buildRatingBar(5, 17),
                      _buildRatingBar(4, 2),
                      _buildRatingBar(3, 1),
                      // Added remaining bars for completeness, even with 0 counts
                      _buildRatingBar(2, 0),
                      _buildRatingBar(1, 0),
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

  Widget _buildRatingBar(int star, int count) {
    // Total number of ratings is 17 + 2 + 1 = 20
    const int totalRatings = 20;
    double percentage = totalRatings > 0 ? count / totalRatings : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ), // Reduced vertical padding
      child: Row(
        children: <Widget>[
          Text('$star', style: const TextStyle(fontWeight: FontWeight.bold)),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                // Changed valueColor to _primaryColor (Bright Blue)
                valueColor: const AlwaysStoppedAnimation<Color>(_primaryColor),
                minHeight: 6, // Reduced height slightly
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final int points;

  const ActivityItem({
    super.key,
    required this.title,
    required this.date,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _cardBorderColor,
            width: 2,
          ), // Bright blue outline
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _primaryColor, // Changed to Bright Blue
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
