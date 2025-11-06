import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen
import 'upload_image.dart';

class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({super.key});

  @override
  State<ReportFoundItemScreen> createState() => _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State for checkboxes
  bool _reportAnonymously = false;
  bool _leftWithSecurity = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitReport() {
    // Basic validation check for required fields
    if (_formKey.currentState!.validate()) {
      // If validation passes, show the submission message popup
      _showSubmissionMessage();
    }
  }

  // Function to show the submission success message dialog
  void _showSubmissionMessage() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap OK to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 8),
              Text('Thank You!'),
            ],
          ),
          content: const Text(
            'Your report has been submitted. We appreciate your help!',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to home.dart after closing the dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Greenish Gradient) ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            automaticallyImplyLeading: false, // Handle back button custom
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Greenish gradient
                gradient: LinearGradient(
                  colors: [Color(0xFF28B463), Color(0xFF229954)],
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
                      // --- Thank you Card ---
                      Card(
                        elevation: 0,
                        color: Colors.green.shade50.withOpacity(
                          0.5,
                        ), // Light greenish background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.green.shade100,
                            width: 1,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.archive_outlined,
                                color: Colors.green,
                                size: 30,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Thank you for helping!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Your report will help reunite someone with their lost item',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Upload Image Section ---
                      _buildLabel('Upload Image'),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadPhotosScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors
                                .transparent, // Background of photo upload seems transparent
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.green.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_outlined,
                                size: 40,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Photo',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Clear photo helps identification',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Description ---
                      _buildLabel('Description'),
                      _buildInputField(
                        controller: _descriptionController,
                        hintText: 'Describe the item you found...',
                        maxLines: 4,
                        validatorText: 'Description is required.',
                      ),
                      const SizedBox(height: 20),

                      // --- Where did you find it? ---
                      _buildLabel('Where did you find it?'),
                      _buildInputField(
                        controller: _locationController,
                        hintText: 'e.g., Cafeteria Entrance',
                        icon: Icons.location_on_outlined,
                        validatorText: 'Location is required.',
                      ),
                      const SizedBox(height: 20),

                      // --- Report Anonymously Checkbox ---
                      _buildCheckboxCard(
                        title: 'Report anonymously',
                        subtitle: 'Your identity will remain private',
                        value: _reportAnonymously,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _reportAnonymously = newValue ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- Left with campus security Checkbox ---
                      _buildCheckboxCard(
                        title: 'Left with campus security',
                        subtitle:
                            'Item has been turned in to campus guard/security',
                        value: _leftWithSecurity,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _leftWithSecurity = newValue ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 40),

                      // --- Submit Report Button (Green Gradient) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style:
                            ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              // Green gradient
                              backgroundColor:
                                  Colors.transparent, // Required for gradient
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                              side: MaterialStateProperty.all(BorderSide.none),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 18),
                              ),
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
                                Color(0xFF28B463),
                                Color(0xFF229954),
                              ], // Green shades
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(minHeight: 50.0),
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

  Widget _buildCheckboxCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white, // Ensure card background is white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.green, // Checkbox color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
