import 'package:flutter/material.dart';

class AiImageGeneratorScreen extends StatefulWidget {
  const AiImageGeneratorScreen({super.key});

  @override
  State<AiImageGeneratorScreen> createState() => _AiImageGeneratorScreenState();
}

// --- COLOR PALETTE FOR BLUE THEME ---
// Main Accent Blue: A vibrant blue (analogous to the original purple/pink)
const Color _mainBlue = Color(0xFF2196F3); // Bright Blue
const Color _darkBlue = Color(0xFF0D47A1); // Darker Blue for depth/text
const Color _lightBlue = Color(
  0xFFB3E5FC,
); // Very light blue for card backgrounds
const Color _successGreen = Color(0xFF4CAF50); // Keep success green

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
    if (_isDescriptionEmpty) return; // Do nothing if text field is empty

    setState(() {
      _isGeneratingImage = true; // Show loading indicator
      _imageGenerated = false; // Hide previous image if any
    });

    // Simulate AI image generation delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGeneratingImage = false;
      _imageGenerated = true;
      // In a real app, you would update _generatedImageUrl here with the AI result
      _generatedImageUrl =
          'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}'; // Random image for demo
    });

    // Scroll logic remains commented out for now.
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
    // Determine button style based on text field content
    final bool isGenerateButtonActive =
        !_isDescriptionEmpty && !_isGeneratingImage;
    // Set text color for the gradient button to White
    final Color generateButtonColor = Colors.white;
    final double generateButtonOpacity = isGenerateButtonActive ? 1.0 : 0.5;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // Bright Blue gradient
              colors: [_mainBlue, _darkBlue],
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Image Generator',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.white70, size: 16),
                SizedBox(width: 4),
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
            _buildHowItWorksCard(),
            const SizedBox(height: 25),

            // 2. Describe Your Item Input Field
            _buildDescriptionInput(),
            const SizedBox(height: 25),

            // 3. Generate Image Button
            _buildGenerateImageButton(
              isGenerateButtonActive,
              generateButtonOpacity,
              generateButtonColor,
            ),
            const SizedBox(height: 25),

            // 4. Generated Image Section (Conditionally displayed)
            if (_imageGenerated) ...[
              _buildGeneratedImageSection(),
              const SizedBox(height: 25),
            ],

            // 5. Pro Tips Card
            _buildProTipsCard(),
            const SizedBox(height: 25),

            // 6. Back Button
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHowItWorksCard() {
    return Card(
      elevation: 0,
      // Card background is light blue
      color: _lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon is dark blue
                const Icon(Icons.edit_outlined, color: _darkBlue, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'How It Works',
                  // Text is dark blue
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Describe your lost item and our AI will generate a visual representation to help others identify it.',
              // Text is dark blue
              style: TextStyle(fontSize: 15, color: _darkBlue),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Example box is dark blue
                color: _darkBlue,
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

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Describe Your Item',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(
            hintText:
                'Describe your item in detail... Include color, material, size, brand, and any unique features.',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use light blue outline for white sections
              borderSide: BorderSide(color: _lightBlue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use light blue outline for white sections
              borderSide: BorderSide(color: _lightBlue, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // Use bright blue for focused outline
              borderSide: const BorderSide(color: _mainBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (text) {
            // Max length 300 for character count, update state
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
  ) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Gradient is Blue
          gradient: const LinearGradient(
            colors: [_mainBlue, _darkBlue],
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

  Widget _buildGeneratedImageSection() {
    return Card(
      elevation: 0,
      // Outline white card with main blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: _mainBlue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    // Icon is dark blue
                    Icon(Icons.image_outlined, color: _darkBlue, size: 24),
                    SizedBox(width: 8),
                    // Text is dark blue
                    Text(
                      'Generated Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _darkBlue,
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
                    color: _successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: _successGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ready',
                        style: TextStyle(
                          color: _successGreen,
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
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.red.shade100,
                      child: const Center(child: Text('Failed to load image')),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.flash_on, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'AI Generated',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
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
                      // Outline button border is light blue
                      side: const BorderSide(color: _lightBlue, width: 2),
                      // Text is dark blue
                      foregroundColor: _darkBlue,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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

  Widget _buildProTipsCard() {
    return Card(
      elevation: 0,
      // Card color is white, outlined with bright blue
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: _mainBlue, width: 1), // Outline
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                // Icon is bright blue
                Icon(Icons.flash_on, color: _mainBlue, size: 24),
                SizedBox(width: 8),
                // Text is dark blue
                Text(
                  'Pro Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkBlue,
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
                ]
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    // Tip text is dark blue
                    child: Text(
                      '• $tip',
                      style: const TextStyle(fontSize: 15, color: _darkBlue),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        // Background is white
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // Border is light blue
        side: const BorderSide(color: _lightBlue, width: 1),
      ),
      child: const Text(
        'Back',
        style: TextStyle(
          fontSize: 18,
          // Text is dark blue
          color: _darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
