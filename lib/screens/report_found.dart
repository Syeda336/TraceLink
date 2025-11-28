import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Added for date formatting

import 'package:supabase_flutter/supabase_flutter.dart';
import 'upload_image.dart';
import '../theme_provider.dart'; // Import the ThemeProvider
import 'bottom_navigation.dart';

import 'package:tracelink/firebase_service.dart';

final supabase = Supabase.instance.client;

// --- Color Palette for Blue Theme (Used as Primary/Accent) ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({super.key});

  @override
  State<ReportFoundItemScreen> createState() => _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  // Map for Firebase data: 'fullName', 'studentId', 'email' are expected keys
  Map<String, dynamic>? userData;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load real data when screen starts
  }

  // This will refresh the data when you come back to the profile page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only reload if data is null or if the provider/route changes significantly
    // We already load in initState, so calling it here too ensures refresh on navigation back
    if (userData == null && !isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    // Assuming FirebaseService.getUserData() fetches the required data (full name, student ID, email)
    Map<String, dynamic>? data = await FirebaseService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers/variables
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  // Example dummy data for dropdown
  String? _selectedCategory = 'Electronics';
  DateTime? _selectedDate = DateTime.now();

  // Stores the Supabase URL returned from UploadPhotosScreen
  String? _uploadedImageUrl;

  // Dummy list for categories
  final List<String> _categories = [
    'Electronics',
    'Wallet/ID',
    'Clothing',
    'Keys',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _itemNameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // Function to handle opening the image upload screen
  Future<void> _openImageUploadScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadPhotosScreen()),
    );

    // Assuming 'result' is the Supabase URL on success
    if (result is String) {
      setState(() {
        _uploadedImageUrl = result;
      });
    }
  }

  // Function to handle form submission
  Future<void> _submitReport() async {
    // Basic validation check for required fields
    if (!_formKey.currentState!.validate()) {
      return; // Stop submission if validation fails
    }
    // Include reporter information in the postData
    final String reporterName = userData?['fullName'] ?? 'Unknown Reporter';
    final String reporterEmail = userData?['email'] ?? 'unknown@example.com';
    final String reporterStudentId = userData?['studentId'] ?? 'N/A';

    try {
      // 1. Prepare the data Map
      final postData = {
        'Item Name': _itemNameController.text.trim(),
        'Category': _selectedCategory,
        'Color': _colorController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Location': _locationController.text.trim(),
        'Date Lost': _selectedDate
            ?.toIso8601String(), // ISO 8601 format for database
        'Image': _uploadedImageUrl, // Can be null
        // Use ?? 'anonymous' if the user might not be logged in, otherwise just null/omitted
        //'User Id': supabase.auth.currentUser,
        'User Name': reporterName,
        'User Email': reporterEmail,
        'User ID': reporterStudentId,
      };

      // 2. Insert data into the 'Found' table
      // **MODIFICATION:** Changed table name to 'Found'
      final response = await supabase
          .from('Found')
          .insert(postData)
          .select(); // Request the inserted record back

      print('Report submitted successfully. ID: ${response.first['id']}');

      // 3. Show success message
      _showSubmissionMessage(isSuccess: true);
    } on PostgrestException catch (e) {
      // Handle database specific errors (e.g., RLS violation, constraint error)
      print('Supabase Postgrest Error: ${e.message}');
      _showSubmissionMessage(
        isSuccess: false,
        errorMessage: 'Database Error: ${e.message}',
      );
    } catch (e) {
      // Handle general network or unexpected errors
      print('General Submission Error: $e');
      _showSubmissionMessage(
        isSuccess: false,
        errorMessage:
            'Submission Failed. Check network connection or contact support.',
      );
    }
  }

  // Function to show the submission success message dialog
  void _showSubmissionMessage({bool isSuccess = true, String? errorMessage}) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap OK to dismiss
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? primaryBlue : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                isSuccess ? 'Thank You!' : 'Submission Failed',
                style: TextStyle(color: theme.textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Text(
            isSuccess
                ? 'Your report has been submitted. We appreciate your help!'
                : errorMessage ??
                      'An unknown error occurred during submission.',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (isSuccess) {
                  // Navigate to home.dart only on success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavScreen(),
                    ),
                  );
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: isSuccess ? darkBlue : Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Date Picker Helper ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: darkBlue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
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

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define dynamic colors based on the theme
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color inputHintColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey;
    final Color cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Blue Gradient) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false, // Handle back button custom
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Blue gradient remains constant regardless of dark mode for branding
                gradient: LinearGradient(
                  colors: [primaryBlue, darkBlue], // Blue shades
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
                                  builder: (context) => const BottomNavScreen(),
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Report Found Item',
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
                      // --- Thank you Card (Light Blue/Dynamic) ---
                      Card(
                        elevation: 0,
                        // Use lightBlueBackground or a dynamic color in dark mode
                        color: isDarkMode
                            ? darkBlue.withOpacity(0.3)
                            : lightBlueBackground.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: primaryBlue.withOpacity(
                              0.3,
                            ), // Light blue border
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.archive_outlined,
                                color:
                                    darkBlue, // Dark blue icon (Constant branding)
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thank you for helping!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            darkBlue, // Dark blue text (Constant branding)
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Your report will help reunite someone with their lost item',
                                      style: TextStyle(
                                        color: darkBlue.withOpacity(
                                          0.8,
                                        ), // Slightly lighter dark blue text
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Item Name ---
                      _buildLabel('Item Name', textColor),
                      _buildInputField(
                        controller: _itemNameController,
                        hintText: 'e.g., iPhone 15, Blue Backpack',
                        validatorText: 'Item name is required.',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 20),

                      // --- Category Dropdown ---
                      _buildLabel('Category', textColor),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: inputFillColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          hint: Text(
                            'Select a category',
                            style: TextStyle(color: inputHintColor),
                          ),
                          dropdownColor: cardColor,
                          style: TextStyle(color: textColor),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Category is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Color ---
                      _buildLabel('Color/Distinguishing Mark', textColor),
                      _buildInputField(
                        controller: _colorController,
                        hintText: 'e.g., Red, Black with a sticker',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 20),

                      // --- Date Found ---
                      _buildLabel('Date Found', textColor),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: inputFillColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: inputHintColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _selectedDate == null
                                    ? 'Select the date you found it'
                                    // Use DateFormat for a cleaner date display
                                    : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? inputHintColor
                                      : textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Upload Image Section (Now displays image) ---
                      _buildLabel('Upload Image', textColor),
                      GestureDetector(
                        onTap: _openImageUploadScreen, // Use the new function
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? inputFillColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: primaryBlue, // Bright blue border
                              width: 1.5,
                            ),
                          ),
                          child: _uploadedImageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    _uploadedImageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: primaryBlue,
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildImagePlaceholder(
                                        inputHintColor,
                                        'Error loading image. Tap to retry upload.',
                                      );
                                    },
                                  ),
                                )
                              : _buildImagePlaceholder(
                                  inputHintColor,
                                  'Clear photo helps identification',
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Description ---
                      _buildLabel('Description', textColor),
                      _buildInputField(
                        controller: _descriptionController,
                        hintText: 'Describe the item you found...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 20),

                      // --- Where did you find it? ---
                      _buildLabel('Where did you find it?', textColor),
                      _buildInputField(
                        controller: _locationController,
                        hintText: 'e.g., Cafeteria Entrance',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 40),

                      // **MODIFICATION:** Removed Checkboxes section

                      // --- Submit Report Button (Blue Gradient) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style:
                            ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              // Transparent background is needed for the Ink widget's gradient
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                              side: WidgetStateProperty.all(BorderSide.none),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 18),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryBlue, darkBlue], // Blue shades
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

  Widget _buildLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isDarkMode,
    String? validatorText,
    IconData? icon,
    int maxLines = 1,
  }) {
    final Color inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color inputHintColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey;
    final Color inputTextColor = isDarkMode ? Colors.white : Colors.black;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: inputTextColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: inputHintColor),
        prefixIcon: icon != null ? Icon(icon, color: inputHintColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: inputFillColor,
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

  // New helper for the image upload placeholder
  Widget _buildImagePlaceholder(Color inputHintColor, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.upload_outlined,
          size: 40,
          color: primaryBlue, // Bright blue icon
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload Photo',
          style: TextStyle(
            color: darkBlue, // Dark blue text
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: TextStyle(
            color: _uploadedImageUrl != null
                ? darkBlue
                : inputHintColor, // Dynamic hint color
          ),
        ),
      ],
    );
  }

  // **MODIFICATION:** Removed _buildCheckboxCard as it is no longer used
}
