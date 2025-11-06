import 'package:flutter/material.dart';
import 'profile_page.dart';

class RewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // The top gradient and main content section
          SliverToBoxAdapter(child: RewardsHeader()),

          // The Badges Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Your Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Horizontal list of badges
          SliverToBoxAdapter(child: BadgesRow()),

          // The Rating History Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
              child: Text(
                'Rating History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // The Rating Card
          SliverToBoxAdapter(child: RatingHistoryCard()),

          // The Recent Activity Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
              child: Text(
                'Recent Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
              ActivityItem(
                title: 'Item returned successfully',
                date: 'Oct 9, 2025',
                points: 25,
              ),
              // Add more ActivityItem widgets here
            ]),
          ),

          // Add some bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
      // Use the AppBar to handle the back button and "profile" button
      appBar: AppBar(
        // 'Rewards & Badges' is part of the header, so the AppBar is simplified
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                color: Colors.white.withOpacity(0.3), // Semi-transparent white
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.person_outline, color: Colors.white, size: 20),
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

// --- Custom Widgets ---

class RewardsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
        bottom: 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF8C00),
            Color(0xFFFF007F),
          ], // Orange to Pink gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: <Widget>[
          // Header Text
          Text(
            'Rewards & Badges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),

          // Main Points Card
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.2,
                ), // Semi-transparent white card
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Color(0xFFFF8C00), size: 40),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Total Points',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Level 3 • Community Helper',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to Level 4',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      Text('75/100', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.75, // 75/100
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
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
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, // Keep the width fixed
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          SizedBox(height: 8),
          // Title: Make font slightly smaller if needed, ensure it can wrap
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ), // Slightly reduced font size
            textAlign: TextAlign.center,
            maxLines: 2, // Allow title to wrap if it's long
            overflow:
                TextOverflow.ellipsis, // Add ellipsis if it's still too long
          ),
          SizedBox(height: 4), // Reduced spacing slightly
          // Subtitle: Make font slightly smaller, ensure it can wrap
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ), // Slightly reduced font size
            textAlign: TextAlign.center,
            maxLines: 2, // Allow subtitle to wrap
            overflow:
                TextOverflow.ellipsis, // Add ellipsis if it's still too long
          ),
          SizedBox(height: 5),
          Text(
            'Earned',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class RatingHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rating History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _buildRatingBar(context, 5, 17),
                      _buildRatingBar(context, 4, 2),
                      _buildRatingBar(context, 3, 1),
                      // Assuming 2-star and 1-star are 0 for simplicity,
                      // or add them if they were present.
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

  Widget _buildRatingBar(BuildContext context, int star, int count) {
    // Total number of ratings is 17 + 2 + 1 = 20
    final totalRatings = 20;
    double percentage = totalRatings > 0 ? count / totalRatings : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Text('$star', style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                minHeight: 8,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold)),
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
    required this.title,
    required this.date,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 3),
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+$points',
                style: TextStyle(
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
