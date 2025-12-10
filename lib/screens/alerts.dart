import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- IMPORT ADDED
import 'report_found.dart';
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
  
  // --- ADD THIS VARIABLE ---
  List<String> _seenAlertIds = [];

  @override
  void initState() {
    super.initState();
    _loadSeenAlerts(); // --- ADD THIS CALL ---
    // 2. Initialize the Future to fetch data
    _alertsFuture = SupabaseAlertService.fetchAlerts();
  }

  // 3. Load seen IDs from SharedPreferences
  Future<void> _loadSeenAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _seenAlertIds = prefs.getStringList('seen_alerts') ?? [];
    });
  }

  // 4. Function to re-fetch data (Removed duplicate function)
  Future<void> _refreshAlerts() async {
    setState(() {
      _alertsFuture = SupabaseAlertService.fetchAlerts();
    });
  }

  // 5. Mark as Seen Logic: Save ID locally and update UI
  Future<void> _markAsSeen(int alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final idString = alertId.toString();

    if (!_seenAlertIds.contains(idString)) {
      setState(() {
        _seenAlertIds.add(idString);
      });
      await prefs.setStringList('seen_alerts', _seenAlertIds);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert marked as seen.')),
        );
      }
    }
  }
  
  // Functionality for "Report Sighting"
  void _reportSighting(Map<String, dynamic> alertData) {
    // Extract the ID
    final alertId = alertData['id'] as int?;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportFoundItemScreen(
          preFilledData: alertData, // Pass the alert details
          alertId: alertId,         // Pass the ID so it can be deleted later
        ),
      ),
    ).then((_) {
      // Refresh the list when coming back
      _refreshAlerts();
    });
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

                  // 5. Mapping Supabase columns to widget properties
                  final itemName = alert['Item Name'] as String? ?? 'N/A';
                  final description =
                      alert['Description'] as String? ?? 'No description';
                  final location =
                      alert['Location'] as String? ?? 'Unknown Location';
                  final priority = alert['Priority'] as String? ?? 'Standard';
                  final imageUrl = alert['Image'] as String?;

                  final timeAgo =
                      'Found: ${alert['created_at'].toString().split('T')[0]}';
                  final isHighPriority = priority.toLowerCase() == 'high';
                  
                  // --- CHECK IF SEEN ---
                  final int alertId = alert['id'];
                  final bool isSeen = _seenAlertIds.contains(alertId.toString());

                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _AlertItemCard(
                      itemName: itemName,
                      description: description,
                      location: location,
                      timeAgo: timeAgo,
                      isHighPriority: isHighPriority,
                      imageUrl: imageUrl, 
                      isSeen: isSeen, // --- PASS SEEN STATUS ---
                      onMarkAsSeen: () => _markAsSeen(alertId), 
                      onReportSighting: () => _reportSighting(alert),
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
  final bool isSeen; // --- ADD THIS FIELD ---

  const _AlertItemCard({
    required this.itemName,
    required this.description,
    required this.location,
    required this.timeAgo,
    required this.isHighPriority,
    required this.onMarkAsSeen,
    required this.onReportSighting,
    required this.cardColor,
    this.isSeen = false, // --- ADD THIS TO CONSTRUCTOR ---
    this.imageUrl,
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
    
    // --- DETERMINE COLORS ---
    final Color effectiveCardColor = isSeen 
        ? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!) 
        : cardColor;
    final double contentOpacity = isSeen ? 0.6 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Opacity(
        opacity: contentOpacity,
        child: Card(
          elevation: isSeen ? 0 : 0, // Remove shadow if seen
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // FIXED: Nested Container correctly inside Card
          child: Container(
            decoration: BoxDecoration(
              color: effectiveCardColor, 
              borderRadius: BorderRadius.circular(15),
              boxShadow: isSeen ? [] : [ // Remove shadow if seen
                BoxShadow(
                  color: Colors.grey.withOpacity(isDarkMode ? 0.1 : 0.2),
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl != null && imageUrl!.isNotEmpty
                              ? Image.network(
                                  imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      PlaceholderImage(
                                        color: darkBlueText,
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        icon: Icons.broken_image,
                                      ),
                                )
                              : PlaceholderImage(
                                  color: darkBlueText,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                            if (!isSeen) // Optionally hide priority if seen
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
                            // Location and Time
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
                          // FIXED: Button Logic
                          onPressed: isSeen ? null : onMarkAsSeen,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: isSeen ? Colors.transparent : darkBlueText, 
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isSeen ? 'Seen' : 'Mark as Seen',
                            style: TextStyle(
                              color: isSeen ? Colors.grey : darkBlueText, 
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onReportSighting,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: brightBlue, 
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