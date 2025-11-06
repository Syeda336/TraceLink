import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  // A function to show the success message and navigate back
  void _saveAndClose(BuildContext context) {
    // 1. Show the success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Profile updated successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // 2. Navigate back to the Profile Page after a short delay for the SnackBar
    Future.delayed(const Duration(milliseconds: 500), () {
      // We use pop to go back to the previous screen (which is assumed to be profile_page.dart)
      // If you are using named routes, you might use:
      // Navigator.of(context).popUntil(ModalRoute.withName('/profile'));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Top Save Button & Back Arrow) ---
      appBar: AppBar(
        // The background gradient from the image is often applied via a Theme
        // or a container wrapping the entire screen, but for the AppBar,
        // we'll just focus on the actions.
        automaticallyImplyLeading: false, // Don't use default back button
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // Adding a simple gradient for the top bar as seen in the images
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple gradient
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
            // When the top left button is clicked, open profile_page.dart (by popping)
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => _saveAndClose(context), // Top right Save button
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
            _buildSaveChangesButton(context),
            const SizedBox(height: 40),

            // 7. Profile Tips Section
            _buildProfileTips(),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets to build each section ---

  Widget _buildProfilePhoto() {
    return Column(
      children: [
        // Profile Icon (Large Circle)
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Camera Icon (Small Circle)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(
                      0xFFFF4081,
                    ), // Pinkish color for the camera icon
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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Icon(icon, color: Colors.deepPurple, size: 24),
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

  Widget _buildPersonalInformation() {
    return _buildSectionCard(
      title: 'Personal Information',
      icon: Icons.person_outline,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Full Name',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(text: 'John Doe'),
          const SizedBox(height: 15),
          const Text(
            'Email Address',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(
            text: 'john.doe@university.edu',
            icon: Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return _buildSectionCard(
      title: 'Phone Number',
      icon: Icons.phone_android_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(
            text: '+1 (555) 123-4567',
            icon: Icons.call_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityInformation() {
    return _buildSectionCard(
      title: 'University Information',
      icon: Icons.calendar_today_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student ID',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(text: 'STU123456'),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Student ID cannot be changed',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Department',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(text: 'Computer Science'),
          const SizedBox(height: 15),
          const Text(
            'Campus Location',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildReadOnlyField(
            text: 'Main Campus, Building A',
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return _buildSectionCard(
      title: 'Bio',
      icon: Icons
          .add_circle_outline, // Used a simple plus icon for the Bio section's color
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us about yourself',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Passionate about helping others find their lost items!',
                    style: TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.search, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Share your story with the community',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Text(
                '57/150',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8E2DE2),
            Color(0xFFFF4081),
          ], // Purple to Pink Gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () => _saveAndClose(context), // Bottom Save Changes button
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Make the button background transparent
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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: Colors.deepPurple,
              size: 24,
            ),
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

  // A generic widget for the text fields in the image
  Widget _buildReadOnlyField({required String text, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
