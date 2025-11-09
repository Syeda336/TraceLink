import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Required for File on mobile/desktop
import 'package:flutter/foundation.dart'
    show kIsWeb, Uint8List; // Required for kIsWeb and Uint8List

// --- Theme Colors ---
const Color _primaryColor = Color(0xFF00B0FF); // Bright Blue
const Color _darkTextColor = Color(0xFF0D47A1); // Dark Blue

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // --- Form Controllers and State ---
  final _formKey = GlobalKey<FormState>();

  // Controllers initialized to empty strings to force validation on save
  final _fullNameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _phoneController = TextEditingController(text: '');
  final _studentIDController = TextEditingController(text: 'STU123456');
  final _departmentController = TextEditingController(text: '');
  final _campusController = TextEditingController(text: '');
  final _bioController = TextEditingController(text: '');

  XFile? _profilePhoto;
  final ImagePicker _picker = ImagePicker();

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

  // --- Functions ---

  /// Opens the gallery for the user to pick an image.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profilePhoto = image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo uploaded!'),
          duration: Duration(seconds: 1),
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

  /// Validates the form, saves data, and navigates back.
  void _saveAndClose() {
    // 1. Validate the form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please fill out all required fields.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop if validation fails
    }

    // Validation passed, perform save operation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Profile updated successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back after SnackBar delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();
    });
  }

  // --- Build Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Top Save Button & Back Arrow) ---
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // Bright Blue Gradient
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveAndClose, // Top right Save button
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),

      // --- Body (Scrolling Content) ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Profile Photo Section
              _buildProfilePhoto(),
              const SizedBox(height: 30),

              // 2. Personal Information Section
              _buildPersonalInformation(),
              const SizedBox(height: 25),

              // 3. Phone Number Section
              _buildPhoneNumber(),
              const SizedBox(height: 25),

              // 4. University Information Section
              _buildUniversityInformation(),
              const SizedBox(height: 25),

              // 5. Bio Section
              _buildBioSection(),
              const SizedBox(height: 40),

              // 6. "Save Changes" Button
              _buildSaveChangesButton(),
              const SizedBox(height: 40),

              // 7. Profile Tips Section
              _buildProfileTips(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildProfilePhoto() {
    Widget profileImageWidget;

    if (_profilePhoto != null) {
      if (kIsWeb) {
        // Corrected Web Logic: Uses FutureBuilder on readAsBytes()
        profileImageWidget = FutureBuilder<Uint8List?>(
          future: _profilePhoto!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            }
            // Show a placeholder or loading indicator while bytes are loading
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
        );
      } else {
        // Corrected Mobile/Desktop Logic: Uses Image.file
        profileImageWidget = Image.file(
          File(_profilePhoto!.path),
          fit: BoxFit.cover,
        );
      }
    } else {
      // Default: Placeholder widget with initials
      profileImageWidget = const Text(
        'JD',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage, // This triggers the gallery
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_primaryColor, _darkTextColor],
              ),
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Display the image or initials
                  if (_profilePhoto != null)
                    profileImageWidget
                  else
                    Center(child: profileImageWidget),

                  // Camera Icon (Small Circle)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4081),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 20,
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
          'Click the camera icon to upload a new photo',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 16,
            ),
          ),
          // Default validator checks for empty fields if not read-only
          validator:
              validator ??
              (value) {
                if (!readOnly && (value == null || value.isEmpty)) {
                  return 'This field cannot be empty';
                }
                return null;
              },
        ),
      ],
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
          ),
          const SizedBox(height: 15),
          _buildEditableField(
            label: 'Email Address',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
              ).hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
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
          _buildEditableField(
            label: 'Student ID',
            controller: _studentIDController,
            readOnly: true, // Remains read-only
            icon: Icons.credit_card_outlined,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Student ID cannot be changed once verified.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
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
              if (value != null && value.length > 150) {
                return 'Bio must be 150 characters or less';
              }
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
          colors: [
            _primaryColor,
            _darkTextColor,
          ], // Bright Blue to Dark Blue Gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: _saveAndClose, // Both save buttons call this function
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
            const Icon(Icons.info_outline, color: _primaryColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Tips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep your information up to date to help others contact you easily when they find your items!',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
