// 📁 lib/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseAlertService {
  // Method to fetch all rows from the 'Lost' table
  static Future<List<Map<String, dynamic>>> fetchAlerts() async {
    try {
      final response = await supabase
          .from('Alerts') // 🌟 Your table name
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
}
