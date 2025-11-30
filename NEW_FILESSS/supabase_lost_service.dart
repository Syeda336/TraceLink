// 📁 lib/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseLostService {
  // Method to fetch all rows from the 'Lost' table
  static Future<List<Map<String, dynamic>>> fetchLostItems() async {
    try {
      final response = await supabase
          .from('Lost') // 🌟 Your table name
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

  Future<int> getLostCount() async {
    final response = await supabase.from("Lost").select();
    return response.length;
  }

  // --- NEW FUNCTION TO DELETE DATA ---

  ///
  /// Assumes the primary key column in the 'Lost' table is named 'id'.
  static Future<void> deleteLostItem(int reportId) async {
    try {
      // 1. Specify the table
      await supabase
          .from('Lost')
          // 2. Specify the action (delete)
          .delete()
          // 3. Specify the filter (WHERE condition: delete where 'id' equals itemId)
          .eq('id', reportId);

      print('Successfully deleted lost item with ID: $reportId');
    } on PostgrestException catch (e) {
      // Handle Supabase/Postgres specific errors
      print('Supabase Delete Error: ${e.message}');
      rethrow; // Propagate the error
    } catch (e) {
      // Handle any other errors
      print('An unexpected error occurred during deletion: $e');
      rethrow;
    }
  }

  // --- END OF NEW FUNCTION ---
}
