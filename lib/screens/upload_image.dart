import 'package:flutter/material.dart';
import 'report_lost.dart';

// Assuming you have a Home widget (replace with your actual import)
// import 'home.dart';

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  // State variable to track if any photos have been uploaded (or selected)
  // Initially false, making the "Continue" button blurred/disabled.
  bool _hasUploadedPhotos = false;
  int _photoCount = 0; // Simulate the number of uploaded photos

  // Function to simulate photo upload success (for demonstration)
  void _simulatePhotoUpload() {
    setState(() {
      _hasUploadedPhotos = true;
      _photoCount = 1; // Set to 1 or more to enable the button
    });
    // In a real app, this is where you'd call an image picker service.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🖼️ Photo selection simulated!'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  // Function to handle "Skip for Now" navigation
  void _skipForNow() {
    // Navigate to Home.dart, replacing the current screen (using pushAndRemoveUntil)
    // Replace Home() with your actual Home widget and path if necessary
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ReportLostItemScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Function to handle "Continue" logic
  void _continue() {
    if (_hasUploadedPhotos) {
      // Logic for continuing to the next step (e.g., item description)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('➡️ Continuing to the next step...'),
          duration: Duration(seconds: 2),
        ),
      );
      // In a real app, you'd navigate here:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ReportLostItemScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button style based on photo count
    final bool isButtonActive = _hasUploadedPhotos;
    final Color buttonColor = isButtonActive ? Colors.white : Colors.white60;
    final double opacity = isButtonActive ? 1.0 : 0.5;

    return Scaffold(
      // The images suggest a purple/pink gradient background for the top of the AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE5397C), Color(0xFF8E2DE2)], // Pink to Purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Close the screen when the top left button is clicked
            Navigator.of(context).pop();
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Photos',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              'Add photos of your lost item',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          100,
        ), // Padding for the bottom content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Photo Tips Card (Image 1)
            _buildPhotoTipsCard(),
            const SizedBox(height: 25),

            // 2. Gallery and Camera Cards (Image 1)
            Row(
              children: [
                Expanded(
                  child: _buildUploadOptionCard(
                    icon: Icons.upload_rounded,
                    title: 'Gallery',
                    subtitle: 'Choose from photos',
                    onTap: _simulatePhotoUpload, // Simulate upload
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildUploadOptionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: _simulatePhotoUpload, // Simulate capture
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 3. No Photos Yet Card (Image 3)
            _buildNoPhotosCard(),
            const SizedBox(height: 25),

            // 4. Privacy Notice Card (Image 3)
            _buildPrivacyNoticeCard(),
            const SizedBox(height: 40),

            // 5. Continue with X Photos Button (Image 3 - bottom part)
            _buildContinueButton(isButtonActive, opacity, buttonColor),
            const SizedBox(height: 20),

            // 6. Skip for Now Button (Image 2)
            _buildSkipForNowButton(),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPhotoTipsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF5C6BC0),
                  size: 24,
                ), // Blue check icon
                SizedBox(width: 8),
                Text(
                  'Photo Tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...[
                  'Use clear, well-lit photos',
                  'Show multiple angles if possible',
                  'Include any unique features or markings',
                  'Upload up to 5 photos',
                ]
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Text('• $tip', style: const TextStyle(fontSize: 15)),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF5C6BC0), size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoPhotosCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 60),
            const SizedBox(height: 10),
            const Text(
              'No Photos Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Upload or capture photos to help identify your lost item',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyNoticeCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFFFFFBE5), // Light yellowish background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber,
              color: Color(0xFFFF9800),
              size: 24,
            ), // Orange warning icon
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Notice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ensure photos don\'t contain sensitive personal information like credit cards or passwords.',
                    style: TextStyle(fontSize: 14),
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
    Color buttonColor,
  ) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE5397C),
              Color(0xFF8E2DE2),
            ], // Pink to Purple Gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: isButtonActive ? _continue : null, // Disable if no photos
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: buttonColor),
              const SizedBox(width: 8),
              Text(
                'Continue with $_photoCount Photos',
                style: TextStyle(
                  fontSize: 18,
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: const Text(
        'Skip for Now',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
