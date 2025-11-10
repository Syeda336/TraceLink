import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ASSUMING theme_provider.dart IS IN THE SAME DIRECTORY
import '../theme_provider.dart';

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

  // Example image URL - in a real app, this would come from an AI API
  String _generatedImageUrl =
      'https://via.placeholder.com/300x200?text=AI+Generated+Image';

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

  // Update button state based on text field content
  void _updateButtonState() {
    setState(() {
      _isDescriptionEmpty = _descriptionController.text.trim().isEmpty;
    });
  }

  // Handle "Generate Image" button press
  void _generateImage() async {
    if (_isDescriptionEmpty) return;

    setState(() {
      _isGeneratingImage = true; // Show loading indicator
      _imageGenerated = false; // Hide previous image if any
    });

    // Simulate AI image generation delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGeneratingImage = false;
      _imageGenerated = true;
      // Random image for demo
      _generatedImageUrl =
          'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  // Handle "Regenerate" button press
  void _regenerateImage() {
    setState(() {
      _imageGenerated = false; // Hide generated image
      _descriptionController.clear(); // Clear description to allow new input
      _isDescriptionEmpty = true; // Reset button state
      _isGeneratingImage = false; // Reset generation state
    });
  }

  // Handle "Use This" button press
  void _useThisImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🖼️ Image selected and used!'),
        duration: Duration(seconds: 2),
      ),
    );
    // Close the screen after using the image
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // 1. ACCESS THEME STATE
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // 2. DYNAMICALLY MAP COLORS
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

    // Determine button style based on text field content
    final bool isGenerateButtonActive =
        !_isDescriptionEmpty && !_isGeneratingImage;
    // Set text color for the gradient button to White
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
              // Dynamic Blue gradient
              colors: [mainBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          // Icon is white as per theme rules
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                  'Powered by Gemini AI',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. How It Works Card
            _buildHowItWorksCard(darkBlue, lightBlue),
            const SizedBox(height: 25),

            // 2. Describe Your Item Input Field
            _buildDescriptionInput(
              mainBlue,
              lightBlue,
              darkBlue,
              inputBackground,
              primaryTextColor,
            ),
            const SizedBox(height: 25),

            // 3. Generate Image Button
            _buildGenerateImageButton(
              isGenerateButtonActive,
              generateButtonOpacity,
              generateButtonColor,
              mainBlue,
              darkBlue,
            ),
            const SizedBox(height: 25),

            // 4. Generated Image Section (Conditionally displayed)
            if (_imageGenerated) ...[
              _buildGeneratedImageSection(
                mainBlue,
                darkBlue,
                lightBlue,
                successGreen,
              ),
              const SizedBox(height: 25),
            ],

            // 5. Pro Tips Card
            _buildProTipsCard(
              mainBlue,
              darkBlue,
              scaffoldBackground,
              primaryTextColor,
            ),
            const SizedBox(height: 25),

            // 6. Back Button
            _buildBackButton(lightBlue, darkBlue, scaffoldBackground),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHowItWorksCard(Color darkBlue, Color lightBlue) {
    return Card(
      elevation: 0,
      // Card background is light blue (dynamic)
      color: lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon is dark blue (dynamic)
                Icon(Icons.edit_outlined, color: darkBlue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'How It Works',
                  // Text is dark blue (dynamic)
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
              // Text is dark blue (dynamic)
              style: TextStyle(fontSize: 15, color: darkBlue),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Example box is dark blue (dynamic)
                color: darkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Example: "A black leather wallet with brown stitching and a metal clasp"',
                // Text is white
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
            fillColor: inputBackground, // Dynamic color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use light blue outline (dynamic)
              borderSide: BorderSide(
                color: darkBlue.withOpacity(0.5),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use light blue outline (dynamic)
              borderSide: BorderSide(
                color: darkBlue.withOpacity(0.5),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use bright blue for focused outline (dynamic)
              borderSide: BorderSide(color: mainBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
          onChanged: (text) {
            setState(() {});
          },
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
          // Gradient is Blue (dynamic)
          gradient: LinearGradient(
            colors: [mainBlue, darkBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: isActive && !_isGeneratingImage
              ? _generateImage
              : null, // Disable if generating or text is empty
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
                    // Icon color is white (buttonColor)
                    Icon(Icons.flash_on, color: buttonColor),
                    const SizedBox(width: 8),
                    Text(
                      'Generate Image',
                      style: TextStyle(
                        fontSize: 18,
                        // Text color is white (buttonColor)
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

  Widget _buildGeneratedImageSection(
    Color mainBlue,
    Color darkBlue,
    Color lightBlue,
    Color successGreen,
  ) {
    return Card(
      elevation: 0,
      // Outline white/dark card with main blue (dynamic)
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
                    // Icon is dark blue (dynamic)
                    Icon(Icons.image_outlined, color: darkBlue, size: 24),
                    const SizedBox(width: 8),
                    // Text is dark blue (dynamic)
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
              child: Stack(
                children: [
                  Image.network(
                    _generatedImageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: lightBlue.withOpacity(
                          0.5,
                        ), // Dynamic loading background
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            color: mainBlue, // Dynamic indicator color
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.red.shade900.withOpacity(0.3),
                      child: const Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Opacity(
                      opacity: 0.8,
                      child: Chip(
                        avatar: Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: Text(
                          'AI Generated',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ],
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
                      // Outline button border is light blue (dynamic)
                      side: BorderSide(color: darkBlue, width: 2),
                      // Text is dark blue (dynamic)
                      foregroundColor: darkBlue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh, size: 20),
                        const SizedBox(width: 8),
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
                      // Gradient is success green (kept from original)
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
      // Card color is white/dark (dynamic), outlined with bright blue (dynamic)
      color: scaffoldBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: mainBlue, width: 1), // Outline
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon is bright blue (dynamic)
                Icon(Icons.flash_on, color: mainBlue, size: 24),
                const SizedBox(width: 8),
                // Text is primary text color (dynamic)
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
                // Tip text is dark blue (dynamic)
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
        // Background is white/dark (dynamic)
        backgroundColor: scaffoldBackground,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // Border is light blue (dynamic)
        side: BorderSide(color: darkBlue, width: 1),
        elevation: 0,
      ),
      child: Text(
        'Back',
        style: TextStyle(
          fontSize: 18,
          // Text is dark blue (dynamic)
          color: darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
