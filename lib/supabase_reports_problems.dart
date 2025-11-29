// File: supabase_reports_problems.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async'; // Ensure this is imported for Future/async

// NOTE: You must ensure Supabase.instance.client is initialized in your main application (e.g., main.dart).

class SupabaseReportsService {
  // Access the Supabase client instance
  static final _supabase = Supabase.instance.client;
  static const String _tableName = 'ReportProblems';

  /// Fetches all reports from the ReportProblems table.
  /// Returns a list of maps (JSON objects) representing the rows.
  static Future<List<Map<String, dynamic>>> fetchReports() async {
    try {
      // Select all columns and order by date_reported descending (newest first)
      final data = await _supabase
          .from(_tableName)
          .select('*')
          .order('date_reported', ascending: false);

      // Supabase returns a List<Map<String, dynamic>>
      return data;
    } catch (e) {
      // Log the error and re-throw for the UI to handle
      debugPrint('Error fetching reports from $_tableName: $e');
      rethrow;
    }
  }

  /// Updates the status of a specific report.
  static Future<void> updateReportStatus(
    String reportId,
    String newStatus,
  ) async {
    try {
      await _supabase
          .from(_tableName)
          // The update payload: set the 'status' column
          .update({'status': newStatus})
          // The condition: where 'report_id' matches the provided ID
          .eq('report_id', reportId);
    } catch (e) {
      debugPrint('Error updating report status for ID $reportId: $e');
      rethrow;
    }
  }

  /// Deletes a specific report using its primary key.
  static Future<void> deleteReport(String reportId) async {
    try {
      await _supabase.from(_tableName).delete().eq('report_id', reportId);
    } catch (e) {
      debugPrint('Error deleting report for ID $reportId: $e');
      rethrow;
    }
  }
}
