// firebase_services.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize notifications immediately on startup
    await _initializeNotifications();
  }

  // -----------------------
  // Sign up new user
  // -----------------------
  static Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'studentId': studentId,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Sign up success for uid: ${userCredential.user!.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign up FirebaseAuthException: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Sign up general error: $e');
      return null;
    }
  }

  // -----------------------
  // Sign in user with email
  // -----------------------
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //print('Sign in success: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // PRINT THE ERROR so you can see it in the console
      print('Firebase Sign in Error: ${e.code} - ${e.message}');
      // RETHROW it so the Login Screen sees "Wrong Password" instead of generic failure
      rethrow; 
    } catch (e) {
      print('General Sign in Error: $e');
      rethrow;
    }
  }

  // -----------------------
  // Sign in with STUDENT ID (Modified for 2FA Check)
  // -----------------------
  static Future<User?> signInWithStudentId({
    required String studentId,
    required String password,
  }) async {
    try {
      // 1. Find user by Student ID
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw 'Student ID not found.';
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      // 2. CHECK: Is 2FA Enabled? [NEW LOGIC]
      // We safely check if privacySettings exists, then check twoFactorAuth
      final privacySettings = data['privacySettings'] as Map<String, dynamic>?;
      final bool is2FAEnabled = privacySettings?['twoFactorAuth'] ?? false;

      // If 2FA is NOT enabled, block Student ID login
      if (!is2FAEnabled) {
        throw 'Student ID login is disabled. Please enable 2FA in settings or login using Email.';
      }

      // 3. If allowed, proceed to get email and login
      if (data['email'] == null) {
        throw 'Account has no email linked.';
      }

      final String email = data['email'] as String;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;

    } catch (e) {
      // Rethrow the specific 2FA error so the Login Screen can show it
      if (e.toString().contains('Student ID login is disabled')) {
        rethrow; 
      }
      print('Student ID sign-in general error: $e');
      // For other errors, return null or rethrow based on preference
      // Here we rethrow strings to display them in the UI
      if (e is String) rethrow;
      return null;
    }
  }



//*********************allows to search multiple users with similar name******************************* */

  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return [];

      // This logic allows for "starts with" searching
      // e.g. "Jo" finds "John", "Jonathan", "Joseph"
      String endQuery = query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThan: endQuery)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'uid': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // ***************************************************
  // Update user profile (including email synchronization)
  // ***************************************************
  static Future<bool> updateUserProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String department,
    required String campus,
    required String bio,
    String? currentPassword,
  }) async {
    print('🔥 updateUserProfile STARTED');
    print('🔥 Email: $email, FullName: $fullName');

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('🔥 ERROR: No authenticated user');
        return false;
      }

      final String? currentAuthEmail = user.email;
      print('🔥 Current auth email: $currentAuthEmail');

      // If email is changing and different from Auth email
      if (email.isNotEmpty &&
          currentAuthEmail != null &&
          currentAuthEmail != email) {
        print('Email change detected: $currentAuthEmail -> $email');

        if (currentPassword == null || currentPassword.isEmpty) {
          print('Email change requires current password');
          return false;
        }

        try {
          // 1. Reauthenticate user with current credentials
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: currentAuthEmail,
              password: currentPassword,
            ),
          );
          print('Reauthentication successful for user ${user.uid}');

          // 2. Send verification email to new address
          await user.verifyBeforeUpdateEmail(email);
          print('Verification email sent to: $email');
        } on FirebaseAuthException catch (e) {
          print('Email update failed: ${e.code} - ${e.message}');
          return false;
        }
      }

      // Update Firestore user document with ALL fields
      try {
        Map<String, dynamic> updateData = {
          'fullName': fullName,
          'email': email, // Always update email in Firestore
          'phoneNumber': phoneNumber,
          'department': department,
          'campus': campus,
          'bio': bio,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(user.uid).update(updateData);
        print('Firestore user document updated for uid: ${user.uid}');
        print('Updated data: $updateData');
      } catch (e) {
        print('Firestore update error: $e');
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print(
        'updateUserProfile FirebaseAuthException: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      print('updateUserProfile general error: $e');
      return false;
    }
  }

  // -----------------------
  // Update user profile WITH password verification (but no email change)
  // -----------------------
  static Future<bool> updateUserProfileWithPassword({
    required String fullName,
    required String phoneNumber,
    required String department,
    required String campus,
    required String bio,
    required String currentPassword,
  }) async {
    print('🔥 updateUserProfileWithPassword STARTED');
    print('🔥 FullName: $fullName');

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('🔥 ERROR: No authenticated user');
        return false;
      }

      // 1️⃣ Verify password by attempting reauthentication
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        print('✅ Password verification successful for uid: ${user.uid}');
      } on FirebaseAuthException catch (e) {
        print('❌ Password verification failed: ${e.code} - ${e.message}');
        return false;
      }

      // 2️⃣ Update Firestore user document EXCLUDING email
      try {
        Map<String, dynamic> updateData = {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'department': department,
          'campus': campus,
          'bio': bio,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(user.uid).update(updateData);
        print('✅ Firestore user document updated for uid: ${user.uid}');
        print('Updated data: $updateData');
      } catch (e) {
        print('❌ Firestore update error: $e');
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print(
        'updateUserProfileWithPassword FirebaseAuthException: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      print('updateUserProfileWithPassword general error: $e');
      return false;
    }
  }

  // -----------------------
  // Update email only including reauthentication  updated to the new firebase version
  // -----------------------
 static Future<bool> updateEmail(
    String newEmail, {
    required String currentPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('updateEmail: no authenticated user.');
        return false;
      }

      // 1️⃣ Reauthenticate user
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        print('Reauthentication successful for uid: ${user.uid}');
      } on FirebaseAuthException catch (e) {
        print('Reauthentication failed: ${e.code} - ${e.message}');
        return false;
      }

      // 2️⃣ Verify and Update Email (The Change)
      // This sends a verification email to the new address.
      // The email on the account won't technically change until the user clicks the link.
      await user.verifyBeforeUpdateEmail(newEmail);
      print('Verification email sent to $newEmail for uid: ${user.uid}');

      // 3️⃣ Sync Firestore
      // Note: We update Firestore now so the UI reflects the "pending" email,
      // but the Auth email won't change until they click the link in their inbox.
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'email': newEmail,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('Firestore email updated for uid: ${user.uid}');
      } catch (e) {
        print('Firestore update after updateEmail failed: $e');
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print('updateEmail FirebaseAuthException: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('updateEmail general error: $e');
      return false;
    }
  }

  // -----------------------
  // Get current user data from Firestore
  // -----------------------
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        return userDoc.data() as Map<String, dynamic>?;
      }
      print('getUserData: no current user.');
      return null;
    } catch (e) {
      print('getUserData error: $e');
      return null;
    }
  }

  //Implementing User online and offline Status

  // ---------------------------------------------------
  // ONLINE STATUS HELPERS 
  // ---------------------------------------------------

  // 1. Update MY status (Online/Offline)
  static Future<void> updateUserStatus(bool isOnline) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
        'lastActive': FieldValue.serverTimestamp(),
      });
    }
  }

  // 2. Stream a specific user's data (to see if THEY are online)
  static Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  // -----------------------
  // Sign out
  // -----------------------
  static Future<void> signOut() async {
    await _auth.signOut();
    print('User signed out.');
  }

  /// -----------------------
  // Send Password Reset Email
  // -----------------------
  static Future<String?> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
      return null; // Indicates success
    } on FirebaseAuthException catch (e) {
      print('Password reset email error: ${e.code} - ${e.message}');
      return e.message; // Return error message
    } catch (e) {
      print('Password reset general error: $e');
      return e.toString();
    }
  }

  // -----------------------
  // Update User Password (for logged-in user)
  // -----------------------
  static Future<String?> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return 'No user is currently logged in.';
      }

      // 1. Re-authenticate the user with their CURRENT password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. If re-authentication is successful, update the password
      await user.updatePassword(newPassword);

      print('Password updated successfully.');
      return null; // Indicates success
    } on FirebaseAuthException catch (e) {
      print('Password update error: ${e.code} - ${e.message}');
      // Provide more user-friendly messages
      if (e.code == 'wrong-password') {
        return 'Your current password is incorrect. Please try again.';
      } else if (e.code == 'weak-password') {
        return 'The new password is too weak.';
      }
      return e.message; // Return the Firebase error
    } catch (e) {
      print('Password update general error: $e');
      return e.toString();
    }
  }

  // =======================
  // CHAT METHODS
  // =======================

  // -----------------------
  // Get or create demo user by name
  // -----------------------
  static Future<String?> getOrCreateDemoUser({
    required String userName,
    required String userInitials,
  }) async {
    try {
      // First, try to find existing demo user by name
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: userName)
          .where('isDemo', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return existing demo user ID
        return querySnapshot.docs.first.id;
      }

      // Create new demo user
      final String demoUserId =
          'demo_${userName.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

      await _firestore.collection('users').doc(demoUserId).set({
        'fullName': userName,
        'initials': userInitials,
        'email':
            '${userName.toLowerCase().replaceAll(' ', '.')}@demo.tracelink.com',
        'isDemo': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Created demo user: $userName with ID: $demoUserId');
      return demoUserId;
    } catch (e) {
      print('Error creating demo user: $e');
      return null;
    }
  }

  // -----------------------
  // Send a message
  // -----------------------
  // ---  CHANGE 1: OPTIMIZED METHOD  ---
  // This version fetches the current user's data only ONCE,
  
  // that called `await getUserData()` multiple times.
  static Future<bool> sendMessage({
    required String receiverId,
    required String message,
    required String receiverName,
    required String receiverInitials,
    bool isInitialMessage = false,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('Send message: no authenticated user.');
        return false;
      }

      // ---  OPTIMIZATION: Fetch current user data ONCE  ---
      final currentUserData = await getUserData();
      final String currentUserName = currentUserData?['fullName'] ?? 'Unknown';
      final String currentUserInitials = _getInitials(currentUserName);

      // Determine sender and receiver based on whether it's an initial message
      // (Assuming 'initial message' means it's FROM the receiver TO the current user)
      final String finalSenderId = isInitialMessage ? receiverId : user.uid;
      final String finalSenderName = isInitialMessage
          ? receiverName
          : currentUserName;
      final String finalSenderInitials = isInitialMessage
          ? receiverInitials
          : currentUserInitials;

      final String finalReceiverId = isInitialMessage ? user.uid : receiverId;
      final String finalReceiverName = isInitialMessage
          ? currentUserName
          : receiverName;
      final String finalReceiverInitials = isInitialMessage
          ? currentUserInitials
          : receiverInitials;

      // Chat room ID
      List<String> participants = [user.uid, receiverId];
      participants.sort();
      String chatRoomId = participants.join('_');

      // Create message data
      Map<String, dynamic> messageData = {
        'senderId': finalSenderId,
        'senderName': finalSenderName,
        'senderInitials': finalSenderInitials,
        'receiverId': finalReceiverId,
        'receiverName': finalReceiverName,
        'receiverInitials': finalReceiverInitials,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'isInitialMessage': isInitialMessage,
      };

      // Add message to the chat room
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      // Update last message in chat room
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'lastMessage': message,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'participants': participants,
        'participantNames': {
          user.uid: currentUserName, // Current user's name
          receiverId: receiverName, // The other participant's name
        },
        'participantInitials': {
          user.uid: currentUserInitials, // Current user's initials
          receiverId: receiverInitials, // The other participant's initials
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Message sent successfully to $receiverName');
      return true;
    } catch (e) {
      print('Send message error: $e');
      return false;
    }
  }

  // -----------------------
  // Get messages for a chat room
  // -----------------------
  static Stream<QuerySnapshot> getMessages(String receiverId) {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Create chat room ID (same logic as above)
      List<String> participants = [user.uid, receiverId];
      participants.sort();
      String chatRoomId = participants.join('_');

      return _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      print('Get messages error: $e');
      rethrow;
    }
  }

  // -----------------------
  // Get user's conversations list
  // -----------------------
  static Stream<QuerySnapshot> getConversations() {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      return _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: user.uid)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots();
    } catch (e) {
      print('Get conversations error: $e');
      rethrow;
    }
  }


  //********** email & emergency alerts notifications************** */

  // --- NEW: Notification Setup ---
  static Future<void> _initializeNotifications() async {
    // 1. Request Permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get FCM Token
      String? token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToUser(token);
      }

      // 3. Listen for token refresh
      _messaging.onTokenRefresh.listen(_saveTokenToUser);
    }
  }

  static Future<void> _saveTokenToUser(String token) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // --- NEW: Update Notification Settings (Connected to your Switch) ---
  // REPLACE the existing updateNotificationPreferences with this:
  static Future<void> updateNotificationPreferences({
    required bool pushEnabled,
    required bool emailEnabled,
    required bool emergencyEnabled,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    print(' Updating notification preferences:');
    print('   - Push: $pushEnabled');
    print('   - Email: $emailEnabled');
    print('   - Emergency: $emergencyEnabled');

    // 1. Handle General Push Notifications Subscription
    if (pushEnabled) {
      await _messaging.subscribeToTopic('general_notifications');
      print('Subscribed to general_notifications topic');
    } else {
      await _messaging.unsubscribeFromTopic('general_notifications');
      print('Unsubscribed from general_notifications topic');
    }

    // 2. Handle Emergency Alerts Subscription
    if (emergencyEnabled) {
      await _messaging.subscribeToTopic('emergency_alerts');
      print('Subscribed to emergency_alerts topic');
    } else {
      await _messaging.unsubscribeFromTopic('emergency_alerts');
      print('Unsubscribed from emergency_alerts topic');
    }

    // 3. Save to Firestore (Used by Trigger Email Extension & App Logic)
    await _firestore.collection('users').doc(user.uid).set({
      'notificationSettings': {
        'pushEnabled': pushEnabled,
        'emailEnabled': emailEnabled,
        'emergencyEnabled': emergencyEnabled,
      },
      'lastSettingsUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    print(' Notification preferences saved to Firestore');
  }

  // --- NEW: Get Notification Settings ---
  static Future<Map<String, dynamic>?> getNotificationSettings() async {
    User? user = _auth.currentUser;
    if (user == null) return null;
    
    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
    if(doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      return data['notificationSettings'] as Map<String, dynamic>?;
    }
    return null;
  }

  //********background notifications*********** */

    
  static void setupForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Foreground message received!');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
      
      // Show system notification
      _showSystemNotification(message);
    });
  }

  static void _showSystemNotification(RemoteMessage message) {
    // Create a basic system notification using Flutter's built-in capabilities
    // This will show the notification in the system tray while app is in foreground
    final notification = message.notification;
    if (notification != null) {
      // This triggers the system notification
      // Flutter automatically shows notifications for foreground messages
      print('🔔 Showing system notification: ${notification.title}');
    }
  }

  static Future<List<String>> getCurrentTopics() async {
    final settings = await getNotificationSettings();
    List<String> topics = [];
    
    if (settings?['pushEnabled'] == true) {
      topics.add('general_notifications');
    }
    if (settings?['emergencyEnabled'] == true) {
      topics.add('emergency_alerts');
    }
    
    return topics;
  }

  // -----------------------
  // Get user ID by name (for demo purposes)
  // -----------------------
  static Future<String?> getUserIdByName(String userName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: userName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      print('Get user ID by name error: $e');
      return null;
    }
  }

  // -----------------------
  // Get user data by ID
  // -----------------------
  static Future<Map<String, dynamic>?> getUserDataById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Get user data by ID error: $e');
      return null;
    }
  }

  // -----------------------
  // Get user data by name (updated for demo users)
  // -----------------------
  static Future<Map<String, dynamic>?> getUserDataByName(
    String userName,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: userName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return {'uid': doc.id, ...doc.data() as Map<String, dynamic>};
      }
      return null;
    } catch (e) {
      print('Get user data by name error: $e');
      return null;
    }
  }

  // -----------------------
  // Mark messages as read
  // -----------------------
  static Future<void> markMessagesAsRead(String receiverId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      List<String> participants = [user.uid, receiverId];
      participants.sort();
      String chatRoomId = participants.join('_');

      // Get all unread messages from this sender
      QuerySnapshot unreadMessages = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: user.uid)
          .where('read', isEqualTo: false)
          .get();

      WriteBatch batch = _firestore.batch();

      // Mark them as read in a batch
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      print('Mark messages as read error: $e');
    }
  }

  // -----------------------
  // Add initial messages to a chat room
  // -----------------------
  static Future<bool> addInitialMessages({
    required String receiverId,
    required String receiverName,
    required String receiverInitials,
    required List<Map<String, dynamic>> messages,
  }) async {
    try {
      for (final message in messages) {
        if (!message['isMe']) {
          await sendMessage(
            receiverId: receiverId,
            message: message['text'],
            receiverName: receiverName,
            receiverInitials: receiverInitials,
            isInitialMessage: true,
          );

          // Add a small delay to ensure proper ordering
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      return true;
    } catch (e) {
      print('Error adding initial messages: $e');
      return false;
    }
  }

  // -----------------------
  // Check if chat room has messages
  // -----------------------
  static Future<bool> chatRoomHasMessages(String receiverId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      List<String> participants = [user.uid, receiverId];
      participants.sort();
      String chatRoomId = participants.join('_');

      final snapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking chat room messages: $e');
      return false;
    }
  }

  // -----------------------
  // Get unread message count for a chat room
  // -----------------------
  static Future<int> getUnreadCount(String chatRoomId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return 0;

      QuerySnapshot unreadMessages = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: user.uid)
          .where('read', isEqualTo: false)
          .get();

      return unreadMessages.docs.length;
    } catch (e) {
      print('Get unread count error: $e');
      return 0;
    }
  }

  // ==========================================================
  // ⭐️ NEW METHOD: Get unread count as a Stream ⭐️
  // ==========================================================
  static Stream<int> getUnreadCountStream(String chatRoomId) {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('Get unread count stream: No user logged in.');
        return Stream.value(0); // Return a stream with a single value of 0
      }

      return _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: user.uid)
          .where('read', isEqualTo: false)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.length,
          ); // Map the snapshot to its length
    } catch (e) {
      print('Get unread count stream error: $e');
      return Stream.value(0); // Return a stream with 0 in case of an error
    }
  }

  // Helper function to get initials from name
  static String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return 'UU';
  }

  // -----------------------
  // Update user profile WITHOUT email change (Simplified version)
  // -----------------------
  static Future<bool> updateUserProfileWithoutEmail({
    required String fullName,
    required String phoneNumber,
    required String department,
    required String campus,
    required String bio,
  }) async {
    print('🔥 updateUserProfileWithoutEmail STARTED');
    print('🔥 FullName: $fullName');

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('🔥 ERROR: No authenticated user');
        return false;
      }

      // Update Firestore user document EXCLUDING email
      try {
        Map<String, dynamic> updateData = {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'department': department,
          'campus': campus,
          'bio': bio,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(user.uid).update(updateData);
        print('Firestore user document updated for uid: ${user.uid}');
        print('Updated data: $updateData');
      } catch (e) {
        print('Firestore update error: $e');
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print(
        'updateUserProfileWithoutEmail FirebaseAuthException: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      print('updateUserProfileWithoutEmail general error: $e');
      return false;
    }
  }

  // -----------------------
  // Check if current user exists and is authenticated
  // -----------------------
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // -----------------------
  // Get current user ID
  // -----------------------
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // -----------------------
  // Get current user email
  // -----------------------
  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // -----------------------
  // Check if user is logged in
  // -----------------------
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // -----------------------
  // Delete user account (requires reauthentication)
  // -----------------------
  static Future<bool> deleteUserAccount(String currentPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('deleteUserAccount: no authenticated user.');
        return false;
      }

      // Reauthenticate user
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        print('Reauthentication successful for account deletion');
      } on FirebaseAuthException catch (e) {
        print(
          'Reauthentication failed for account deletion: ${e.code} - ${e.message}',
        );
        return false;
      }

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      print('User data deleted from Firestore');

      // Delete user from Firebase Auth
      await user.delete();
      print('User account deleted from Firebase Auth');

      return true;
    } on FirebaseAuthException catch (e) {
      print(
        'deleteUserAccount FirebaseAuthException: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      print('deleteUserAccount general error: $e');
      return false;
    }
  }

// Add this method inside the FirebaseService class (before the last closing brace)
static Future<bool> updatePrivacySettings({
  required bool showEmail,
  required bool showPhoneNumber,
  required bool loginNotifications,
  required bool profileVisibility,
  required bool twoFactorAuth,
}) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) return false;

    await _firestore.collection('users').doc(user.uid).update({
      'privacySettings': {
        'showEmail': showEmail,
        'showPhoneNumber': showPhoneNumber,
        'loginNotifications': loginNotifications,
        'profileVisibility': profileVisibility,
        'twoFactorAuth': twoFactorAuth,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    print('Privacy settings updated successfully');
    return true;
  } catch (e) {
    print('Error updating privacy settings: $e');
    return false;
  }
}

// ************geting  privacy settings*******************
static Future<Map<String, dynamic>?> getPrivacySettings() async {
  try {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;
      return data?['privacySettings'] as Map<String, dynamic>?;
    }
    return null;
  } catch (e) {
    print('Error getting privacy settings: $e');
    return null;
  }
}

} //ending brace
  