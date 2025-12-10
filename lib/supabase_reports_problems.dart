// 📁 lib/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

// Global accessor for Supabase Client (assuming it's initialized in main)
final supabase = Supabase.instance.client;

class SupabaseReportService {
  // Method to fetch all rows from the 'ReportProblems' table
  static Future<List<Map<String, dynamic>>> fetchReports() async {
    try {
      final response = await supabase
          .from('ReportProblems') // 🌟 Your table name
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

  Future<int> getReports() async {
    final response = await supabase.from("ReportProblems").select();
    return response.length;
  }

  // --- START OF NEW FUNCTION ---

  /// 🗑️ Deletes a specific row from the 'ReportProblems' table by its ID.
  ///
  /// The ID is assumed to be the unique primary key of the row.
  static Future<void> deleteReport(int reportId) async {
    try {
      // Use delete() and then eq() to specify the condition for deletion.
      // Assuming the primary key column is named 'id'.
      await supabase.from('ReportProblems').delete().eq('id', reportId);

      print('Successfully deleted report with ID: $reportId');
    } on PostgrestException catch (e) {
      print('Supabase Delete Error: ${e.message}');
      rethrow;
    } catch (e) {
      print('An unexpected error occurred during deletion: $e');
      rethrow;
    }
  }
  //RESOLVE REPORT
  
  // --- ADD THIS NEW METHOD ---
  /// 🔄 Updates the status of a specific report in the 'ReportProblems' table.
  ///
  /// Assumes the unique identifier column in the database is 'id'.
  static Future<void> updateReportStatus(
      int reportId, String newStatus) async {
    try {
      await supabase
          .from('ReportProblems') // Targets the ReportProblems table
          .update({'status': newStatus}) // Sets the 'status' column
          .eq('id', reportId); // Finds the row by the report's ID

      print('Successfully updated report $reportId status to $newStatus');
    } on PostgrestException catch (e) {
      print('Supabase Status Update Error: ${e.message}');
      rethrow;
    } catch (e) {
      print('An unexpected error occurred during status update: $e');
      rethrow;
    }
  }
  // --------------------------
}
  // --- END OF NEW FUNCTION ---

