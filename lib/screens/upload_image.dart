import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data'; // Required for kIsWeb upload
import 'dart:io';

// Import the required theme provider
import '../theme_provider.dart'; // ASSUMING THIS IS THE FILE YOU PROVIDED

// --- DYNAMIC COLOR PALETTE DEFINITION ---
// Base Colors (Light Mode reference)
const Color basePrimaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color baseDarkBlue = Color(0xFF1977D2); // Dark Blue
const Color baseLightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue
const Color baseScaffoldBackground = Colors.white;

// Dark Mode Colors (Example replacements for contrast)
const Color darkPrimaryBlue = Color(0xFF64B5F6); // Lighter shade for visibility
const Color darkDarkBlue = Color(0xFF90CAF9); // Light text color/borders
const Color darkInputBackground = Color(
  0xFF1E1E1E,
); // Dark input field background
const Color darkScaffoldBackground = Color(0xFF121212); // True dark background
const Color darkTextColor = Colors.white;
// --- END COLOR PALETTE DEFINITION ---

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  // Stores the public URL of uploaded images (up to 5)
  final List<String> _uploadedImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  final int _maxPhotos = 5;

  // Supabase and UUID initialization
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  // --- Image Picker & UPLOAD Functionality (Supabase Integrated) ---

  Future<void> _pickImage(ImageSource source) async {
    if (_uploadedImageUrls.length >= _maxPhotos) {
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
      // 1. Generate a unique file path for Supabase
      final String fileExt = pickedFile.name.split('.').last;
      final String fileName = '${_uuid.v4()}.$fileExt';
      // Use a folder path structure, e.g., 'public/item-id/filename.jpg'
      // We'll use a simple 'public/filename.jpg' for this example
      final String storagePath = 'public/$fileName';

      try {
        // 2. Upload to Supabase Storage (Bucket name: 'lost_item_images')
        if (kIsWeb) {
          // Use uploadBinary for web
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          await _supabase.storage
              .from('ImagesOfItems')
              .uploadBinary(
                storagePath,
                imageBytes,
                fileOptions: const FileOptions(cacheControl: '3600'),
              );
        } else {
          // Use upload for mobile/desktop
          final File imageFile = File(pickedFile.path);
          await _supabase.storage
              .from('ImagesOfItems')
              .upload(
                storagePath,
                imageFile,
                fileOptions: const FileOptions(cacheControl: '3600'),
              );
        }

        // 3. Get the public URL for display and persistence
        final String publicUrl = _supabase.storage
            .from('ImagesOfItems')
            .getPublicUrl(storagePath);

        setState(() {
          // Store the public URL instead of the local path
          _uploadedImageUrls.add(publicUrl);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🖼️ Photo uploaded successfully!'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      } on StorageException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Supabase Upload Error: ${e.message}'),
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Function to remove an image from state AND Supabase Storage
  void _removeImage(int index) async {
    final String publicUrl = _uploadedImageUrls[index];

    final String? storagePath = _getStoragePathFromUrl(publicUrl);

    if (storagePath != null) {
      try {
        // 1. Remove from Supabase Storage
        await _supabase.storage.from('lost_item_images').remove([storagePath]);
      } catch (e) {
        debugPrint('Error removing file from Supabase: $e');
      }
    }

    // 2. Remove from local state
    setState(() {
      _uploadedImageUrls.removeAt(index);
    });
  }

  // Helper to extract the storage path (e.g., 'public/filename.jpg') from a public URL
  String? _getStoragePathFromUrl(String url) {
    final String bucket = 'lost_item_images/public/';
    final int bucketIndex = url.indexOf(bucket);
    if (bucketIndex != -1) {
      // Start the path after the bucket and 'public' folder
      final String fullPath = url.substring(bucketIndex + bucket.length);
      // Supabase remove expects the path relative to the bucket,
      // which in this case is likely the path *including* the folder.
      return 'public/$fullPath';
    }
    return null;
  }

  // Function to handle "Continue" logic
  void _continue() {
    if (_uploadedImageUrls.isNotEmpty) {
      // Returns the URL of the *first* uploaded image to the previous screen.
      Navigator.of(context).pop(_uploadedImageUrls.first);
    }
  }

  // Function to handle "Skip for Now" navigation
  void _skipForNow() {
    // Pops the screen and returns null, indicating no image was selected.
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    // 1. ACCESS THEME STATE
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // 2. DEFINE DYNAMIC COLORS BASED ON MODE
    final primaryBlue = isDarkMode ? darkPrimaryBlue : basePrimaryBlue;
    final darkBlue = isDarkMode ? darkDarkBlue : baseDarkBlue;
    final lightBlueBackground = isDarkMode
        ? darkInputBackground
        : baseLightBlueBackground;
    final scaffoldBackground = isDarkMode
        ? darkScaffoldBackground
        : baseScaffoldBackground;
    final textColor = isDarkMode ? darkTextColor : baseDarkBlue;
    final subtitleColor = isDarkMode
        ? darkTextColor.withOpacity(0.7)
        : Colors.white70;

    final int photoCount = _uploadedImageUrls.length; // Use URL list
    final bool isButtonActive = photoCount > 0;

    final Color buttonTextColor = isButtonActive
        ? Colors.white
        : Colors.white70;
    final double buttonOpacity = isButtonActive ? 1.0 : 0.6;

    return Scaffold(
      backgroundColor: scaffoldBackground, // Dynamic color
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: primaryBlue, // Dynamic color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _skipForNow,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Add photos of your lost item',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ), // Dynamic color
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
            _buildPhotoTipsCard(darkBlue, textColor, lightBlueBackground),
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
                    darkBlue: darkBlue,
                    lightBlueBackground: lightBlueBackground,
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildUploadOptionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: () => _pickImage(ImageSource.camera),
                    darkBlue: darkBlue,
                    lightBlueBackground: lightBlueBackground,
                    textColor: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 3. Photo Grid (Displays uploaded photos or a placeholder)
            _buildPhotoGrid(photoCount, darkBlue, lightBlueBackground),
            const SizedBox(height: 25),

            // 4. Privacy Notice Card
            _buildPrivacyNoticeCard(darkBlue, lightBlueBackground, textColor),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // --- Persistent Bottom Bar with Buttons ---
      bottomNavigationBar: Container(
        // Ensure bottom bar has a background color in dark mode
        color: scaffoldBackground,
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
              primaryBlue, // Dynamic color
            ),
            const SizedBox(height: 15),

            // 6. Skip for Now Button
            _buildSkipForNowButton(darkBlue), // Dynamic color
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPhotoTipsCard(
    Color darkBlue,
    Color textColor,
    Color lightBlueBackground,
  ) {
    return Card(
      elevation: 0,
      // Use dynamic background color for the card
      color: lightBlueBackground.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: darkBlue, width: 1.5), // Dynamic color
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: darkBlue,
                  size: 24,
                ), // Dynamic color
                const SizedBox(width: 8),
                Text(
                  'Photo Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue, // Dynamic color
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
            ].map(
              (tip) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  '• $tip',
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                  ), // Dynamic color
                ),
              ),
            ),
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
    required Color darkBlue,
    required Color lightBlueBackground,
    required Color textColor,
  }) {
    return Card(
      elevation: 0,
      color: lightBlueBackground, // Dynamic color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: darkBlue, width: 1.5), // Dynamic color
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: darkBlue, size: 40), // Dynamic color
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Dynamic color
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withOpacity(0.7), // Dynamic color
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(
    int photoCount,
    Color darkBlue,
    Color lightBlueBackground,
  ) {
    // Determine placeholder text color based on darkBlue
    final Color placeholderTextColor = darkBlue;
    final Color placeholderIconColor = darkBlue.withOpacity(0.5);

    if (photoCount == 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: darkBlue, width: 1.5), // Dynamic color
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.image_outlined,
                color: placeholderIconColor, // Dynamic color
                size: 60,
              ),
              const SizedBox(height: 10),
              Text(
                'No Photos Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: placeholderTextColor, // Dynamic color
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Upload or capture photos to help identify your lost item',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: placeholderTextColor,
                  ), // Dynamic color
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
        // Retrieve the Supabase public URL
        final String imageUrl = _uploadedImageUrls[index];

        final Widget imageWidget = Image.network(
          imageUrl,
          fit: BoxFit.cover,
          // Add a loading and error state for network image
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.red.shade100,
            child: const Center(
              child: Text(
                "Load Error",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        );

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

  Widget _buildPrivacyNoticeCard(
    Color darkBlue,
    Color lightBlueBackground,
    Color textColor,
  ) {
    return Card(
      elevation: 0,
      color: lightBlueBackground, // Dynamic color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: darkBlue, width: 1.5), // Dynamic color
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber,
              color: darkBlue,
              size: 24,
            ), // Dynamic color
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Notice',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor, // Dynamic color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ensure photos don\'t contain sensitive personal information like credit cards or passwords.',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8),
                    ), // Dynamic color
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
    Color primaryBlue,
  ) {
    return Opacity(
      opacity: opacity,
      child: ElevatedButton(
        onPressed: isButtonActive ? _continue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue, // Dynamic color
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

  Widget _buildSkipForNowButton(Color darkBlue) {
    return ElevatedButton(
      onPressed: _skipForNow,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.transparent, // Always transparent/white in light mode
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: darkBlue, width: 3), // Dynamic color
        ),
      ),
      child: Text(
        'Skip for Now',
        style: TextStyle(
          fontSize: 18,
          color: darkBlue, // Dynamic color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
