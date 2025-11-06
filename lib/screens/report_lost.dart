import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen
import 'upload_image.dart';
import 'ai_generated.dart';

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers (optional, but good practice for form data)
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State for the selected date
  DateTime? _selectedDate;

  // New state variable to hold the image URL/path from the upload/AI screen
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _itemNameController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Function to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle form submission
  void _submitReport() {
    // Basic validation check (you would add more detailed checks for all fields)
    if (_formKey.currentState!.validate()) {
      // If validation passes, show the success message popup
      _showSubmissionMessage();
    }
  }

  // Function to show the submission success message dialog
  void _showSubmissionMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.done_all, color: Colors.pink),
              SizedBox(width: 8),
              Text('Report Received!'),
            ],
          ),
          content: const Text(
            'Your lost item report has been submitted successfully.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // **New Functionality:** Handles navigation and waits for the result (image URL/path)
  void _navigateAndHandleImage(
    BuildContext context,
    Widget screen,
    bool isUpload,
  ) async {
    // Wait for the pushed screen to be popped and return a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // If a result (and it's a String) is returned, update the state
    if (result != null && result is String) {
      setState(() {
        _uploadedImageUrl = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if an image has been uploaded
    final bool imageIsUploaded = _uploadedImageUrl != null;

    // The button label changes based on the image presence
    final String uploadButtonLabel = imageIsUploaded
        ? 'Change Photo'
        : 'Upload Photo';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Dark Pinkish Gradient) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false, // Handle back button custom
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Dark pinkish gradient
                gradient: LinearGradient(
                  colors: [Color(0xFFC70039), Color(0xFF581845)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Back Arrow Button (Top Left Corner Button)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Functionality to open home.dart
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Report Lost Item',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Form Content Section ---
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Item Name ---
                      _buildLabel('Item Name'),
                      _buildInputField(
                        controller: _itemNameController,
                        hintText: 'e.g., Black Wallet',
                        validatorText: 'Item Name is required.',
                      ),
                      const SizedBox(height: 16),

                      // --- Category (Dropdown style) ---
                      _buildLabel('Category'),
                      _buildDropdownField(
                        hintText: 'Select category',
                        icon: Icons.keyboard_arrow_down,
                      ),
                      const SizedBox(height: 16),

                      // --- Color ---
                      _buildLabel('Color'),
                      _buildInputField(
                        controller: _colorController,
                        hintText: 'e.g., Black, Blue, Brown',
                        validatorText: 'Color is required.',
                      ),
                      const SizedBox(height: 16),

                      // --- Description ---
                      _buildLabel('Description'),
                      _buildInputField(
                        controller: _descriptionController,
                        hintText: 'Provide details about your item...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                      ),
                      const SizedBox(height: 16),

                      // --- Last Seen Location ---
                      _buildLabel('Last Seen Location'),
                      _buildInputField(
                        controller: _locationController,
                        hintText: 'e.g., Library, 2nd Floor',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                      ),
                      const SizedBox(height: 16),

                      // --- Date Lost ---
                      _buildLabel('Date Lost'),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'Select Date'
                                      : '${_selectedDate!.toLocal().year}-${_selectedDate!.toLocal().month}-${_selectedDate!.toLocal().day}',
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? Colors.grey[700]
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Upload Image Section ---
                      _buildLabel('Upload Image'),

                      // **New:** Display the uploaded image if available
                      if (imageIsUploaded) ...[
                        _buildImagePreview(_uploadedImageUrl!),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          _buildImageActionButton(
                            icon: Icons.upload_outlined,
                            label: uploadButtonLabel, // Dynamic label
                            onTap: () {
                              _navigateAndHandleImage(
                                context,
                                const UploadPhotosScreen(),
                                true,
                              );
                            },
                            isPrimary: false,
                          ),
                          const SizedBox(width: 16),
                          _buildImageActionButton(
                            icon: Icons.flare_outlined,
                            label: 'AI Generate',
                            onTap: () {
                              _navigateAndHandleImage(
                                context,
                                const AiImageGeneratorScreen(),
                                false,
                              );
                            },
                            isPrimary: true,
                          ),
                          // **New:** Optional: Add a Delete button when an image is present
                          if (imageIsUploaded) ...[
                            const SizedBox(width: 16),
                            _buildDeleteImageButton(),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        'Upload a photo or use AI to generate an image description',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button (Pink/Purple Gradient) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style:
                            ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              // Pink/Purple Gradient
                              backgroundColor:
                                  Colors.transparent, // Required for gradient
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ).copyWith(
                              // Apply custom gradient to the button
                              overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                              side: MaterialStateProperty.all(BorderSide.none),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 18),
                              ),
                              // Custom style to apply the gradient background
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFCC2B5E),
                                Color(0xFF753A88),
                              ], // Pink to Purple
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(minHeight: 50.0),
                            child: const Text(
                              'Submit Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    String? validatorText,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(
          vertical: (maxLines > 1 ? 12 : 0) + 8.0,
          horizontal: 10.0,
        ),
      ),
      validator: (value) {
        if (validatorText != null && (value == null || value.isEmpty)) {
          return validatorText;
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required IconData icon,
  }) {
    // This simulates the look of a dropdown without actual logic
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(hintText, style: TextStyle(color: Colors.grey[700])),
          ),
          Icon(icon, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final Color primaryColor = isPrimary
        ? const Color(0xFF753A88)
        : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isPrimary
                ? primaryColor.withOpacity(0.1)
                : Colors.transparent,
            gradient: isPrimary
                ? null
                : null, // The AI button seems to have a subtle purple shade
            borderRadius: BorderRadius.circular(15),
            border: isPrimary
                ? Border.all(
                    color: primaryColor.withOpacity(0.5),
                  ) // Subtle border for AI
                : Border.all(
                    color: Colors.grey.shade400,
                  ), // Dashed border for Upload
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // **New Helper Widget:** To display the uploaded image
  Widget _buildImagePreview(String imageUrl) {
    return Container(
      height: 200, // Fixed height for the image preview
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        // **NOTE:** Since this is a placeholder URL/path, using a placeholder image.
        // In a real app, you would use Image.file(File(imageUrl)) or Image.network(imageUrl)
        // depending on whether the result is a local path or a network URL.
        child: Image.network(
          imageUrl, // Use the actual path/url
          fit: BoxFit.cover,
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
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.red),
                Text(
                  'Image Preview Failed',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // **New Helper Widget:** To delete the image
  Widget _buildDeleteImageButton() {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _uploadedImageUrl = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.red.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_forever_outlined, size: 30, color: Colors.red),
              const SizedBox(height: 8),
              const Text(
                'Delete Photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
