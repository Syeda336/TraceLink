import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// NEW SUPABASE IMPORTS
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../theme_provider.dart';

//***************Using Cloudflare to hide the Api key********************** */

// --- DYNAMIC COLOR PALETTE DEFINITIONS ---

// Base Colors (LIGHT MODE REFERENCE)
const Color baseMainBlue = Color(0xFF2196F3); // Bright Blue
const Color baseDarkBlue = Color(0xFF0D47A1); // Darker Blue for depth/text
const Color baseLightBlue = Color(
  0xFFB3E5FC,
); // Very light blue for card backgrounds
const Color baseSuccessGreen = Color(0xFF4CAF50); // Success Green
const Color baseScaffoldBackground = Colors.white;
const Color baseInputBackground = Color(
  0xFFF5F5F5,
); // Light grey input background
const Color baseTextColor = Colors.black;

// Dark Mode Color Equivalents
const Color darkMainBlue = Color(0xFF64B5F6); // Lighter blue for visibility
const Color darkDarkBlue = Color(0xFF90CAF9); // Light blue for text/icons
const Color darkLightBlue = Color(
  0xFF1E1E1E,
); // Dark background for cards/inputs
const Color darkSuccessGreen = Color(0xFFA5D6A7); // Lighter success green
const Color darkScaffoldBackground = Color(0xFF121212); // True dark background
const Color darkInputBackground = Color(0xFF1E1E1E);
const Color darkTextColor = Colors.white;

class AiImageGeneratorScreen extends StatefulWidget {
  const AiImageGeneratorScreen({super.key});

  @override
  State<AiImageGeneratorScreen> createState() => _AiImageGeneratorScreenState();
}

class _AiImageGeneratorScreenState extends State<AiImageGeneratorScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDescriptionEmpty = true;
  bool _isGeneratingImage = false; // State for loading indicator
  bool _imageGenerated = false; // State to show/hide generated image section

  // MODIFIED STATE: Store the public URL instead of bytes
  String? _imageUrl;
  // We keep bytes temporarily for upload, but we don't store them long-term
  Uint8List? _imageBytes;

  // SUPABASE AND UUID INSTANCES
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  // IMPORTANT: Replace this with your actual bucket name in Supabase Storage
  static const String _bucketName = 'ImagesOfItems';

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateButtonState);
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isDescriptionEmpty = _descriptionController.text.trim().isEmpty;
    });
  }

  //*************function which calls the text to image model and uploads to Supabase*********************** */
  Future<void> _generateImage() async {
    final prompt = _descriptionController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isGeneratingImage = true;
      _imageGenerated = false;
      _imageUrl = null; // Clear previous URL
      _imageBytes = null; // Clear previous bytes
    });

    try {
      // 1. CALL CLOUDFLARE WORKER TO GENERATE IMAGE BYTES
      final response = await http.post(
        //********using workers URL from cloudflare************** */
        Uri.parse("https://imageapi.251723892.workers.dev"),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        _imageBytes = response.bodyBytes;

        // 2. UPLOAD BYTES TO SUPABASE STORAGE
        final String fileExt = 'png'; // Assuming the AI model returns PNG
        final String fileName = '${_uuid.v4()}.$fileExt';
        final String storagePath = 'generated/$fileName'; // 'generated' folder

        await _supabase.storage
            .from(_bucketName)
            .uploadBinary(
              storagePath,
              _imageBytes!,
              fileOptions: const FileOptions(
                upsert: true,
                cacheControl: '3600',
              ),
            );

        // 3. GET THE PUBLIC URL
        final String publicUrl = _supabase.storage
            .from(_bucketName)
            .getPublicUrl(storagePath);

        setState(() {
          _imageUrl = publicUrl;
          _imageGenerated = true;
          _isGeneratingImage = false;
        });
      } else {
        debugPrint("ERROR: ${response.statusCode} - ${response.body}");
        _showErrorSnackBar('Image generation failed: ${response.statusCode}');
        setState(() {
          _isGeneratingImage = false;
          _imageGenerated = false;
        });
      }
    } on StorageException catch (e) {
      debugPrint("Supabase Storage Exception: ${e.message}");
      _showErrorSnackBar('Storage Error: Check bucket name or RLS policy.');
      setState(() {
        _isGeneratingImage = false;
      });
    } catch (e) {
      debugPrint("Exception: $e");
      _showErrorSnackBar('An unknown error occurred: $e');
      setState(() {
        _isGeneratingImage = false;
        _imageGenerated = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛑 $message'),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _regenerateImage() {
    setState(() {
      _imageGenerated = false;
      _descriptionController.clear();
      _isDescriptionEmpty = true;
      _isGeneratingImage = false;
      _imageUrl = null;
    });
  }

  void _useThisImage() {
    if (_imageUrl != null) {
      // Pass the generated URL back to the calling screen
      Navigator.of(context).pop(_imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🖼️ Image selected and used!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final mainBlue = isDarkMode ? darkMainBlue : baseMainBlue;
    final darkBlue = isDarkMode ? darkDarkBlue : baseDarkBlue;
    final lightBlue = isDarkMode ? darkInputBackground : baseLightBlue;
    final successGreen = isDarkMode ? darkSuccessGreen : baseSuccessGreen;
    final scaffoldBackground = isDarkMode
        ? darkScaffoldBackground
        : baseScaffoldBackground;
    final inputBackground = isDarkMode
        ? darkInputBackground
        : baseInputBackground;
    final primaryTextColor = isDarkMode ? darkTextColor : baseTextColor;

    final bool isGenerateButtonActive =
        !_isDescriptionEmpty && !_isGeneratingImage;
    final Color generateButtonColor = Colors.white;
    final double generateButtonOpacity = isGenerateButtonActive ? 1.0 : 0.5;

    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Image Generator',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Powered by FLUX AI',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHowItWorksCard(darkBlue, lightBlue),
            const SizedBox(height: 25),
            _buildDescriptionInput(
              mainBlue,
              lightBlue,
              darkBlue,
              inputBackground,
              primaryTextColor,
            ),
            const SizedBox(height: 25),
            _buildGenerateImageButton(
              isGenerateButtonActive,
              generateButtonOpacity,
              generateButtonColor,
              mainBlue,
              darkBlue,
            ),
            const SizedBox(height: 25),
            if (_imageGenerated) ...[
              // Updated to use the URL state
              _buildGeneratedImageSection(
                mainBlue,
                darkBlue,
                lightBlue,
                successGreen,
              ),
              const SizedBox(height: 25),
            ],
            if (_isGeneratingImage)
              _buildLoadingIndicator(), // Show loading outside the image card
            const SizedBox(height: 25),
            _buildProTipsCard(
              mainBlue,
              darkBlue,
              scaffoldBackground,
              primaryTextColor,
            ),
            const SizedBox(height: 25),
            _buildBackButton(lightBlue, darkBlue, scaffoldBackground),
          ],
        ),
      ),
    );
  }

  // New Loading Widget
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Generating image, please wait..."),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildHowItWorksCard(Color darkBlue, Color lightBlue) {
    return Card(
      elevation: 0,
      color: lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_outlined, color: darkBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'How It Works',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Describe your lost item and our AI will generate a visual representation to help others identify it.',
              style: TextStyle(fontSize: 15, color: darkBlue),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Example: "A black leather wallet with brown stitching and a metal clasp"',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionInput(
    Color mainBlue,
    Color lightBlue,
    Color darkBlue,
    Color inputBackground,
    Color primaryTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          minLines: 3,
          style: TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
            hintText:
                'Describe your item in detail... Include color, material, size, brand, and any unique features.',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: darkBlue.withOpacity(0.5),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: darkBlue.withOpacity(0.5),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: mainBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Be as detailed as possible',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            Text(
              '${_descriptionController.text.length}/300',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateImageButton(
    bool isActive,
    double opacity,
    Color buttonColor,
    Color mainBlue,
    Color darkBlue,
  ) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [mainBlue, darkBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: isActive && !_isGeneratingImage ? _generateImage : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: _isGeneratingImage
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, color: buttonColor),
                    const SizedBox(width: 8),
                    Text(
                      'Generate Image',
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

  // MODIFIED WIDGET: Displays image using Image.network from Supabase URL
  Widget _buildGeneratedImageSection(
    Color mainBlue,
    Color darkBlue,
    Color lightBlue,
    Color successGreen,
  ) {
    return Card(
      elevation: 0,
      color: lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: mainBlue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.image_outlined, color: darkBlue, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Generated Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: successGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ready',
                        style: TextStyle(
                          color: successGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _imageUrl != null
                  ? Image.network(
                      // Use Image.network for Supabase URL
                      _imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: lightBlue.withOpacity(0.7),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.red.shade100,
                        child: Center(
                          child: Text(
                            'Image Load Error: $error',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: lightBlue.withOpacity(0.5),
                      child: const Center(child: Text('No image URL')),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _regenerateImage,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(color: darkBlue, width: 2),
                      foregroundColor: darkBlue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh, size: 20),
                        SizedBox(width: 8),
                        Text('Regenerate', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _useThisImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Use This',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProTipsCard(
    Color mainBlue,
    Color darkBlue,
    Color scaffoldBackground,
    Color primaryTextColor,
  ) {
    return Card(
      elevation: 0,
      color: scaffoldBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: mainBlue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: mainBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Pro Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...[
              'Include brand names for better accuracy',
              'Mention distinctive features or markings',
              'Specify colors and materials clearly',
              'You can regenerate if the result isn\'t perfect',
            ].map(
              (tip) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  '• $tip',
                  style: TextStyle(fontSize: 15, color: darkBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(
    Color lightBlue,
    Color darkBlue,
    Color scaffoldBackground,
  ) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: scaffoldBackground,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: darkBlue, width: 1),
        elevation: 0,
      ),
      child: Text(
        'Back',
        style: TextStyle(
          fontSize: 18,
          color: darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
