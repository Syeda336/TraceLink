import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

// --- Theme Color Definitions (Now Dynamic) ---

// Base colors (Used as a reference, actual theme colors are pulled from Theme.of(context))
const Color _brightBlueBase = Color(0xFF1E88E5);
const Color _darkBlueTextBase = Color(0xFF0D47A1);
const Color _lightBlueBackgroundBase = Color(0xFFE3F2FD);

class EmergencyAlerts extends StatefulWidget {
  const EmergencyAlerts({super.key});

  @override
  State<EmergencyAlerts> createState() => _EmergencyAlertsState();
}

class _EmergencyAlertsState extends State<EmergencyAlerts> {
  // Data structure for an alert item (UNCHANGED)
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

  // Functionality for "Mark as Seen" (UNCHANGED)
  void _markAsSeen(int index) {
    if (index >= 0 && index < _alerts.length) {
      String itemName = _alerts[index]['itemName'];
      setState(() {
        _alerts.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemName marked as seen and removed.')),
      );
    }
  }

  // Functionality for "Report Sighting" (Modified to use Theme colors)
  void _reportSighting(String itemName) {
    final brightBlue = Theme.of(context).primaryColor;

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
              child: Text('OK', style: TextStyle(color: brightBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors from Theme.of(context)
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brightBlue = Theme.of(context).primaryColor;
    final isDarkMode = themeProvider.isDarkMode;

    // Dynamic colors for content
    final darkBlueText = isDarkMode ? Colors.white : _darkBlueTextBase;
    final lightBackground = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(
      context,
    ).cardColor; // Card color is now theme-aware

    return Scaffold(
      backgroundColor: lightBackground,
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar: Header (Bright Blue) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                // Use brightBlue/primaryColor in the gradient
                gradient: LinearGradient(
                  colors: [
                    brightBlue,
                    isDarkMode
                        ? const Color(0xFF0D47A1)
                        : const Color(0xFF42A5F5),
                  ],
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
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Emergency Alerts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'High-priority lost items that need urgent attention',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- SliverList: Alert Cards (Dynamic Background) ---
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
                  onMarkAsSeen: () => _markAsSeen(index),
                  onReportSighting: () => _reportSighting(alert['itemName']),
                  imageWidget: PlaceholderImage(
                    color: darkBlueText, // Use theme-aware color
                    backgroundColor: lightBackground,
                    icon: alert['imageIcon'],
                  ),
                  cardColor: cardColor,
                ),
              );
            }, childCount: _alerts.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// --- Alert Item Card Widget (Modified) ---
class _AlertItemCard extends StatelessWidget {
  final String itemName;
  final String description;
  final String location;
  final String timeAgo;
  final String views;
  final bool isHighPriority;
  final Widget imageWidget;
  final VoidCallback onMarkAsSeen;
  final VoidCallback onReportSighting;
  final Color cardColor; // Added to make the card background theme-aware

  const _AlertItemCard({
    required this.itemName,
    required this.description,
    required this.location,
    required this.timeAgo,
    required this.views,
    required this.isHighPriority,
    required this.imageWidget,
    required this.onMarkAsSeen,
    required this.onReportSighting,
    required this.cardColor, // Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    final brightBlue = Theme.of(context).primaryColor;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // Theme-aware dark text color
    final darkBlueText = isDarkMode ? Colors.white : _darkBlueTextBase;

    // Determine the priority tag text and color
    final String priorityText = isHighPriority ? 'High Priority' : 'Priority';
    final Color priorityColor = isHighPriority
        ? const Color(0xFFDC3545) // Red for High Priority
        : Colors.orange; // Orange for regular Priority

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor, // Use the passed-in theme-aware card color
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(
                  isDarkMode ? 0.1 : 0.2, // Less shadow in dark mode
                ),
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
                        color: Theme.of(
                          context,
                        ).scaffoldBackgroundColor, // Background for placeholder is theme's scaffold bg
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
                          // Priority Tag (UNCHANGED)
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
                          // Item Name
                          Text(
                            itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: darkBlueText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Description
                          Text(
                            description,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
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
                        onPressed: onMarkAsSeen,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: darkBlueText, // Dark blue/white outline
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Mark as Seen',
                          style: TextStyle(color: darkBlueText, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onReportSighting,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: brightBlue, // Bright blue fill
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Report Sighting',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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

// Helper Widget for Info Rows (Modified)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final darkBlueText = isDarkMode ? Colors.white : _darkBlueTextBase;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: darkBlueText.withOpacity(0.7), // Subtle icon
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: darkBlueText.withOpacity(0.8), // Dark/light text
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// --- Placeholder Widget for Images (Modified) ---
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color backgroundColor;

  const PlaceholderImage({
    super.key,
    required this.color,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(child: Icon(icon, size: 40, color: color)),
    );
  }
}
