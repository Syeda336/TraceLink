import 'package:flutter/material.dart';
import 'warning_admin.dart';
import 'alerts.dart';
import 'home.dart'; // Import to navigate back to Home

// Data structure for a single notification item
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Initial list of notifications with the first three unread (matching the image)
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      // From Image 1: Warning Notice
      NotificationItem(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFF39C12), // Orange
        iconBgColor: const Color(0xFFFEE8D2),
        title: 'Warning Notice',
        message: 'Admin has issued a warning regarding your reported item',
        time: 'Just now',
        isRead: false,
      ),
      // From Image 1: Item Claimed!
      NotificationItem(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF2ecc71), // Green
        iconBgColor: const Color(0xFFD4F9E4),
        title: 'Item Claimed!',
        message: 'Your lost wallet has been claimed successfully',
        time: '5 min ago',
        isRead: false,
      ),
      // From Image 1: New Message
      NotificationItem(
        icon: Icons.chat_bubble_outline,
        iconColor: const Color(0xFF3498db), // Blue
        iconBgColor: const Color(0xFFE3F2FD),
        title: 'New Message',
        message: 'Sarah sent you a message about the keys',
        time: '1h ago',
        isRead: false,
      ),
      // From Image 2: Possible Match
      NotificationItem(
        icon: Icons.inventory_2_outlined,
        iconColor: const Color(0xFF9b59b6), // Purple
        iconBgColor: const Color(0xFFF3E5F5),
        title: 'Possible Match',
        message: 'A found item matches your lost backpack',
        time: '3h ago',
        isRead: false,
      ),
      // From Image 2: Emergency Alert
      NotificationItem(
        icon: Icons.error_outline,
        iconColor: const Color(0xFFe74c3c), // Red
        iconBgColor: const Color(0xFFFBECEC),
        title: 'Emergency Alert',
        message: 'Student ID found at Main Gate',
        time: '5h ago',
        isRead: true, // Marked as read initially
      ),
      // From Image 2: Item Update (using a bell icon for update)
      NotificationItem(
        icon: Icons.notifications_none,
        iconColor: const Color(0xFFF39C12), // Orange
        iconBgColor: const Color(0xFFFEE8D2),
        title: 'Item Update',
        message: 'Someone commented on your post',
        time: '1d ago',
        isRead: true, // Marked as read initially
      ),
    ];
  }

  // Functionality to mark a single notification as read
  void _markAsRead(int index) {
    if (!_notifications[index].isRead) {
      setState(() {
        _notifications[index].isRead = true;
      });
    }
  }

  // Functionality to mark all notifications as read
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  // Handle tap on a notification card
  void _handleNotificationTap(
    BuildContext context,
    NotificationItem item,
    int index,
  ) {
    // 1. Mark the notification as read
    _markAsRead(index);

    // 2. Check for the specific 'Warning Notice'
    if (item.title == 'Warning Notice') {
      // Navigate to warning_admin.dart
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WarningScreen()),
      );
    }
    // You can add other navigation logic here for other notification types
    else if (item.title == 'Emergency Alert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmergencyAlerts()),
      );
    }
  }

  // Widget to build a single notification card
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    int index,
  ) {
    return GestureDetector(
      // Use the new handler function
      onTap: () => _handleNotificationTap(context, item, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
            // Unread Dot (Red/Purple)
            if (!item.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9b59b6), // Vibrant purple dot
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
      backgroundColor: const Color(
        0xFFf3f0f7,
      ), // Light background like home screen
      // Custom AppBar for the back button and "Mark all read" link
      appBar: AppBar(
        backgroundColor: const Color(0xFFf3f0f7),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF4a148c), // Deep purple color
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead, // Functionality to mark all as read
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Color(0xFF9b59b6), // Vibrant purple link color
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
