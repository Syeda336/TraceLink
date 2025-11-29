// 📁 lib/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseFoundService {
  // Method to fetch all rows from the 'Lost' table
  static Future<List<Map<String, dynamic>>> fetchFoundItems() async {
    try {
      final response = await supabase
          .from('Found') // 🌟 Your table name
          .select() // Select all columns
          .order('Date Lost', ascending: false); // Order by most recent

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

  Future<int> getFoundCount() async {
    final response = await supabase.from("Found").select();
    return response.length;
  }
}
