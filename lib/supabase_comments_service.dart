// supabase_comments_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

// Ensure your Supabase client is initialized and accessible.
final supabase = Supabase.instance.client;

class SupabaseCommentsService {
  static const String _commentsTable = 'post_comments';

  /// Saves a new comment, manually calculating the next ID.
  /// NOTE: This approach is NOT RECOMMENDED due to potential race conditions
  /// and should only be used if the database column 'id' is NOT auto-incrementing.
  static Future<void> saveComment({
    required String userId,
    required String userName,
    required String userEmail,
    required String itemName,
    required String commentText,
  }) async {
    try {
      // 1. Fetch the current maximum ID to determine the next ID value
      final response = await supabase
          .from(_commentsTable)
          .select('id')
          .order('id', ascending: false)
          .limit(1);

      // Determine the next ID: 1 if table is empty, or max ID + 1
      final int nextId = response.isEmpty
          ? 1
          : (response.first['id'] as int? ?? 0) + 1;

      // 2. Construct the data map including the manually generated ID
      final Map<String, dynamic> commentData = {
        'id': nextId, // <--- MANUAL ID ADDED
        'User ID': userId,
        'User Name': userName,
        'User Email': userEmail,
        'Item Name': itemName,
        'comment': commentText,
      };

      // 3. Insert the data
      await supabase.from(_commentsTable).insert(commentData);
      print('✅ Successfully saved comment (ID: $nextId) to Supabase.');
    } on PostgrestException catch (e) {
      print('❌ Supabase Postgrest Error during comment save: ${e.message}');
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      print('❌ An unexpected error occurred during comment save: $e');
      throw Exception('Failed to save comment: $e');
    }
  }

  // --- NEW FUNCTION ---

  /// Fetches all comments from the 'post_comments' table, ordered by ID.
  /// Returns a list of maps, where each map is a row/comment.
  static Future<List<Map<String, dynamic>>> fetchComments(
    String itemName,
  ) async {
    try {
      // Select all columns ('*') from the table and order by the 'id' column.
      final List<Map<String, dynamic>> comments = await supabase
          .from(_commentsTable)
          .select('*')
          .order('id', ascending: true);

      print(
        '✅ Successfully fetched ${comments.length} comments from Supabase.',
      );
      return comments;
    } on PostgrestException catch (e) {
      print('❌ Supabase Postgrest Error during comment fetch: ${e.message}');
      throw Exception('Database Error: Failed to fetch comments: ${e.message}');
    } catch (e) {
      print('❌ An unexpected error occurred during comment fetch: $e');
      throw Exception('Failed to fetch comments: $e');
    }
  }
}
