import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import '../supabase_alerts_service.dart';

// --- Theme Color Definitions (Used only for base colors in helper widgets) ---
// Note: _darkBlueTextBase is used in _AlertItemCard
const Color _darkBlueTextBase = Color(0xFF0D47A1);

// A simple mapping for icon display based on item name (optional logic)
IconData _getIconForAlert(String itemName) {
  final lowerCaseName = itemName.toLowerCase();
  if (lowerCaseName.contains('id') || lowerCaseName.contains('card')) {
    return Icons.badge;
  }
  if (lowerCaseName.contains('macbook') || lowerCaseName.contains('laptop')) {
    return Icons.laptop_mac;
  }
  if (lowerCaseName.contains('glasses') ||
      lowerCaseName.contains('spectacles')) {
    return Icons.remove_red_eye;
  }
  return Icons.warning_amber;
}

// --- EmergencyAlerts Widget (Stateful) ---

class EmergencyAlerts extends StatefulWidget {
  const EmergencyAlerts({super.key});

  @override
  State<EmergencyAlerts> createState() => _EmergencyAlertsState();
}

class _EmergencyAlertsState extends State<EmergencyAlerts> {
  // 1. Use a Future to hold the fetched data
  late Future<List<Map<String, dynamic>>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the Future to fetch data
    _alertsFuture = SupabaseAlertService.fetchAlerts();
  }

  // 3. Function to re-fetch data (for pull-to-refresh or after an action)
  Future<void> _refreshAlerts() async {
    setState(() {
      _alertsFuture = SupabaseAlertService.fetchAlerts();
    });
  }

  // Functionality for "Mark as Seen"
  void _markAsSeen(Map<String, dynamic> alert, int index) {
    // NOTE: In a real app, you would call SupabaseAlertService.deleteAlert(alert['id'])
    // and then refresh the list.
    _refreshAlerts().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${alert['Item Name']} marked as seen (refreshing list).',
          ),
        ),
      );
    });
  }

  // Functionality for "Report Sighting"
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
    final cardColor = Theme.of(context).cardColor;

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

          // 4. Use FutureBuilder to handle the asynchronous data fetching
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _alertsFuture,
            builder: (context, snapshot) {
              // Show a circular progress indicator while loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Show error if data fetching failed
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error loading alerts: ${snapshot.error}',
                      style: TextStyle(color: darkBlueText),
                    ),
                  ),
                );
              }

              // Get the alerts list
              final alerts = snapshot.data ?? [];

              // Show a message if no alerts are found
              if (alerts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No emergency alerts found.')),
                );
              }

              // --- SliverList: Alert Cards (Dynamic Background) ---
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final alert = alerts[index];

                  // 5. Mapping Supabase columns to widget properties (UPDATED for Image URL)
                  final itemName = alert['Item Name'] as String? ?? 'N/A';
                  final description =
                      alert['Description'] as String? ?? 'No description';
                  final location =
                      alert['Location'] as String? ?? 'Unknown Location';
                  final priority = alert['Priority'] as String? ?? 'Standard';
                  final imageUrl =
                      alert['Image'] as String?; // <--- FETCH IMAGE URL

                  // Use created_at timestamp to calculate time ago (simplified)
                  final timeAgo =
                      'Found: ${alert['created_at'].toString().split('T')[0]}';
                  final isHighPriority = priority.toLowerCase() == 'high';

                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _AlertItemCard(
                      itemName: itemName,
                      description: description,
                      location: location,
                      timeAgo: timeAgo,
                      isHighPriority: isHighPriority,
                      imageUrl: imageUrl, // <--- PASS IMAGE URL
                      onMarkAsSeen: () => _markAsSeen(alert, index),
                      onReportSighting: () => _reportSighting(itemName),
                      cardColor: cardColor,
                    ),
                  );
                }, childCount: alerts.length),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- Alert Item Card Widget (Handles Image.network) ---
// -----------------------------------------------------------------------------
class _AlertItemCard extends StatelessWidget {
  final String itemName;
  final String description;
  final String location;
  final String timeAgo;
  final bool isHighPriority;
  final String? imageUrl; // Image URL
  final VoidCallback onMarkAsSeen;
  final VoidCallback onReportSighting;
  final Color cardColor;

  const _AlertItemCard({
    required this.itemName,
    required this.description,
    required this.location,
    required this.timeAgo,
    required this.isHighPriority,
    required this.onMarkAsSeen,
    required this.onReportSighting,
    required this.cardColor,
    this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final brightBlue = Theme.of(context).primaryColor;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final darkBlueText = isDarkMode ? Colors.white : _darkBlueTextBase;

    final String priorityText = isHighPriority ? 'High Priority' : 'Priority';
    final Color priorityColor = isHighPriority
        ? const Color(0xFFDC3545) // Red for High Priority
        : Colors.orange; // Orange for regular Priority

    final IconData fallbackIcon = _getIconForAlert(itemName);

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
                    // Item Image/Placeholder (LOGIC FOR IMAGE.NETWORK AND FALLBACK)
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
                        child: imageUrl != null && imageUrl!.isNotEmpty
                            ? Image.network(
                                // Use Image.network for actual image
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    PlaceholderImage(
                                      // Fallback if network image fails
                                      color: darkBlueText,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      icon: Icons.broken_image,
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          color: brightBlue,
                                        ),
                                      );
                                    },
                              )
                            : PlaceholderImage(
                                // Fallback to icon if no URL
                                color: darkBlueText,
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                icon: fallbackIcon,
                              ),
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

// -----------------------------------------------------------------------------
// --- Helper Widgets (UNCHANGED) ---
// -----------------------------------------------------------------------------

// Helper Widget for Info Rows
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text, super.key});

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

// Placeholder Widget for Images (used as fallback)
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
