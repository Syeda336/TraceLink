import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/splash.dart';
import 'theme_provider.dart';
import 'firebase_service.dart';
import 'firebase_options.dart';
import 'screens/alerts.dart';
import 'screens/chat.dart';
import 'screens/warning_admin.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

// --- 1. BACKGROUND HANDLER (MUST BE OUTSIDE ANY CLASS) ---
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // REPLACE these placeholders with your actual project URL and Anon Key
    url: 'https://tzusprdkforqtgfptqjy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6dXNwcmRrZm9ycXRnZnB0cWp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMjkwMTIsImV4cCI6MjA3OTcwNTAxMn0.qiuc29ki4oJU5GjwtciDjtd-E9oC9oC9NDVGY_aIGuA',
  );

  // --- 2. REGISTER BACKGROUND HANDLER BEFORE APP STARTS ---
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Firebase & Notification Channels
  await FirebaseService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const FigmaLoginLab(),
    ),
  );
}

class FigmaLoginLab extends StatefulWidget {
  const FigmaLoginLab({super.key});

  @override
  State<FigmaLoginLab> createState() => _FigmaLoginLabState();
}

class _FigmaLoginLabState extends State<FigmaLoginLab>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 1. Set user to ONLINE when app starts
    FirebaseService.updateUserStatus(true);

    // 2. Setup notification handling
    _setupNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 3. App lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseService.updateUserStatus(true);
    } else {
      FirebaseService.updateUserStatus(false);
    }
  }

  void _setupNotifications() {
    // Setup foreground message listeners
    FirebaseService.setupForegroundMessages();

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print(' App opened from notification: ${message.data}');
        _handleNotificationNavigation(message);
      }
    });

    // Handle when app is in background and opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);

    print(' Notification system fully initialized');
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;

    print(' Handling notification navigation: ${data['type']}');

    // Use a slight delay to ensure context is available
    Future.delayed(const Duration(milliseconds: 500), () {
      if (data['type'] == 'emergency') {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EmergencyAlerts()),
        );
      } else if (data['type'] == 'chat') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: data['senderName'] ?? 'User',
              chatPartnerInitials: data['senderInitials'] ?? 'U',
              isOnline: true,
              avatarColor: Colors.blue,
              receiverId: data['senderId'] ?? data['uid'] ?? data['id'] ?? '',
            ),
          ),
        );
      } else if (data['type'] == 'warning') {
        // ✅ FIX: Extract reportId from data and ensure it is an integer.
        // We assume the key in the payload is 'reportId' and default to 0 if missing/invalid.
        final int reportId =
            int.tryParse(data['reportId']?.toString() ?? '0') ?? 0;

        if (reportId > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WarningScreen(reportId: reportId),
            ),
          );
        } else {
          // Handle case where reportId is missing or invalid in the payload
          print(
            'Navigation Error: Warning notification data missing a valid reportId.',
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TraceLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const WelcomeScreen(),
    );
  }
}
