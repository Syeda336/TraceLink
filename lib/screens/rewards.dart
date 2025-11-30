// rewards.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'profile_page.dart';
import '../theme_provider.dart';

// --- Theme Colors ---
const Color _primaryColorLight = Color(0xFF00B0FF);
const Color _accentColorLight = Color.fromARGB(255, 31, 155, 177);
const Color _darkTextColorLight = Color(0xFF0D47A1);

const Color _primaryColorDark = Color(0xFF4FC3F7);
const Color _accentColorDark = Color(0xFF1E88E5);
const Color _textColorDark = Colors.white70;
const Color _cardColorDark = Color(0xFF2C2C2C);

Color _getPrimaryColor(bool isDarkMode) => isDarkMode ? _primaryColorDark : _primaryColorLight;
Color _getAccentColor(bool isDarkMode) => isDarkMode ? _accentColorDark : _accentColorLight;
Color _getDarkTextColor(bool isDarkMode) => isDarkMode ? _textColorDark : _darkTextColorLight;
Color _getCardColor(bool isDarkMode) => isDarkMode ? _cardColorDark : Colors.white;

class RewardsPage extends StatelessWidget {
  final int foundCount;
  final int returnedCount;

  // Constructor now accepts the real data
  const RewardsPage({
    super.key, 
    this.foundCount = 0, 
    this.returnedCount = 0
  });

  @override
  Widget build(BuildContext context) {
    // --- CALCULATION LOGIC ---
    // Found = 15 pts, Returned = 25 pts
    final int totalPoints = (foundCount * 15) + (returnedCount * 25);
    final int currentLevel = (totalPoints / 100).floor();
    
    // Logic for next level progress
    final int nextLevelThreshold = (currentLevel + 1) * 100;
    final int pointsToNext = nextLevelThreshold - totalPoints;
    final double progress = (totalPoints % 100) / 100.0;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDarkMode = themeProvider.isDarkMode;
        final Color darkTextColor = _getDarkTextColor(isDarkMode);
        final Color accentColor = _getAccentColor(isDarkMode);
        final Color primaryColor = _getPrimaryColor(isDarkMode);

        return Scaffold(
          backgroundColor: isDarkMode
              ? Theme.of(context).colorScheme.background
              : Colors.grey.shade50,
          body: CustomScrollView(
            slivers: <Widget>[
              // Header with DYNAMIC data
              SliverToBoxAdapter(
                child: RewardsHeader(
                  isDarkMode: isDarkMode,
                  totalPoints: totalPoints,
                  currentLevel: currentLevel,
                  progress: progress,
                  pointsToNext: pointsToNext,
                )
              ),

              // Badges Section
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

              SliverToBoxAdapter(
                child: BadgesRow(
                  isDarkMode: isDarkMode,
                  foundCount: foundCount,
                  returnedCount: returnedCount,
                )
              ),

              // RECENT ACTIVITY (Based on your counts)
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

              SliverList(
                delegate: SliverChildListDelegate([
                  if (totalPoints == 0)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text("Start finding items to earn points!", style: TextStyle(color: darkTextColor.withOpacity(0.6))),
                      ),
                    ),
                  
                  if (returnedCount > 0)
                    ActivityItem(
                      title: 'Items Returned ($returnedCount)',
                      date: 'Community Contribution',
                      points: returnedCount * 25,
                      isDarkMode: isDarkMode,
                    ),
                  
                  if (foundCount > 0)
                    ActivityItem(
                      title: 'Items Found ($foundCount)',
                      date: 'Community Contribution',
                      points: foundCount * 15,
                      isDarkMode: isDarkMode,
                    ),

                  const SizedBox(height: 50),
                ]),
              ),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: darkTextColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          extendBodyBehindAppBar: true,
        );
      },
    );
  }
}

// ------------------------------------
// ## Custom Widgets
// ------------------------------------

class RewardsHeader extends StatelessWidget {
  final bool isDarkMode;
  final int totalPoints;
  final int currentLevel;
  final double progress;
  final int pointsToNext;

  const RewardsHeader({
    super.key, 
    required this.isDarkMode,
    required this.totalPoints,
    required this.currentLevel,
    required this.progress,
    required this.pointsToNext,
  });

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
      decoration: BoxDecoration(color: accentColor),
      child: Column(
        children: <Widget>[
          Text(
            'Rewards & Badges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color.fromARGB(255, 236, 244, 255),
            ),
          ),
          const SizedBox(height: 30),

          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: _getCardColor(isDarkMode),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: primaryColor, width: 2),
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
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    // Keep the Star Icon as requested for the header
                    child: const Icon(Icons.star, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Total Points: $totalPoints',
                    style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black54, fontSize: 16),
                  ),
                  Text(
                    'Level $currentLevel',
                    style: TextStyle(color: darkTextColor, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Next Level', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black54)),
                      Text('$pointsToNext pts needed', style: TextStyle(color: darkTextColor)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: accentColor.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
  final int foundCount;
  final int returnedCount;

  const BadgesRow({
    super.key, 
    required this.isDarkMode,
    required this.foundCount,
    required this.returnedCount,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(isDarkMode);

    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          // Badge 1: First Find (Uses Icons.bookmark_outline as requested)
          BadgeItem(
            color: const Color(0xFF42A5F5),
            icon: Icons.bookmark_outline, // PRESERVED ICON
            title: 'First Find',
            subtitle: 'Found your 1st item',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
            isUnlocked: foundCount >= 1,
          ),
          const SizedBox(width: 15),
          
          // Badge 2: Helper Hero (Uses Icons.favorite_border as requested)
          BadgeItem(
            color: const Color(0xFFFF69B4),
            icon: Icons.favorite_border, // PRESERVED ICON
            title: 'Helper Hero',
            subtitle: 'Returned 1 item',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
            isUnlocked: returnedCount >= 1,
          ),
          const SizedBox(width: 15),
          
          // Badge 3: Top Contributor (Uses Icons.star_outline as requested)
          BadgeItem(
            color: const Color(0xFFFFC107),
            icon: Icons.star_outline, // PRESERVED ICON
            title: 'Top Contributor',
            subtitle: 'Found 5+ items',
            isDarkMode: isDarkMode,
            primaryColor: primaryColor,
            isUnlocked: foundCount >= 5,
          ),
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
  final Color primaryColor;
  final bool isUnlocked;

  const BadgeItem({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    required this.primaryColor,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    // Dim the badge if not unlocked
    final double opacity = isUnlocked ? 1.0 : 0.5;
    final Color effectiveIconColor = isUnlocked ? Colors.white : Colors.white.withOpacity(0.5);

    return Opacity(
      opacity: opacity,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: _getCardColor(isDarkMode),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
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
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: effectiveIconColor, size: 28),
            ),
            const SizedBox(height: 8),
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
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Text(
                isUnlocked ? 'EARNED' : 'LOCKED',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryColor, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05), blurRadius: 5, offset: const Offset(0, 3)),
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '+$points',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}