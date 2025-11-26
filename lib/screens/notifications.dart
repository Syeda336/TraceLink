import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'warning_admin.dart';
import 'alerts.dart';
import 'chat.dart';
import 'community_feed.dart';
import 'dart:async';
import '../theme_provider.dart'; // Import your ThemeProvider
import 'bottom_navigation.dart';

// Define the new Bright Blue theme color (used for consistency)
const Color kBrightBlue = Color(0xFF007AFF);

// Data structure for a single notification item (unchanged)
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String time;
  final DateTime creationTime;
  bool isRead;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    required this.time,
    required this.creationTime,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _notifications;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
    final oneHourAgo = now.subtract(const Duration(hours: 1));
    final threeHoursAgo = now.subtract(const Duration(hours: 3));
    final oneDayAgo = now.subtract(const Duration(days: 1));

    // NOTE: Initialization logic remains the same
    _notifications = [
      NotificationItem(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFF39C12),
        iconBgColor: const Color(0xFFFEE8D2),
        title: 'Warning Notice',
        message: 'Admin has issued a warning regarding your reported item',
        time: 'Just now',
        creationTime: now.subtract(const Duration(seconds: 30)),
        isRead: false,
      ),
      NotificationItem(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF2ecc71),
        iconBgColor: const Color(0xFFD4F9E4),
        title: 'Item Claimed!',
        message: 'Your lost wallet has been claimed successfully',
        time: '5 min ago',
        creationTime: fiveMinutesAgo.add(const Duration(seconds: 1)),
        isRead: false,
      ),
      NotificationItem(
        icon: Icons.chat_bubble_outline,
        iconColor: kBrightBlue,
        iconBgColor: kBrightBlue.withOpacity(0.1),
        title: 'New Message',
        message: 'Sarah sent you a message about the keys',
        time: '1h ago',
        creationTime: oneHourAgo,
        isRead: false,
      ),
      NotificationItem(
        icon: Icons.inventory_2_outlined,
        iconColor: const Color(0xFF9b59b6),
        iconBgColor: const Color(0xFFF3E5F5),
        title: 'Possible Match',
        message: 'A found item matches your lost backpack',
        time: '3h ago',
        creationTime: threeHoursAgo,
        isRead: false,
      ),
      NotificationItem(
        icon: Icons.error_outline,
        iconColor: const Color(0xFFe74c3c),
        iconBgColor: const Color(0xFFFBECEC),
        title: 'Emergency Alert',
        message: 'Student ID found at Main Gate',
        time: '5h ago',
        creationTime: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        icon: Icons.notifications_none,
        iconColor: kBrightBlue,
        iconBgColor: kBrightBlue.withOpacity(0.1),
        title: 'Item Update',
        message: 'Someone commented on your post',
        time: '1d ago',
        creationTime: oneDayAgo,
        isRead: true,
      ),
    ];

    _startAutoRemovalTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Auto-Removal Logic (Unchanged) ---
  void _startAutoRemovalTimer() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _removeOldNotifications();
    });
  }

  void _removeOldNotifications() {
    final now = DateTime.now();
    setState(() {
      _notifications.removeWhere(
        (item) => now.difference(item.creationTime).inSeconds > 300,
      );
    });
  }

  // --- Mark as Read/All Logic (Unchanged) ---
  void _markAsRead(int index) {
    if (!_notifications[index].isRead) {
      setState(() {
        _notifications[index].isRead = true;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  // --- Navigation Logic (Unchanged) ---
  void _handleNotificationTap(
    BuildContext context,
    NotificationItem item,
    int index,
  ) {
    _markAsRead(index);

    if (item.title == 'Warning Notice') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WarningScreen()),
      );
    } else if (item.title == 'Emergency Alert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmergencyAlerts()),
      );
    } else if (item.title == 'New Message') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(
            chatPartnerName: 'Sarah',
            chatPartnerInitials: 'S',
            isOnline: true,
            avatarColor: kBrightBlue,
          ),
        ),
      );
    } else if (item.title == 'Item Update') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CommunityFeed()),
      );
    }
  }

  // --- Dynamic Widget for a single notification card ---
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    int index,
    bool isDarkMode, // Added isDarkMode parameter
  ) {
    // Dynamic Colors
    final Color cardColor = Theme.of(context).cardColor;
    final Color titleColor = isDarkMode ? Colors.white : Colors.black87;
    final Color messageColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade700;
    final Color timeColor = isDarkMode
        ? Colors.grey.shade600
        : Colors.grey.shade500;
    final Color borderColor = isDarkMode
        ? kBrightBlue.withOpacity(0.5)
        : kBrightBlue;

    return GestureDetector(
      onTap: () => _handleNotificationTap(context, item, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          // Dynamic Card Color
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: borderColor, // Dynamic Border Color
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container (Icon colors are fixed in the data structure)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.iconBgColor,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            // Title and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor, // Dynamic Title Color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: messageColor,
                    ), // Dynamic Message Color
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: timeColor,
                    ), // Dynamic Time Color
                  ),
                ],
              ),
            ),
            // Unread Dot (Bright Blue - fixed color)
            if (!item.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kBrightBlue, // Fixed bright blue dot
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Access the ThemeProvider state
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Dynamic Colors based on theme
    final Color backgroundCanvasColor = Theme.of(
      context,
    ).scaffoldBackgroundColor;
    final Color appBarColor = isDarkMode ? Colors.black45 : kBrightBlue;
    final Color backIconBgColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.white;
    final Color backIconColor = isDarkMode ? kBrightBlue : kBrightBlue;

    return Scaffold(
      // Dynamic Background Color
      backgroundColor: backgroundCanvasColor,
      appBar: AppBar(
        // Dynamic AppBar Color
        backgroundColor: appBarColor,
        toolbarHeight: 120.0,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // Dynamic Back Button BG Color
              color: backIconBgColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: backIconColor, // Dynamic Back Button Icon Color
              size: 20,
            ),
          ),
          onPressed: () {
            // Navigate back to the previous screen (e.g., Home)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavScreen()),
            );
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            // White text on both dark and bright blue backgrounds
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(
                // White link color on both dark and bright blue
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map the list data to the dynamic _buildNotificationCard widget
            ..._notifications.asMap().entries.map((entry) {
              return _buildNotificationCard(
                context,
                entry.value,
                entry.key,
                isDarkMode, // Pass the mode state
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
