<<<<<<< HEAD
import 'package:flutter/material.dart';
// Import all destination screens (required for the navigation bar to work)
import 'messages.dart';
import 'profile_page.dart';
import 'community_feed.dart';
import 'search_lost.dart';
import 'home.dart'; // Import the original Home.dart screen

// Define the new color palette based on the request
const Color _brightBlue = Color(0xFF1E88E5); // Bright Blue for header/buttons
const Color _lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue for body background
const Color _darkBlueText = Color(
  0xFF0D47A1,
); // Dark Blue for text on light background
const Color _warningRed = Color(
  0xFFC70039,
); // Retaining a dark red for warnings

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

  // --- Bottom Navigation State and Logic ---
  // Assuming 'Report a Problem' screen is NOT part of the 5 main tabs,
  // but we will keep the index set to 0 (Home) for visual consistency if the user
  // navigates to the Home tab later.
  int _selectedIndex = 0; // Set to 0 (Home) as the fallback index

  // List of screens to navigate to from the bottom bar
  final List<Widget> _screens = [
    const HomeScreen(), // 0: Home
    const SearchLost(), // 1: Browse/Search
    const CommunityFeed(), // 2: Feed
    const MessagesListScreen(), // 3: Chat
    const ProfileScreen(), // 4: Profile
  ];

  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _navigateToScreen(BuildContext context, Widget screen) {
    // This is used for navigating to the screens from the bottom bar
    // It replaces the current screen with the new destination.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    // We use pushReplacement to swap the main content screen without stacking them
    // on top of each other every time a tab is pressed.
    _navigateToScreen(context, _screens[index]);
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    // The current screen is ReportProblem, which is not in the list.
    // We keep the Home icon active as the current screen is usually accessed
    // from the Home Screen.
    return index == 0 ? _navItemColors[0] : Colors.grey;
  }
  // --- END Bottom Navigation State and Logic ---

  @override
  void dispose() {
    _usernameController.dispose();
    _itemController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
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
              Icon(Icons.check_circle, color: _brightBlue),
              SizedBox(width: 8),
              Text('Success!', style: TextStyle(color: _darkBlueText)),
            ],
          ),
          content: const Text(
            'Report submitted successfully! Admin will review it.',
            style: TextStyle(color: _darkBlueText),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Clear the form fields
                _formKey.currentState!.reset();
                _usernameController.clear();
                _itemController.clear();
                _descriptionController.clear();
              },
              child: const Text('OK', style: TextStyle(color: _brightBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the overall background to light blue
      backgroundColor: _lightBlueBackground,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Bright Blue Theme) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Use the bright blue for the header with a slight gradient
                gradient: LinearGradient(
                  colors: [
                    _brightBlue,
                    Color(0xFF42A5F5),
                  ], // Bright Blue with a variation
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
                          // Back Arrow Button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors
                                  .white, // White text/icon on bright blue
                            ),
                            onPressed: () {
                              // Functionality to open home.dart using pushReplacement
                              // so the user can use the bottom navigation on the home screen
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
                              color: Colors.white, // White text on bright blue
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Help us keep the community safe and fair',
                        style: TextStyle(
                          color: Colors
                              .white70, // Slightly faded white for subtext
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Form Content Section (Light Blue Background) ---
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
                                    color: _warningRed,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Report User Misconduct',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _darkBlueText,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                          color: _lightBlueBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _brightBlue.withOpacity(0.5),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: _warningRed,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please only submit genuine reports. False reports may result in action against your account.',
                                style: TextStyle(
                                  color: _darkBlueText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Submit Report Button (Bright Blue Theme) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: _brightBlue,
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
      // --- Bottom Navigation Bar ---
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
        // The selected index is always 0 (Home) on this screen
        currentIndex: _selectedIndex,
        // The selected item color is determined by the specific color list
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
      // Ensure the text input itself is dark blue
      style: const TextStyle(color: _darkBlueText),
      decoration: InputDecoration(
        hintText: hintText,
        // Icons should be dark blue or grey on the light background
        prefixIcon: Icon(icon, color: _darkBlueText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor:
            Colors.white, // White fill for text fields on light blue background
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
=======
import 'package:flutter/material.dart';
// Import all destination screens (required for the navigation bar to work)
import 'messages.dart';
import 'profile_page.dart';
import 'community_feed.dart';
import 'search_lost.dart';
import 'home.dart'; // Import the original Home.dart screen

// Define the new color palette based on the request
const Color _brightBlue = Color(0xFF1E88E5); // Bright Blue for header/buttons
const Color _lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue for body background
const Color _darkBlueText = Color(
  0xFF0D47A1,
); // Dark Blue for text on light background
const Color _warningRed = Color(
  0xFFC70039,
); // Retaining a dark red for warnings

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

  // --- Bottom Navigation State and Logic ---
  // Assuming 'Report a Problem' screen is NOT part of the 5 main tabs,
  // but we will keep the index set to 0 (Home) for visual consistency if the user
  // navigates to the Home tab later.
  int _selectedIndex = 0; // Set to 0 (Home) as the fallback index

  // List of screens to navigate to from the bottom bar
  final List<Widget> _screens = [
    const HomeScreen(), // 0: Home
    const SearchLost(), // 1: Browse/Search
    const CommunityFeed(), // 2: Feed
    const MessagesListScreen(), // 3: Chat
    const ProfileScreen(), // 4: Profile
  ];

  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  void _navigateToScreen(BuildContext context, Widget screen) {
    // This is used for navigating to the screens from the bottom bar
    // It replaces the current screen with the new destination.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    // We use pushReplacement to swap the main content screen without stacking them
    // on top of each other every time a tab is pressed.
    _navigateToScreen(context, _screens[index]);
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    // The current screen is ReportProblem, which is not in the list.
    // We keep the Home icon active as the current screen is usually accessed
    // from the Home Screen.
    return index == 0 ? _navItemColors[0] : Colors.grey;
  }
  // --- END Bottom Navigation State and Logic ---

  @override
  void dispose() {
    _usernameController.dispose();
    _itemController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
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
              Icon(Icons.check_circle, color: _brightBlue),
              SizedBox(width: 8),
              Text('Success!', style: TextStyle(color: _darkBlueText)),
            ],
          ),
          content: const Text(
            'Report submitted successfully! Admin will review it.',
            style: TextStyle(color: _darkBlueText),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Clear the form fields
                _formKey.currentState!.reset();
                _usernameController.clear();
                _itemController.clear();
                _descriptionController.clear();
              },
              child: const Text('OK', style: TextStyle(color: _brightBlue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the overall background to light blue
      backgroundColor: _lightBlueBackground,
      body: CustomScrollView(
        slivers: [
          // --- Header Section (Bright Blue Theme) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Use the bright blue for the header with a slight gradient
                gradient: LinearGradient(
                  colors: [
                    _brightBlue,
                    Color(0xFF42A5F5),
                  ], // Bright Blue with a variation
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
                          // Back Arrow Button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors
                                  .white, // White text/icon on bright blue
                            ),
                            onPressed: () {
                              // Functionality to open home.dart using pushReplacement
                              // so the user can use the bottom navigation on the home screen
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
                              color: Colors.white, // White text on bright blue
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Help us keep the community safe and fair',
                        style: TextStyle(
                          color: Colors
                              .white70, // Slightly faded white for subtext
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Form Content Section (Light Blue Background) ---
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
                                    color: _warningRed,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Report User Misconduct',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _darkBlueText,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _darkBlueText,
                                ),
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
                          color: _lightBlueBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _brightBlue.withOpacity(0.5),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: _warningRed,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please only submit genuine reports. False reports may result in action against your account.',
                                style: TextStyle(
                                  color: _darkBlueText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Submit Report Button (Bright Blue Theme) ---
                      ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: _brightBlue,
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
      // --- Bottom Navigation Bar ---
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
        // The selected index is always 0 (Home) on this screen
        currentIndex: _selectedIndex,
        // The selected item color is determined by the specific color list
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
      // Ensure the text input itself is dark blue
      style: const TextStyle(color: _darkBlueText),
      decoration: InputDecoration(
        hintText: hintText,
        // Icons should be dark blue or grey on the light background
        prefixIcon: Icon(icon, color: _darkBlueText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor:
            Colors.white, // White fill for text fields on light blue background
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
>>>>>>> 6ab63f62a024b9d7eb22240c0a0c2d3890c511c1
