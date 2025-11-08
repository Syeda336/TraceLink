import 'package:flutter/material.dart';
import 'warning_admin.dart';
import 'alerts.dart';
import 'home.dart';
import 'chat.dart'; // Import for New Message navigation
import 'community_feed.dart'; // Import for Item Update navigation
import 'dart:async'; // Import for the timer logic

// Define the new Bright Blue theme color
const Color kBrightBlue = Color(0xFF007AFF); // A standard vibrant blue
const Color kLightBlueBackground = Color(
  0xFFE3F2FD,
); // A very light blue background

// Data structure for a single notification item
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String time;
  final DateTime creationTime; // Added for auto-removal logic
  bool isRead;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    required this.time,
    required this.creationTime, // Must be initialized
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

    // Use a fixed time for initial items for simple removal logic demonstration
    final now = DateTime.now();
    final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
    now.subtract(const Duration(minutes: 50));
    final oneHourAgo = now.subtract(const Duration(hours: 1));
    final threeHoursAgo = now.subtract(const Duration(hours: 3));
    final oneDayAgo = now.subtract(const Duration(days: 1));

    _notifications = [
      // Warning Notice
      NotificationItem(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFF39C12),
        iconBgColor: const Color(0xFFFEE8D2),
        title: 'Warning Notice',
        message: 'Admin has issued a warning regarding your reported item',
        time: 'Just now',
        creationTime: now.subtract(
          const Duration(seconds: 30),
        ), // ~30 seconds old
        isRead: false,
      ),
      // Item Claimed!
      NotificationItem(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF2ecc71),
        iconBgColor: const Color(0xFFD4F9E4),
        title: 'Item Claimed!',
        message: 'Your lost wallet has been claimed successfully',
        time: '5 min ago',
        creationTime: fiveMinutesAgo.add(
          const Duration(seconds: 1),
        ), // Just under 5 min
        isRead: false,
      ),
      // New Message - Navigates to ChatScreen
      NotificationItem(
        icon: Icons.chat_bubble_outline,
        iconColor: kBrightBlue, // Blue theme color
        iconBgColor: kBrightBlue.withOpacity(0.1),
        title: 'New Message',
        message: 'Sarah sent you a message about the keys',
        time: '1h ago',
        creationTime: oneHourAgo,
        isRead: false,
      ),
      // Possible Match
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
      // Emergency Alert
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
      // Item Update - Navigates to CommunityFeed
      NotificationItem(
        icon: Icons.notifications_none,
        iconColor: kBrightBlue, // Blue theme color
        iconBgColor: kBrightBlue.withOpacity(0.1),
        title: 'Item Update',
        message: 'Someone commented on your post',
        time: '1d ago',
        creationTime: oneDayAgo,
        isRead: true,
      ),
    ];

    // Start the timer for auto-removal
    _startAutoRemovalTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  // --- Auto-Removal Logic ---
  void _startAutoRemovalTimer() {
    // Check and remove every 60 seconds (1 minute) for efficiency
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _removeOldNotifications();
    });
  }

  void _removeOldNotifications() {
    final now = DateTime.now();
    setState(() {
      // Remove notifications older than 5 minutes (300 seconds)
      _notifications.removeWhere(
        (item) => now.difference(item.creationTime).inSeconds > 300,
      );
    });
  }

  // --- Mark as Read/All Logic ---
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

  // --- Navigation Logic ---
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
      // Navigate to ChatScreen with specific user details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(
            chatPartnerName: 'Sarah',
            chatPartnerInitials: 'S',
            isOnline: true,
            avatarColor: kBrightBlue, // Using the new theme color
          ),
        ),
      );
    } else if (item.title == 'Item Update') {
      // Navigate to CommunityFeed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CommunityFeed()),
      );
    }
    // Other notifications (Item Claimed, Possible Match) just mark as read
  }

  // --- Widget for a single notification card ---
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(context, item, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: kBrightBlue, // Bright blue outline
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            // Unread Dot (Bright Blue)
            if (!item.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kBrightBlue, // Bright blue dot
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
    return Scaffold(
      backgroundColor: kLightBlueBackground, // Light blue background
      appBar: AppBar(
        backgroundColor: kBrightBlue, // Bright blue AppBar
        toolbarHeight: 120.0,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: kBrightBlue, // Deep blue color for icon
              size: 20,
            ),
          ),
          onPressed: () {
            // Navigate back to the previous screen (e.g., Home)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white, // White text on bright blue background
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead, // Functionality to mark all as read
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Colors.white, // White link color on bright blue
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
            // Map the list data to the _buildNotificationCard widget
            ..._notifications.asMap().entries.map((entry) {
              return _buildNotificationCard(context, entry.value, entry.key);
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
