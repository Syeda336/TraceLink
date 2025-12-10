// 📁 lib/supabase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseFoundService {
  // Method to fetch all rows from the 'Found' table
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

  Future<int> getUserFoundCount(String studentId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Found")
        .where("studentId", isEqualTo: studentId)
        .get();

    return querySnapshot.docs.length;
  }

  // --- NEW FUNCTION TO DELETE DATA ---

  /// 🗑️ Deletes a specific row from the 'Found' table by its ID.
  ///
  /// Assumes the primary key column in the 'Found' table is named 'id'.
  static Future<void> deleteFoundItem(int itemId) async {
    try {
      // Use delete() to initiate the operation, and eq() to apply a filter.
      await supabase
          .from('Found')
          .delete()
          // Filter: Delete where the column 'id' equals the provided itemId.
          .eq('id', itemId);

      print('Successfully deleted found item with ID: $itemId');
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

  static Future<void> updateComments({
    required int itemId,
    required List<Map<String, dynamic>> comments,
  }) async {
    await supabase
        .from('Found')
        .update({'Comments': comments})
        .eq('id', itemId);
  }

  // --- END OF NEW FUNCTION ---
}
