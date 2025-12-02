import 'package:flutter/material.dart';
// Ensure 'supabase_reports_problems.dart' contains the SupabaseReportService
import 'package:tracelink/supabase_reports_problems.dart';

// Placeholder screen imports - ensure these files exist
import 'notifications.dart'; // Assume this contains NotificationsScreen
import 'user_contacting_admin.dart'; // Assume this contains ContactAdminDialog
import 'item_description.dart';

// --- Data Model (Report) ---
class Report {
  final String title;
  final String itemId;

  const Report({required this.title, required this.itemId});

  // Factory constructor to create a Report from Supabase data map
  factory Report.fromSupabase(Map<String, dynamic> data) {
    return Report(
      title: data['Title'] ?? 'No Title',
      itemId: data['Item Name'] ?? 'N/A',
    );
  }

  // Utility method to create a copy with a new status (kept for completeness)
  Report copyWith({String? status}) {
    return Report(title: title, itemId: itemId);
  }
}

// --- StatefulWidget for state management and async data fetching ---
class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  // State variables moved to the State class
  List<Report> _reports = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Call the fetch method on initialization
  }

  // Method to fetch data from Supabase (UPDATED to include Claims and Reports)
  Future<void> _fetchItems() async {
    // Check if the State object is currently in the tree
    if (!mounted) return;

    // Set loading state (assuming initial state is already set)
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 4. Fetch Reports (NEW)
      final reportsData = await SupabaseReportService.fetchReports();
      final fetchedReports = reportsData
          .map((data) => Report.fromSupabase(data))
          .toList();

      if (mounted) {
        setState(() {
          _reports = fetchedReports; // Update state
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        // Access context safely after checking `mounted`
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data. Check console.')),
        );
      }
      // In a real app, you'd log this error
      debugPrint('Error fetching items/claims/reports from Supabase: $e');
    }
  }

  // Function to navigate to a new screen
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // Function to navigate back or replace the current screen
  void _goBack(BuildContext context) {
    // Use pushReplacement to replace the current screen in the navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;

    // Optional: Show loading/error state
    Widget content;
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error loading warnings.'),
            ElevatedButton(
              onPressed: _fetchItems,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else if (_reports.isEmpty) {
      content = const Center(child: Text('No active warnings from the admin.'));
    } else {
      // Main screen content (list of reports could be displayed here,
      // but the current UI is static, focusing on a single warning)
      // I'll wrap the existing UI to include the dynamic data fetch result check.
      content = _buildWarningContent(screenWidth);
    }

    return Scaffold(
      // The back button gesture detector is a good place to handle navigation
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- Top Header Section ---
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 15,
                right: 15,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _goBack(context), // Back button to notifications.dart
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white),
                          SizedBox(width: 8),
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Warning Notice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Important message from admin',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Display the main content (loading/error or the warning UI)
            _isLoading || _hasError
                ? Padding(padding: const EdgeInsets.all(20.0), child: content)
                : _buildWarningContent(screenWidth),
          ],
        ),
      ),
    );
  }

  // Extracted main content into a separate method for clarity
  Widget _buildWarningContent(double screenWidth) {
    // For this static screen, we'll assume the first report is the one being displayed
    // In a real app, you might pass the Report object to this screen.
    final displayedReportTitle = _reports.isNotEmpty
        ? _reports.first.title
        : 'Set of Keys';

    final displayedItemId = _reports.isNotEmpty ? _reports.first.itemId : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Admin Warning Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFFE082)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 30),

          // Admin Warning Card
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Admin Warning',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFFDE7),
                          Colors.orange.shade50,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Admin has issued a warning regarding ',
                          ),
                          TextSpan(
                            text: displayedReportTitle,
                            style: const TextStyle(
                              color: Color(0xFFFF5252),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please cooperate and return the item to its rightful owner. Failure to do so may result in further action.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // "View Item Details" Button
          Container(
            width: screenWidth * 0.9,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _navigateTo(
                  context,
                  ItemDetailScreen(itemName: displayedItemId),
                ), // To item_detail.dart
                borderRadius: BorderRadius.circular(30),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'View Item Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // --- Action Buttons and Footer ---
          SizedBox(
            width: screenWidth * 0.9,
            height: 60,
            child: ElevatedButton(
              onPressed: () => _navigateTo(
                context,
                const ContactAdminDialog(),
              ), // To contact_admin.dart
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Contact Admin',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          SizedBox(
            width: screenWidth * 0.9,
            height: 60,
            child: ElevatedButton(
              onPressed: () => _goBack(context), // Back to notifications.dart
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: const Text(
                'I Understand',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Footer Message
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'If you have any questions or concerns, please contact the admin or respond through the chat system.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
