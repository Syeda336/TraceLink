import 'package:flutter/material.dart';
import 'home.dart';
import 'upload_image.dart';
import 'ai_generated.dart';

import 'search_lost.dart';
import 'community_feed.dart';
import 'profile_page.dart';
import 'messages.dart';

// --- Define the Color Palette ---
const Color primaryBlue = Color(
  0xFF42A5F5,
); // Bright Blue (Header, Primary button)
const Color darkBlue = Color(0xFF1977D2); // Dark Blue (Body text, outlines)
const Color lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue (Background)

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  // Assuming this screen is opened from a main navigation index (like 'Home')
  int _selectedIndex = 0;

  void _navigateToScreen(BuildContext context, Widget screen) {
    // This is generally safe for navigating to a detail page
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green,
    Colors.pink,
    Colors.orange,
    Color(0xFF00008B),
    Colors.purple,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for Bottom Navigation Bar items
    // Using pushReplacement for main tabs to prevent back-stack buildup
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1: // Browse
        _navigateToScreen(context, const SearchLost());
        break;
      case 2: // Feed
        _navigateToScreen(context, const CommunityFeed());
        break;
      case 3: // Chat
        _navigateToScreen(context, const MessagesListScreen());
        break;
      case 4: // Profile
        _navigateToScreen(context, const ProfileScreen());
        break;
    }
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }
  // --- END BOTTOM NAV LOGIC ---

  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryBlue,
            colorScheme: const ColorScheme.light(primary: primaryBlue),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle form submission
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Logic to save data and show the success message popup
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
          title: Row(
            children: [
              const Icon(Icons.done_all, color: primaryBlue),
              const SizedBox(width: 8),
              Text('Report Received!', style: TextStyle(color: darkBlue)),
            ],
          ),
          content: const Text(
            'Your lost item report has been submitted successfully.',
            style: TextStyle(color: darkBlue),
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
              child: const Text('OK', style: TextStyle(color: primaryBlue)),
            ),
          ],
        );
      },
    );
  }

  // **FIXED Function:** Handles navigation and waits for the result (image URL/path)
  void _navigateAndHandleImage(BuildContext context, Widget screen) async {
    // Wait for the pushed screen to be popped and return a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // **FIX:** Ensure the result is explicitly a String and not null before updating state.
    if (result is String && result.isNotEmpty) {
      setState(() {
        _uploadedImageUrl = result;
      });
    } else if (result == null) {
      // Optional: If the user cancels the upload screen and returns null,
      // you might want to reset the image URL.
      // setState(() {
      //   _uploadedImageUrl = null;
      // });
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Bright Blue) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(color: primaryBlue),
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
                            color: lightBlueBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: darkBlue,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'Select Date'
                                      : '${_selectedDate!.toLocal().year}-${_selectedDate!.toLocal().month}-${_selectedDate!.toLocal().day}',
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? darkBlue.withOpacity(0.6)
                                        : darkBlue,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: darkBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Upload Image Section ---
                      _buildLabel('Upload Image'),

                      // Display the uploaded image if available
                      if (imageIsUploaded) ...[
                        _buildImagePreview(_uploadedImageUrl!),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          _buildImageActionButton(
                            icon: Icons.upload_outlined,
                            label: uploadButtonLabel,
                            onTap: () {
                              _navigateAndHandleImage(
                                context,
                                const UploadPhotosScreen(),
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
                              );
                            },
                            isPrimary: true,
                          ),
                          // Optional: Add a Delete button when an image is present
                          if (imageIsUploaded) ...[
                            const SizedBox(width: 16),
                            _buildDeleteImageButton(),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        'Upload a photo or use AI to generate an image description',
                        style: TextStyle(color: darkBlue),
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button (Primary Blue) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: primaryBlue,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Submit Report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, color: _getIconColor(2)),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, color: _getIconColor(3)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: darkBlue,
        ),
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
      style: const TextStyle(color: darkBlue),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: darkBlue.withOpacity(0.6)),
        prefixIcon: icon != null ? Icon(icon, color: darkBlue) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: lightBlueBackground,
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
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: lightBlueBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hintText,
              style: TextStyle(color: darkBlue.withOpacity(0.6)),
            ),
          ),
          Icon(icon, color: darkBlue),
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
    final Color color = darkBlue;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isPrimary
                ? lightBlueBackground.withOpacity(0.5)
                : Colors.white,
            // Outlined with dark blue for both
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: darkBlue, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            color: Colors.red.shade50.withOpacity(0.5),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_forever_outlined, size: 30, color: Colors.red),
              SizedBox(height: 8),
              Text(
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

  Widget _buildImagePreview(String imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightBlueBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: darkBlue),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: primaryBlue,
              ),
            );
          },
          // Error handler is crucial for network images
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.red),
                Text(
                  'Image Preview Failed. Check URL/Path.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
