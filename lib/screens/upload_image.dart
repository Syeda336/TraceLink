import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// --- CONDITIONAL IMPORT FIX ---
// This imports 'dart:io' (which contains the File class) for all platforms
// except for the web (where dart.library.html is true).
// For web, it imports a non-existent placeholder ('dart:typed_data' is a simple
// library that is supported on web, but the File class is not exposed).
import 'dart:io';

// If you need conditional types, sometimes using a simple
// if (kIsWeb) { ... } else { ... } approach is clearer.
// We will stick to the standard 'dart:io' import and check kIsWeb inside the build.

// --- Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  // Stores paths of uploaded images (up to 5)
  final List<String> _uploadedImagePaths = [];
  final ImagePicker _picker = ImagePicker();
  final int _maxPhotos = 5;

  // --- Image Picker Functionality ---

  Future<void> _pickImage(ImageSource source) async {
    if (_uploadedImagePaths.length >= _maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Limit reached: Maximum of $_maxPhotos photos allowed.',
          ),
        ),
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _uploadedImagePaths.add(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🖼️ Photo uploaded successfully!'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  // Function to remove an image
  void _removeImage(int index) {
    setState(() {
      _uploadedImagePaths.removeAt(index);
    });
  }

  // Function to handle "Continue" logic
  void _continue() {
    if (_uploadedImagePaths.isNotEmpty) {
      // Returns the path of the *first* uploaded image to the previous screen.
      Navigator.of(context).pop(_uploadedImagePaths.first);
    }
  }

  // Function to handle "Skip for Now" navigation
  void _skipForNow() {
    // Pops the screen and returns null, indicating no image was selected.
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final int photoCount = _uploadedImagePaths.length;
    final bool isButtonActive = photoCount > 0;

    final Color buttonTextColor = isButtonActive
        ? Colors.white
        : Colors.white70;
    final double buttonOpacity = isButtonActive ? 1.0 : 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _skipForNow,
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Add photos of your lost item',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Photo Tips Card
            _buildPhotoTipsCard(),
            const SizedBox(height: 25),

            // 2. Gallery and Camera Cards
            Row(
              children: [
                Expanded(
                  child: _buildUploadOptionCard(
                    icon: Icons.photo_library_outlined,
                    title: 'Gallery',
                    subtitle: 'Choose from photos',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildUploadOptionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 3. Photo Grid (Displays uploaded photos or a placeholder)
            _buildPhotoGrid(photoCount),
            const SizedBox(height: 25),

            // 4. Privacy Notice Card
            _buildPrivacyNoticeCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // --- Persistent Bottom Bar with Buttons ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 5. Continue with X Photos Button
            _buildContinueButton(
              isButtonActive,
              buttonOpacity,
              buttonTextColor,
              photoCount,
            ),
            const SizedBox(height: 15),

            // 6. Skip for Now Button
            _buildSkipForNowButton(),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Separated for clarity) ---

  Widget _buildPhotoTipsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: darkBlue, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: darkBlue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Photo Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...[
                  'Use clear, well-lit photos',
                  'Show multiple angles if possible',
                  'Include any unique features or markings',
                  'Upload up to $_maxPhotos photos',
                ]
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Text(
                      '• $tip',
                      style: const TextStyle(fontSize: 15, color: darkBlue),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: lightBlueBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: darkBlue, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: darkBlue, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: darkBlue.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(int photoCount) {
    if (photoCount == 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: darkBlue, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.image_outlined,
                color: darkBlue.withOpacity(0.5),
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                'No Photos Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Upload or capture photos to help identify your lost item',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: darkBlue),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photoCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final String imagePath = _uploadedImagePaths[index];
        Widget imageWidget;

        if (kIsWeb) {
          // Placeholder for web since Image.file is not supported
          imageWidget = Container(
            color: lightBlueBackground.withOpacity(0.7),
            child: const Center(
              child: Icon(Icons.image_not_supported, color: darkBlue, size: 30),
            ),
          );
        } else {
          // Use Image.file for mobile/desktop. File is available because of 'dart:io' import.
          imageWidget = Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.red.shade100,
              child: const Center(
                child: Text(
                  "File Error",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageWidget,
                // Delete button overlay
                Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () => _removeImage(index),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyNoticeCard() {
    return Card(
      elevation: 0,
      color: lightBlueBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: darkBlue, width: 1.5),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber, color: darkBlue, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Notice',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ensure photos don\'t contain sensitive personal information like credit cards or passwords.',
                    style: TextStyle(fontSize: 14, color: darkBlue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(
    bool isButtonActive,
    double opacity,
    Color buttonTextColor,
    int photoCount,
  ) {
    return Opacity(
      opacity: opacity,
      child: ElevatedButton(
        onPressed: isButtonActive ? _continue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: buttonTextColor),
            const SizedBox(width: 8),
            Text(
              'Continue with $photoCount Photos',
              style: TextStyle(
                fontSize: 18,
                color: buttonTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipForNowButton() {
    return ElevatedButton(
      onPressed: _skipForNow,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: darkBlue, width: 1.5),
        ),
      ),
      child: const Text(
        'Skip for Now',
        style: TextStyle(
          fontSize: 18,
          color: darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
