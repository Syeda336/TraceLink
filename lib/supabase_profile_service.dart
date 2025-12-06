// supabase_profile_service.dart (Conceptual Implementation)

import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure you have this import

class SupabaseProfileService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Fetches the 'user_image' URL from the 'Edited_Profiles' table
  static Future<String?> getProfileImage(String studentId) async {
    try {
      final response = await _supabase
          .from('Edited_Profiles') // Your Supabase table name
          .select('user_image') // The column containing the image URL
          .eq('user_id', studentId) // Filter by the user's ID
          .single(); // Expect a single row

      if (response.isNotEmpty) {
        // Return the image URL (which should be a public link to the image)
        return response['user_image'] as String?;
      }
      return null;
    } catch (e) {
      // Log error or handle gracefully
      print('Error fetching profile image: $e');
      return null;
    }
  }
}
