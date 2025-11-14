// edit_profile.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:tracelink/firebase_service.dart';

// --- Theme Colors ---
const Color _primaryColor = Color(0xFF00B0FF);
const Color _darkTextColor = Color(0xFF0D47A1);

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
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePhoto = image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo uploaded!'), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No photo selected.'), duration: Duration(seconds: 1)),
      );
    }
  }
//**********ASK USER FOR PASSWORD BEFORE UPDATING******************* */
  Future<String?> _askUserForPassword() async {
  final _passwordController = TextEditingController();
  
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Enter Current Password'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Current Password',
          border: OutlineInputBorder(),
        ),
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
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}

//******save the updates and close */
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
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    Map<String, dynamic>? currentUserData = await FirebaseService.getUserData();
    String currentEmail = currentUserData?['email'] ?? '';
    String newEmail = _emailController.text.trim();

    bool emailChanged = currentEmail != newEmail;
    String? currentPassword;

    if (emailChanged) {
      currentPassword = await _askUserForPassword();
      if (currentPassword == null || currentPassword.isEmpty) {
        Navigator.of(context).pop(); // Hide loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Email update requires current password.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    // ************Update profile in Firestore
    bool profileUpdated = await FirebaseService.updateUserProfile(
      fullName: _fullNameController.text.trim(),
      email: newEmail,
      phoneNumber: _phoneController.text.trim(),
      department: _departmentController.text.trim(),
      campus: _campusController.text.trim(),
      bio: _bioController.text.trim(),
      currentPassword: emailChanged ? currentPassword : null,
    );

    // 🔥 ADD THIS DEBUG LINE:
          print('🔥 Profile update result: $profileUpdated');

    Navigator.of(context).pop(); // Hide loading

    if (profileUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Wait a bit then go back and refresh
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop(true); // Go back with success result
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to update profile. Please check your password and try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    Navigator.of(context).pop(); // Hide loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An unexpected error occurred: $e'),
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
            //onPressed: () => Navigator.of(context).pop(),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false indicating no changes
              },

          ),



          title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
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
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          //onPressed: () => Navigator.of(context).pop(),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false indicating no changes
                },

        ),



        actions: [
          TextButton(
            onPressed: _saveAndClose,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
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
    if (_profilePhoto != null) {
      if (kIsWeb) {
        profileImageWidget = FutureBuilder<Uint8List?>(
          future: _profilePhoto!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            }
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          },
        );
      } else {
        profileImageWidget = Image.file(File(_profilePhoto!.path), fit: BoxFit.cover);
      }
    } else {
      profileImageWidget = Text(
        _fullNameController.text.isNotEmpty && _fullNameController.text.contains(' ')
            ? '${_fullNameController.text.split(' ').first.substring(0, 1)}${_fullNameController.text.split(' ').last.substring(0, 1)}'
            : _fullNameController.text.isNotEmpty
                ? _fullNameController.text.substring(0, 1)
                : 'U',
        style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      );
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
              gradient: const LinearGradient(colors: [_primaryColor, _darkTextColor]),
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_profilePhoto != null) profileImageWidget else Center(child: profileImageWidget),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4081),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Profile Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Text('Click the camera icon to upload a new photo', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          _buildEditableField(label: 'Full Name', controller: _fullNameController, icon: Icons.person_outline),
          const SizedBox(height: 15),
          _buildEditableField(
            label: 'Email Address',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
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
      content: _buildEditableField(label: 'Phone Number', controller: _phoneController, icon: Icons.call_outlined, keyboardType: TextInputType.phone),
    );
  }

  Widget _buildUniversityInformation() {
    return _buildSectionCard(
      title: 'University Information',
      icon: Icons.school_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(label: 'Student ID', controller: _studentIDController, readOnly: true, icon: Icons.credit_card_outlined),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text('Student ID cannot be changed once verified.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          const SizedBox(height: 15),
          _buildEditableField(label: 'Department', controller: _departmentController, icon: Icons.book_outlined),
          const SizedBox(height: 15),
          _buildEditableField(label: 'Campus Location', controller: _campusController, icon: Icons.location_on_outlined),
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
              if (value != null && value.length > 150) return 'Bio must be 150 characters or less';
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
                  return Text('${value.text.length}/150', style: TextStyle(fontSize: 12, color: value.text.length > 150 ? Colors.red : Colors.grey));
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
        gradient: const LinearGradient(colors: [_primaryColor, _darkTextColor], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
      child: TextButton(
        onPressed: _saveAndClose,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 8),
            Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTips() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: _primaryColor, width: 1.0)),
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
                  const Text('Profile Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildSectionCard({required String title, required Widget content, IconData? icon}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: _primaryColor, width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, color: _primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
