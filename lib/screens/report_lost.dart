// report_lost.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'upload_image.dart';
import 'ai_generated.dart';

import '../theme_provider.dart';

import 'bottom_navigation.dart';

// --- Global Supabase Client Access ---
// Assuming the client is initialized in main.dart and accessible globally
final supabase = Supabase.instance.client;

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
  int _selectedIndex = 0;

  // --- Dropdown State & Data ---
  String? _selectedCategory;
  final List<String> _categories = const [
    'Electronics',
    'Wallet/ID',
    'Clothing',
    'Keys',
    'Book/Stationery',
    'Other',
  ];

  // --- Controllers ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // --- State Variables ---
  DateTime? _selectedDate;
  String? _uploadedImageUrl;

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green,
    Colors.pink,
    Colors.orange,
    Color(0xFF00008B),
    Colors.purple,
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, Color primaryColor) async {
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

  // --- Supabase Submission Logic ---
  void _submitReport() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields and select a Category.',
          ),
        ),
      );
      return;
    }

    // Indicate submission is starting (Optional: Show a loading indicator)

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
        'Status': 'lost', // Default status for a lost report
        // Use ?? 'anonymous' if the user might not be logged in, otherwise just null/omitted
        'User Id': supabase.auth.currentUser?.id,
      };

      // 2. Insert data into the 'lost_items' table
      final response = await supabase
          .from('Lost_Items') // Ensure this table name is correct
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
        errorMessage: 'Submission Failed. Check network connection.',
      );
    }
  }

  void _showSubmissionMessage({required bool isSuccess, String? errorMessage}) {
    final isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    final primaryColor = isSuccess
        ? (isDarkMode ? darkPrimaryBlue : basePrimaryBlue)
        : Colors.red;
    final titleColor = isDarkMode ? darkDarkBlue : baseDarkBlue;
    final contentColor = Theme.of(context).textTheme.bodyLarge?.color;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.done_all : Icons.error_outline,
                color: primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                isSuccess ? 'Report Received!' : 'Submission Failed',
                style: TextStyle(color: titleColor),
              ),
            ],
          ),
          content: Text(
            isSuccess
                ? 'Your lost item report has been submitted successfully.'
                : errorMessage ??
                      'An unexpected error occurred during submission.',
            style: TextStyle(color: contentColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (isSuccess) {
                  // Navigate back to the Home screen on success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
                  );
                }
              },
              child: Text('OK', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // --- Build Method and Helper Widgets ---

  @override
  Widget build(BuildContext context) {
    // 1. ACCESS THEME STATE & COLORS
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final theme = Theme.of(context);

    // 2. DEFINE DYNAMIC COLORS BASED ON MODE
    final primaryBlue = isDarkMode ? darkPrimaryBlue : basePrimaryBlue;
    final darkBlue = isDarkMode ? darkDarkBlue : baseDarkBlue;
    // Input field background color
    final inputFieldBackground = isDarkMode
        ? darkInputBackground
        : baseLightBlueBackground;
    final screenBackground = theme.scaffoldBackgroundColor;
    final textColor =
        theme.textTheme.bodyLarge?.color ??
        (isDarkMode ? Colors.white : Colors.black);

    final bool imageIsUploaded = _uploadedImageUrl != null;
    final String uploadButtonLabel = imageIsUploaded
        ? 'Change Photo'
        : 'Upload Photo';

    return Scaffold(
      backgroundColor: screenBackground,
      body: CustomScrollView(
        slivers: [
          // --- Header Section ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(color: primaryBlue),
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
                          // Back Arrow Button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavScreen(),
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
                        context,
                        controller: _itemNameController,
                        hintText: 'e.g., Black Wallet',
                        validatorText: 'Item Name is required.',
                        darkBlue: darkBlue,
                        inputFieldBackground: inputFieldBackground,
                      ),
                      const SizedBox(height: 16),

                      // --- Category (Dropdown style) ---
                      _buildLabel('Category', textColor),
                      _buildCategoryDropdown(
                        darkBlue: darkBlue,
                        inputFieldBackground: inputFieldBackground,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 16),

                      // --- Color ---
                      _buildLabel('Color', textColor),
                      _buildInputField(
                        context,
                        controller: _colorController,
                        hintText: 'e.g., Black, Blue, Brown',
                        validatorText: 'Color is required.',
                        darkBlue: darkBlue,
                        inputFieldBackground: inputFieldBackground,
                      ),
                      const SizedBox(height: 16),

                      // --- Description ---
                      _buildLabel('Description', textColor),
                      _buildInputField(
                        context,
                        controller: _descriptionController,
                        hintText: 'Provide details about your item...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                        darkBlue: darkBlue,
                        inputFieldBackground: inputFieldBackground,
                      ),
                      const SizedBox(height: 16),

                      // --- Last Seen Location ---
                      _buildLabel('Last Seen Location', textColor),
                      _buildInputField(
                        context,
                        controller: _locationController,
                        hintText: 'e.g., Library, 2nd Floor',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                        darkBlue: darkBlue,
                        inputFieldBackground: inputFieldBackground,
                      ),
                      const SizedBox(height: 16),

                      // --- Date Lost ---
                      _buildLabel('Date Lost', textColor),
                      GestureDetector(
                        onTap: () => _selectDate(context, primaryBlue),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: inputFieldBackground,
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
                              Icon(Icons.keyboard_arrow_down, color: darkBlue),
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
                          inputFieldBackground,
                        ),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          // Upload Photo Button
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
                            inputFieldBackground: inputFieldBackground,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(width: 16),
                          // AI Generate Button
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
                            inputFieldBackground: inputFieldBackground,
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
                        style: TextStyle(color: darkBlue),
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button ---
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

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    String? validatorText,
    IconData? icon,
    int maxLines = 1,
    required Color darkBlue,
    required Color inputFieldBackground,
  }) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: darkBlue.withOpacity(0.6)),
        prefixIcon: icon != null ? Icon(icon, color: darkBlue) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: inputFieldBackground,
        contentPadding: EdgeInsets.symmetric(
          vertical: (maxLines > 1 ? 12 : 0) + 8.0,
          horizontal: 10.0,
        ),
      ),
      validator: (value) {
        if (validatorText != null && (value == null || value.trim().isEmpty)) {
          return validatorText;
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown({
    required Color darkBlue,
    required Color inputFieldBackground,
    required Color textColor,
  }) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: 'Select category',
        hintStyle: TextStyle(color: darkBlue.withOpacity(0.6)),
        prefixIcon: Icon(Icons.category_outlined, color: darkBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: inputFieldBackground,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 10.0,
        ),
      ),
      icon: Icon(Icons.keyboard_arrow_down, color: darkBlue),
      isExpanded: true,
      dropdownColor: inputFieldBackground,
      items: _categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a category.' : null,
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    required Color darkBlue,
    required Color inputFieldBackground,
    required bool isDarkMode,
  }) {
    final Color color = darkBlue;
    final Color backgroundColor = isPrimary
        ? inputFieldBackground
        : (isDarkMode ? darkInputBackground : Colors.white);
    final Color borderColor = darkBlue;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1.5),
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
    Color inputFieldBackground,
  ) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: inputFieldBackground,
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
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: darkBlue),
                Text(
                  'Image Preview Failed. Check URL/Path.',
                  style: TextStyle(color: darkBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
