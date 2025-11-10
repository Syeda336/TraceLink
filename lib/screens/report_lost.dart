import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // REQUIRED: Import Provider
import 'home.dart';
import 'upload_image.dart';
import 'ai_generated.dart';

import 'search_lost.dart';
import 'community_feed.dart';
import 'profile_page.dart';
import 'messages.dart';
import '../theme_provider.dart'; // Using the provided ThemeProvider

// --- Color Palette Definition (Defined internally based on mode) ---
// Base Colors (Light Mode reference)
const Color basePrimaryBlue = Color(0xFF42A5F5);
const Color baseDarkBlue = Color(0xFF1977D2);
const Color baseLightBlueBackground = Color(0xFFE3F2FD);

// Dark Mode Colors (Example replacements)
const Color darkPrimaryBlue = Color(0xFF64B5F6); // Lighter shade for visibility
const Color darkDarkBlue = Color(0xFF90CAF9); // Light text color
const Color darkBackground = Color(0xFF121212); // True dark background
const Color darkInputBackground = Color(
  0xFF1E1E1E,
); // Dark input field background

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  // Assuming this screen is opened from a main navigation index (like 'Home')
  int _selectedIndex = 0;

  void _navigateToScreen(BuildContext context, Widget screen) {
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

  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? _selectedDate;
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
    // Determine the primary color dynamically for the DatePicker theme
    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final primaryColor = isDarkMode ? darkPrimaryBlue : basePrimaryBlue;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(primary: primaryColor),
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
      _showSubmissionMessage();
    }
  }

  // Function to show the submission success message dialog
  void _showSubmissionMessage() {
    // Determine colors dynamically for the dialog
    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final primaryBlue = isDarkMode ? darkPrimaryBlue : basePrimaryBlue;
    final darkBlue = isDarkMode ? darkDarkBlue : baseDarkBlue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Icon(Icons.done_all, color: primaryBlue),
              const SizedBox(width: 8),
              Text('Report Received!', style: TextStyle(color: darkBlue)),
            ],
          ),
          content: Text(
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
              child: Text('OK', style: TextStyle(color: primaryBlue)),
            ),
          ],
        );
      },
    );
  }

  void _navigateAndHandleImage(BuildContext context, Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result is String && result.isNotEmpty) {
      setState(() {
        _uploadedImageUrl = result;
      });
    }
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
    final screenBackground = isDarkMode ? darkBackground : Colors.white;
    final textColor = isDarkMode ? Colors.white : baseDarkBlue;

    final bool imageIsUploaded = _uploadedImageUrl != null;
    final String uploadButtonLabel = imageIsUploaded
        ? 'Change Photo'
        : 'Upload Photo';

    return Scaffold(
      backgroundColor: screenBackground,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Primary Color) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(color: primaryBlue), // Dynamic color
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
                      _buildLabel('Item Name', textColor),
                      _buildInputField(
                        controller: _itemNameController,
                        hintText: 'e.g., Black Wallet',
                        validatorText: 'Item Name is required.',
                        darkBlue: darkBlue,
                        lightBlueBackground: lightBlueBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Category (Dropdown style) ---
                      _buildLabel('Category', textColor),
                      _buildDropdownField(
                        hintText: 'Select category',
                        icon: Icons.keyboard_arrow_down,
                        darkBlue: darkBlue,
                        lightBlueBackground: lightBlueBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Color ---
                      _buildLabel('Color', textColor),
                      _buildInputField(
                        controller: _colorController,
                        hintText: 'e.g., Black, Blue, Brown',
                        validatorText: 'Color is required.',
                        darkBlue: darkBlue,
                        lightBlueBackground: lightBlueBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Description ---
                      _buildLabel('Description', textColor),
                      _buildInputField(
                        controller: _descriptionController,
                        hintText: 'Provide details about your item...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                        darkBlue: darkBlue,
                        lightBlueBackground: lightBlueBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Last Seen Location ---
                      _buildLabel('Last Seen Location', textColor),
                      _buildInputField(
                        controller: _locationController,
                        hintText: 'e.g., Library, 2nd Floor',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                        darkBlue: darkBlue,
                        lightBlueBackground: lightBlueBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Date Lost ---
                      _buildLabel('Date Lost', textColor),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: lightBlueBackground, // Dynamic color
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: darkBlue, // Dynamic color
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
                                        : darkBlue, // Dynamic color
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: darkBlue, // Dynamic color
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Upload Image Section ---
                      _buildLabel('Upload Image', textColor),

                      // Display the uploaded image if available
                      if (imageIsUploaded) ...[
                        _buildImagePreview(
                          _uploadedImageUrl!,
                          primaryBlue,
                          darkBlue,
                          lightBlueBackground,
                          isDarkMode,
                        ),
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
                            darkBlue: darkBlue,
                            lightBlueBackground: lightBlueBackground,
                            isDarkMode: isDarkMode,
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
                            darkBlue: darkBlue,
                            lightBlueBackground: lightBlueBackground,
                            isDarkMode: isDarkMode,
                          ),
                          // Optional: Add a Delete button when an image is present
                          if (imageIsUploaded) ...[
                            const SizedBox(width: 16),
                            _buildDeleteImageButton(),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        'Upload a photo or use AI to generate an image description',
                        style: TextStyle(color: darkBlue), // Dynamic color
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button (Primary Blue) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: primaryBlue, // Dynamic color
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
        backgroundColor: isDarkMode
            ? darkBackground
            : Colors.white, // Dynamic color
        elevation: 10,
      ),
    );
  }

  // --- Helper Widgets (Updated to accept dynamic colors) ---

  Widget _buildLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: textColor, // Dynamic color
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
    required Color darkBlue,
    required Color lightBlueBackground,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor), // Dynamic color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: darkBlue.withOpacity(0.6)), // Dynamic color
        prefixIcon: icon != null
            ? Icon(icon, color: darkBlue)
            : null, // Dynamic color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: lightBlueBackground, // Dynamic color
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
    required Color darkBlue,
    required Color lightBlueBackground,
    required Color textColor,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: lightBlueBackground, // Dynamic color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hintText,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
              ), // Dynamic color
            ),
          ),
          Icon(icon, color: darkBlue), // Dynamic color
        ],
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    required Color darkBlue,
    required Color lightBlueBackground,
    required bool isDarkMode,
  }) {
    final Color color = darkBlue; // Dynamic color

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isPrimary
                ? lightBlueBackground
                : (isDarkMode ? darkInputBackground : Colors.white),
            // Outlined with dynamic dark blue
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

  Widget _buildImagePreview(
    String imageUrl,
    Color primaryBlue,
    Color darkBlue,
    Color lightBlueBackground,
    bool isDarkMode,
  ) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightBlueBackground, // Dynamic color
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: darkBlue), // Dynamic color
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
                color: primaryBlue, // Dynamic color
              ),
            );
          },
          // Error handler is crucial for network images
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 50,
                  color: darkBlue,
                ), // Dynamic color
                Text(
                  'Image Preview Failed. Check URL/Path.',
                  style: TextStyle(color: darkBlue), // Dynamic color
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
