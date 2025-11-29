// lib/screens/notifications.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../notifications_service.dart';
import '../theme_provider.dart';
import 'warning_admin.dart';
import 'alerts.dart';
import 'chat.dart';
import 'community_feed.dart';
import 'bottom_navigation.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic> data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.data,
  });

  factory NotificationItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationItem(
      id: doc.id,
      title: data['title'] ?? 'Notification',
      message: data['message'] ?? '',
      type: data['type'] ?? 'general',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      data: Map<String, dynamic>.from(data['data'] ?? {}),
    );
  }

  // Get icon based on notification type
  IconData get icon {
    switch (type) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'message':
        return Icons.chat_bubble_outline;
      case 'claim':
        return Icons.check_circle_outline;
      case 'emergency':
        return Icons.error_outline;
      case 'item_update':
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'warning':
        return const Color(0xFFF39C12);
      case 'message':
        return Color(0xFF007AFF); // Your bright blue
      case 'claim':
        return const Color(0xFF2ecc71);
      case 'emergency':
        return const Color(0xFFe74c3c);
      case 'item_update':
        return const Color(0xFF9b59b6);
      default:
        return const Color(0xFF007AFF);
    }
  }

  Color get iconBgColor {
    switch (type) {
      case 'warning':
        return const Color(0xFFFEE8D2);
      case 'message':
        return const Color(0xFF007AFF).withOpacity(0.1);
      case 'claim':
        return const Color(0xFFD4F9E4);
      case 'emergency':
        return const Color(0xFFFBECEC);
      case 'item_update':
        return const Color(0xFFF3E5F5);
      default:
        return const Color(0xFF007AFF).withOpacity(0.1);
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isDarkMode),
      body: _buildNotificationsList(),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode ? Colors.black45 : const Color(0xFF007AFF),
      toolbarHeight: 120.0,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDarkMode ? const Color(0xFF007AFF) : const Color(0xFF007AFF),
            size: 20,
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()),
          );
        },
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        StreamBuilder<QuerySnapshot>(
          stream: NotificationsService.getNotificationsStream(),
          builder: (context, snapshot) {
            final hasUnread = snapshot.hasData && 
                snapshot.data!.docs.any((doc) => 
                  (doc.data() as Map<String, dynamic>)['isRead'] == false);
            
            if (!hasUnread) {
              return const SizedBox();
            }
            
            return TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildNotificationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: NotificationsService.getNotificationsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Error loading notifications',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'You\'ll see notifications here when you receive them',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final notifications = snapshot.data!.docs
            .map((doc) => NotificationItem.fromFirestore(doc))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(
              context,
              notifications[index],
              Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    bool isDarkMode,
  ) {
    final Color cardColor = Theme.of(context).cardColor;
    final Color titleColor = isDarkMode ? Colors.white : Colors.black87;
    final Color messageColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;
    final Color timeColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500;
    final Color borderColor = isDarkMode 
        ? const Color(0xFF007AFF).withOpacity(0.5) 
        : const Color(0xFF007AFF);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        NotificationsService.deleteNotification(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _handleNotificationTap(context, item),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.iconBgColor,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: TextStyle(fontSize: 14, color: messageColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.timeAgo,
                      style: TextStyle(fontSize: 12, color: timeColor),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 5),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, NotificationItem item) {
    // Mark as read when tapped
    if (!item.isRead) {
      NotificationsService.markAsRead(item.id);
    }

    // Navigate based on notification type and data
    switch (item.type) {
      case 'warning':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WarningScreen(),
          ),
        );
        break;
      
      case 'message':
        final senderName = item.data['senderName'] ?? 'User';
        
        final senderId = item.data['senderId'];     // Get the sender ID

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: senderName,
              chatPartnerInitials: senderName.isNotEmpty ? senderName.substring(0, 1) : 'U',
              isOnline: true, 
              avatarColor: const Color(0xFF007AFF),
              receiverId: senderId,
              // IMPORTANT: You likely need to add these parameters to your ChatScreen 
              // constructor in chat.dart to load the correct conversation:
              // chatRoomId: chatRoomId,
              // chatPartnerId: senderId,
            ),
          ),
        );
        break;
      
      case 'emergency':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmergencyAlerts()),
        );
        break;
      
      case 'item_update':
      case 'claim':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityFeed()),
        );
        break;
      
      default:
        // Show notification details in a dialog for unknown types
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(item.title),
            content: Text(item.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
    }
  }

  void _markAllAsRead() {
    NotificationsService.markAllAsRead();
  }
}