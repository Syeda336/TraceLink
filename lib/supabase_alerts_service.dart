// 📁 lib/supabase_service.dart
import 'dart:async'; // <--- ADD THIS
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracelink/notifications_service.dart'; // Import notification service
//import 'firebase_service.dart';


// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseAlertService {

  //NEW
  static StreamSubscription<List<Map<String, dynamic>>>? _alertsSubscription;
  // Method to fetch all rows from the 'Lost' table
  static Future<List<Map<String, dynamic>>> fetchAlerts() async {
    try {
      final response = await supabase
          .from('Alerts') //  Your table name
          .select() // Select all columns
          .order('created_at', ascending: false); // Order by most recent

      // The response is a List<Map<String, dynamic>>
      return response;
    } on PostgrestException catch (e) {
      // Handle Supabase/Postgres specific errors
      print('Supabase Error: ${e.message}');
      rethrow; // Propagate the error
    } catch (e) {
      // Handle any other errors (network, parsing, etc.)
      print('An unexpected error occurred: $e');
      rethrow;
    }
  }

  Future<int> getLostCount() async {
    final response = await supabase.from("Alerts").select();
    return response.length;
  }

  // --- END OF NEW FUNCTION ---

  //NEW METHODS FOR EMERGENCY NOTIFICATIONS
  // 2. Add startAlertsListener method
  static void startAlertsListener() {
    // Prevent starting multiple listeners
    if (_alertsSubscription != null) {
      print('Supabase alert listener is already running.');
      return;
    }
    
    print('Starting Supabase real-time emergency alerts listener...');
    
    // Create the Real-time stream. It listens for changes in the 'Alerts' table.
    final Stream<List<Map<String, dynamic>>> alertsStream = supabase
        .from('Alerts') // Your table name
        .stream(primaryKey: ['id']) // Assuming 'id' is the primary key
        .order('created_at', ascending: false)
        .limit(1); // Only monitor the newest item
    
    // Subscribe to the stream
    _alertsSubscription = alertsStream.listen((data) {
      if (data.isNotEmpty) {
        final newAlert = data.first;
        
        // --- PROFESSIONAL NOTIFICATION TRIGGER ---
        // Call the new wrapper in NotificationsService
        NotificationsService.showEmergencyNotificationPopUp(
          id: newAlert['id'].hashCode, // Use hash of ID for a unique notification ID
          title: '🚨 New Emergency Alert Issued',
          body: newAlert['title'] ?? 'New alert posted. See if you recognize it.',
        );
        print('New alert detected and pop-up notification sent: ${newAlert['title']}');
      }
    }, onError: (error) {
      print("Error in Supabase alerts stream: $error");
    });
  }

  // 3. Add stopAlertsListener method
  static void stopAlertsListener() {
    if (_alertsSubscription != null) {
      print('Stopping Supabase real-time alerts listener.');
      _alertsSubscription!.cancel();
      _alertsSubscription = null;
    }
  }
}




