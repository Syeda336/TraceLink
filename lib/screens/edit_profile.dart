// edit_profile.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:tracelink/firebase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize the Supabase client globally
final supabase = Supabase.instance.client;

// --- Theme Colors ---
const Color _primaryColor = Color(0xFF00B0FF);
const Color _darkTextColor = Color.fromARGB(255, 8, 46, 103);

// **********************************************
// ********** ACTUAL SUPABASE SERVICE IMPLEMENTATION **********
// **********************************************
// We will implement the Supabase logic inside a utility class or static functions.
class SupabaseService {
  // 1. UPLOAD IMAGE TO SUPABASE STORAGE
  static Future<String?> uploadProfileImage({
    required XFile imageFile,
    required String userId,
  }) async {
    try {
      // Determine the file extension
      final fileExtension = imageFile.path.split('.').last;
      // Define the storage path in the Supabase bucket 'ImagesOfItems'
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final path = 'ImagesOfItems/$fileName';

      // Read the image file bytes
      final fileBytes = await imageFile.readAsBytes();

      // Upload the file to Supabase Storage, using upsert (overwrite if exists)
      await supabase.storage
          .from('ImagesOfItems')
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Get the public URL for the uploaded file
      final String publicUrl = supabase.storage
          .from('ImagesOfItems')
          .getPublicUrl(path);

      return publicUrl;
    } on StorageException catch (e) {
      debugPrint('Supabase Storage Error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Supabase Upload Error: $e');
      return null;
    }
  }

  // 2. SAVE PROFILE DATA TO SUPABASE TABLE
  static Future<bool> saveEditedProfileToSupabase({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String studentId,
    required String department,
    required String campus,
    required String bio,
    required String userId,
    required String imageUrl,
  }) async {
    try {
      final Map<String, dynamic> dataToSave = {
        'user_name': fullName,
        'user_email': email,
        'phone_no': phoneNumber,
        'user_id': studentId,
        'department': department,
        'campus': campus,
        'bio': bio,
        'user_image': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Use upsert to either insert a new record or update an existing one based on 'user_id'
      await supabase.from('Edited_Profiles').upsert(dataToSave).select();

      return true;
    } catch (e) {
      debugPrint('Supabase DB Save Error: $e');
      return false;
    }
  }
}
// **********************************************
// **********************************************

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentIDController = TextEditingController();
  final _departmentController = TextEditingController();
  final _campusController = TextEditingController();
  final _bioController = TextEditingController();

  XFile? _profilePhoto;
  String? _currentProfileImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIDController.dispose();
    _departmentController.dispose();
    _campusController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    // Use FirebaseService for initial data load
    Map<String, dynamic>? userData = await FirebaseService.getUserData();
    if (userData != null) {
      setState(() {
        _fullNameController.text = userData['fullName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phoneNumber'] ?? '';
        _studentIDController.text = userData['studentId'] ?? 'STU000000';
        _departmentController.text = userData['department'] ?? '';
        _campusController.text = userData['campus'] ?? '';
        _bioController.text = userData['bio'] ?? '';
        _currentProfileImageUrl = userData['profileImageUrl'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _profilePhoto = image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo selected! Click Save to upload.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No photo selected.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  //********** PASSWORD CONFIRMATION FOR SECURITY ******************* */
  Future<String?> _askUserForPassword() async {
    final _passwordController = TextEditingController();

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Your Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For security reasons, please enter your current password to save changes.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
              // **** ADDED STYLE FOR DARK MODE ****
              style: const TextStyle(color: _darkTextColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(_passwordController.text.trim());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your password'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  //****** SAVE TO FIREBASE AND SUPABASE */
  void _saveAndClose() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please fill out all required fields correctly.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Ask for password confirmation
    String? currentPassword = await _askUserForPassword();
    if (currentPassword == null || currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Profile update cancelled. Password required.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );

    try {
      // ************ 1. Update profile in Firestore WITH password verification ************
      bool profileUpdated = await FirebaseService.updateUserProfileWithPassword(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        department: _departmentController.text.trim(),
        campus: _campusController.text.trim(),
        bio: _bioController.text.trim(),
        currentPassword: currentPassword,
      );

      if (!profileUpdated) {
        Navigator.of(context).pop(); // Hide loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '❌ Failed to update profile in Firebase. Please check your password and try again.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Successfully updated in Firebase, now proceed to Supabase (Dual Write)

      // Fetch necessary IDs/emails/studentId from Firebase data
      Map<String, dynamic>? userData = await FirebaseService.getUserData();
      final String userId = userData?['uid'] ?? 'unknown-user';
      final String userEmail = userData?['email'] ?? _emailController.text;
      final String studentId =
          userData?['studentId'] ?? _studentIDController.text;
      String? imageUrlToSave =
          _currentProfileImageUrl; // Use current/old URL by default

      // ************ 2. Supabase Image Upload ************
      if (_profilePhoto != null) {
        // *** REAL Supabase Upload Call ***
        String? newUrl = await SupabaseService.uploadProfileImage(
          imageFile: _profilePhoto!,
          userId: userId,
        );
        if (newUrl != null) {
          imageUrlToSave = newUrl;
          // IMPORTANT: If you want Firebase to also track the new image URL, update it here:
          // await FirebaseService.updateProfileImageUrl(newUrl);
        } else {
          // Notify of image upload failure to Supabase, but continue with data save
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ Image upload failed to Supabase Storage. Profile details saving...',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      // ************ 3. Save Data to Supabase Table "Edited_Profiles" ************
      // *** REAL Supabase DB Save Call ***
      bool profileSavedToSupabase =
          await SupabaseService.saveEditedProfileToSupabase(
            fullName: _fullNameController.text.trim(),
            email: userEmail,
            phoneNumber: _phoneController.text.trim(),
            studentId: studentId,
            department: _departmentController.text.trim(),
            campus: _campusController.text.trim(),
            bio: _bioController.text.trim(),
            userId: userId,
            imageUrl:
                imageUrlToSave ??
                '', // Save the URL (or an empty string if none)
          );

      Navigator.of(context).pop(); // Hide loading

      if (profileSavedToSupabase) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✅ Profile updated in Firebase and Supabase successfully!',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Update the local state with the new image URL if it changed
        if (imageUrlToSave != null) {
          setState(() {
            _currentProfileImageUrl = imageUrlToSave;
            _profilePhoto = null; // Clear local XFile after successful upload
          });
        }

        // Wait a bit then go back and refresh
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pop(true); // Go back with success result
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️ Profile updated in Firebase, but saving to Supabase "Edited_Profiles" table failed.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        // Still pop back since the primary Firebase update was successful
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pop(true);
        });
      }
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred during save: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _darkTextColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _darkTextColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveAndClose,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildProfilePhoto(),
              const SizedBox(height: 30),
              _buildPersonalInformation(),
              const SizedBox(height: 25),
              _buildPhoneNumber(),
              const SizedBox(height: 25),
              _buildUniversityInformation(),
              const SizedBox(height: 25),
              _buildBioSection(),
              const SizedBox(height: 40),
              _buildSaveChangesButton(),
              const SizedBox(height: 40),
              _buildProfileTips(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Widgets ----------------

  Widget _buildProfilePhoto() {
    Widget profileImageWidget;
    // 1. New image selected locally
    if (_profilePhoto != null) {
      if (kIsWeb) {
        profileImageWidget = FutureBuilder<Uint8List?>(
          future: _profilePhoto!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            }
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
        );
      } else {
        profileImageWidget = Image.file(
          File(_profilePhoto!.path),
          fit: BoxFit.cover,
        );
      }
      // 2. Existing image URL loaded
    } else if (_currentProfileImageUrl != null &&
        _currentProfileImageUrl!.isNotEmpty) {
      profileImageWidget = Image.network(
        _currentProfileImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsPlaceholder(),
      );
      // 3. Initials placeholder
    } else {
      profileImageWidget = _buildInitialsPlaceholder();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              gradient:
                  (_profilePhoto == null &&
                      (_currentProfileImageUrl == null ||
                          _currentProfileImageUrl!.isEmpty))
                  ? const LinearGradient(
                      colors: [_primaryColor, _darkTextColor],
                    )
                  : null,
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  profileImageWidget,

                  // Camera icon overlay
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54, // Dark overlay for visibility
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Profile Photo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Text(
          'Click the photo to upload a new one',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInitialsPlaceholder() {
    return Center(
      child: Text(
        _fullNameController.text.isNotEmpty &&
                _fullNameController.text.contains(' ')
            ? '${_fullNameController.text.split(' ').first.substring(0, 1)}${_fullNameController.text.split(' ').last.substring(0, 1)}'
            : _fullNameController.text.isNotEmpty
            ? _fullNameController.text.substring(0, 1)
            : 'U',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return _buildSectionCard(
      title: 'Personal Information',
      icon: Icons.person_outline,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(
            label: 'Full Name',
            controller: _fullNameController,
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          // 🔒 DISABLED EMAIL FIELD - Display only
          _buildDisplayOnlyField(
            label: 'Email Address',
            value: _emailController.text,
            icon: Icons.email_outlined,
            description: 'Email cannot be changed for security reasons',
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return _buildSectionCard(
      title: 'Phone Number',
      icon: Icons.phone_android_outlined,
      content: _buildEditableField(
        label: 'Phone Number',
        controller: _phoneController,
        icon: Icons.call_outlined,
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _buildUniversityInformation() {
    return _buildSectionCard(
      title: 'University Information',
      icon: Icons.school_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDisplayOnlyField(
            label: 'Student ID',
            value: _studentIDController.text,
            icon: Icons.credit_card_outlined,
            description: 'Student ID cannot be changed once verified',
          ),
          const SizedBox(height: 15),
          _buildEditableField(
            label: 'Department',
            controller: _departmentController,
            icon: Icons.book_outlined,
          ),
          const SizedBox(height: 15),
          _buildEditableField(
            label: 'Campus Location',
            controller: _campusController,
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return _buildSectionCard(
      title: 'Bio',
      icon: Icons.edit_note,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(
            label: 'Tell us about yourself (Max 150 characters)',
            controller: _bioController,
            hintText: 'Share your story with the community',
            maxLines: 4,
            validator: (value) {
              if (value != null && value.length > 150)
                return 'Bio must be 150 characters or less';
              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _bioController,
                builder: (context, value, child) {
                  return Text(
                    '${value.text.length}/150',
                    style: TextStyle(
                      fontSize: 12,
                      color: value.text.length > 150 ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [_primaryColor, _darkTextColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: TextButton(
        onPressed: _saveAndClose,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 8),
            Text(
              'Save Changes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTips() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: _primaryColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.security, color: _primaryColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Notice',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For your security, we require password confirmation to save profile changes.',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email and Student ID cannot be changed to maintain account integrity.',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    IconData? icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: _primaryColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, color: _primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,

          // This forces the typed text to be your dark color
          style: const TextStyle(color: _darkTextColor),

          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // 🔒 Display-only field for email and student ID
  Widget _buildDisplayOnlyField({
    required String label,
    required String value,
    IconData? icon,
    String? description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(icon, color: Colors.grey),
                ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
              ),
              const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
