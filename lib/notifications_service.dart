// lib/notifications_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';
import 'dart:async'; // <--- Fixes StreamSubscription error

class NotificationsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection for user-specific notifications
  static String get _notificationsCollection => 'user_notifications';
  
  // Add a new notification
  static Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    required String type, // 'warning', 'message', 'claim', 'emergency', 'item_update'
    required Map<String, dynamic> data, // Additional data for navigation
  }) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(userId)
          .collection('notifications')
          .add({
        'title': title,
        'message': message,
        'type': type,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'userId': userId,
      });
      print('✅ Notification added for user: $userId');
    } catch (e) {
      print('❌ Error adding notification: $e');
    }
  }
  
  // Get real-time notifications stream for current user
  static Stream<QuerySnapshot> getNotificationsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      print(' No user logged in for notifications');
      return const Stream.empty();
    }
    
    return _firestore
        .collection(_notificationsCollection)
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false) // <--- ADD THIS LINE
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  
  // Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
      print('✅ Notification marked as read: $notificationId');
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }
  
  // Mark all notifications as read
  static Future<void> markAllAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    try {
      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      
      await batch.commit();
      print('✅ All notifications marked as read');
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
    }
  }
  
  // Send warning notification from admin
  static Future<void> sendWarningNotification({
    required String targetUserId,
    required String itemTitle,
    required String itemId,
    required String adminMessage,
  }) async {
    await addNotification(
      userId: targetUserId,
      title: 'Warning Notice',
      message: 'Admin has issued a warning regarding "$itemTitle"',
      type: 'warning',
      data: {
        'itemTitle': itemTitle,
        'itemId': itemId,
        'adminMessage': adminMessage,
        'screen': 'warning_admin',
      },
    );
  }
  
  // Send message notification
 
  static Future<void> sendMessageNotification({
    required String targetUserId, // The person receiving the message
    required String senderId,     // The person sending the message (NEW)
    required String senderName,
    required String messagePreview,
    required String chatRoomId,
  }) async {
    await addNotification(
      userId: targetUserId,
      title: 'New Message from $senderName',
      message: messagePreview,
      type: 'message',
      data: {
        'senderId': senderId, // Store this for navigation
        'senderName': senderName,
        'chatRoomId': chatRoomId,
        'screen': 'chat',
      },
    );
  }


  //*************listen for new notifications and trigger push**************************** */
  // --- NEW: Listen for new notifications and trigger Push ---
  static StreamSubscription<QuerySnapshot>? _subscription;

  static void initializeNotificationListener() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // 1. Cancel any existing subscription to avoid duplicates
    _subscription?.cancel();

    // 2. Listen to the stream
    _subscription = _firestore
        .collection(_notificationsCollection)
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(1) // Only watch the latest item
        .snapshots()
        .listen((snapshot) async {
      
      if (snapshot.docs.isEmpty) return;

      // 3. Check if this is a NEW item (added just now)
      // We check if the timestamp is very recent (e.g., within last 10 seconds)
      // This prevents old notifications from popping up when you open the app.
      final doc = snapshot.docs.first;
      final data = doc.data();
      final Timestamp? timestamp = data['timestamp'] as Timestamp?;

      if (timestamp == null) return;

      final now = DateTime.now();
      final diff = now.difference(timestamp.toDate()).inSeconds;

      // Only trigger if it happened in the last 10 seconds AND it's a "fresh" change
      if (diff < 10) {
        
        // 4. CHECK SETTINGS: Is "Push Notifications" enabled?
        // We fetch the latest settings to be sure.
        final settings = await FirebaseService.getPrivacySettings(); // Or getNotificationSettings()
        // Note: Check your specific settings key. Based on settings.dart, it might be stored under 'privacySettings' or similar.
        // If you don't have a direct settings fetcher, you can default to true.
        bool pushEnabled = true; 
        if (settings != null && settings.containsKey('pushEnabled')) {
           pushEnabled = settings['pushEnabled'];
        }

        if (pushEnabled) {
          // 5. Trigger the System Notification
          await FirebaseService.showLocalNotification(
            id: doc.id,
            title: data['title'] ?? 'New Notification',
            body: data['message'] ?? 'You have a new update.',
            payload: doc.id, // Or pass the full data JSON string if needed
          );
        }
      }
    });
  }



  // Send claim notification
  static Future<void> sendClaimNotification({
    required String targetUserId,
    required String itemTitle,
    required String claimStatus,
  }) async {
    await addNotification(
      userId: targetUserId,
      title: 'Item Claimed!',
      message: 'Your "$itemTitle" has been $claimStatus',
      type: 'claim',
      data: {
        'itemTitle': itemTitle,
        'status': claimStatus,
        'screen': 'claims',
      },
    );
  }
  
  // Send emergency alert
  static Future<void> sendEmergencyNotification({
    required String targetUserId,
    required String alertTitle,
    required String alertMessage,
  }) async {
    await addNotification(
      userId: targetUserId,
      title: alertTitle,
      message: alertMessage,
      type: 'emergency',
      data: {
        'screen': 'emergency_alerts',
      },
    );
  }
  
  // Delete a notification
  static Future<void> deleteNotification(String notificationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
      print(' Notification deleted: $notificationId');
    } catch (e) {
      print(' Error deleting notification: $e');
    }
  }
  
  // Get unread notifications count
  static Stream<int> getUnreadCountStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(0);
    
    return _firestore
        .collection(_notificationsCollection)
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}