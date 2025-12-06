// 📁 lib/supabase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseClaimService {
  // Method to fetch all rows from the 'claimed_items' table
  static Future<List<Map<String, dynamic>>> fetchClaimedItems() async {
    try {
      final response = await supabase
          .from('claimed_items') // 🌟 Your table name
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

  Future<int> getClaimedCount() async {
    final response = await supabase.from("claimed_items").select();
    return response.length;
  }

  Future<int> getUserClaimCount(String studentId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("claimed_items")
        .where("studentId", isEqualTo: studentId)
        .get();

    return querySnapshot.docs.length;
  }

  ///
  /// Assumes the primary key column in the table is named 'id'.
  static Future<void> deleteClaimedItem(int itemId) async {
    try {
      // Use delete() to initiate the operation, and eq() to apply a filter.
      await supabase
          .from('claimed_items')
          .delete()
          // Filter: Delete where the column 'id' equals the provided itemId.
          .eq('id', itemId);

      print('Successfully deleted claimed item with ID: $itemId');
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
