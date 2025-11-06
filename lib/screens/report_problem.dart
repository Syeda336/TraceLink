import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen

class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblem> {
  // Global key to uniquely identify the form and enable validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers for the input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _itemController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitReport() {
    // Validate all fields in the form
    if (_formKey.currentState!.validate()) {
      // If validation passes, show the success message popup
      _showSuccessDialog();
    }
  }

  // Function to show the success message dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success!'),
            ],
          ),
          content: const Text(
            'Report submitted successfully! Admin will review it.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally clear the form or navigate away
                _formKey.currentState!.reset();
                _usernameController.clear();
                _itemController.clear();
                _descriptionController.clear();
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
          // --- Header Section ---
          SliverAppBar(
            pinned: true,
            toolbarHeight: 150, // Adjusted height for the header content
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Gradient similar to the image
                gradient: LinearGradient(
                  colors: [Color(0xFFFF5200), Color(0xFFE50914)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 16.0,
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
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Report a Problem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Help us keep the community safe and fair',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card: Report User Misconduct
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Icon
                              const Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Report User Misconduct',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Let us know if someone isn\'t cooperating',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),

                              // Username or ID Field
                              const Text(
                                'Username or ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildInputField(
                                controller: _usernameController,
                                hintText: 'e.g., john_doe or STU123456',
                                icon: Icons.person_outline,
                                validatorText: 'Username or ID is required.',
                              ),
                              const SizedBox(height: 16),

                              // Item Name or ID Field
                              const Text(
                                'Item Name or ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildInputField(
                                controller: _itemController,
                                hintText: 'e.g., Black Wallet',
                                icon: Icons.inventory_2_outlined,
                                validatorText: 'Item Name or ID is required.',
                              ),
                              const SizedBox(height: 16),

                              // Description of Issue Field
                              const Text(
                                'Description of Issue',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildInputField(
                                controller: _descriptionController,
                                hintText:
                                    'Describe what happened and why you\'re reporting this user...',
                                icon: Icons.description_outlined,
                                maxLines: 4,
                                validatorText: 'Description is required.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Warning Box ---
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFC70039),
                            ), // Dark red/orange
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please only submit genuine reports. False reports may result in action against your account.',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Submit Report Button ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          // Gradient similar to the image
                          backgroundColor: const Color(0xFFFF5200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Submit Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  // Helper function to build the custom TextFormField widgets
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String validatorText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
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
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }
}
