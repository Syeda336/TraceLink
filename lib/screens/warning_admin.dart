import 'package:flutter/material.dart';
import '../supabase_reports_problems.dart';
import 'warning_item.dart'; // Contains ItemDetailScreen (Assumed)
import 'notifications.dart';
// Assuming this import contains ContactAdminDialog
import 'user_contacting_admin.dart';

// ---------------------------------------------
// --- DATA MODEL (Report) ---
// ---------------------------------------------
class Report {
  final int id;
  final String title;
  final String itemId; // The ID/Name of the reported item (String)

  const Report({required this.title, required this.itemId, required this.id});

  // Factory constructor to create a Report from Supabase data map
  factory Report.fromSupabase(Map<String, dynamic> data) {
    return Report(
      title: data['Title'] as String? ?? 'No Title',
      // Assuming 'Item Name' holds the item identifier string
      itemId: data['Item Name'] as String? ?? 'N/A',
      // Ensure the ID is correctly parsed as an integer
      id: data['id'] is int
          ? data['id']
          : int.tryParse(data['id']?.toString() ?? '0') ?? 0,
    );
  }

  // Renamed copyWith parameter for clarity (though not strictly necessary here)
  Report copyWith({String? status}) {
    return Report(title: title, itemId: itemId, id: id);
  }
}

// ---------------------------------------------
// --- WARNING SCREEN IMPLEMENTATION (CORRECTED) ---
// ---------------------------------------------
class WarningScreen extends StatefulWidget {
  // FIX 1: The constructor must accept a nullable int (int?)
  // because it might be called from notifications with a missing ID,
  // though the fetching logic below requires a non-null ID.
  // Given your current fetching logic, we'll keep it as non-nullable 'int'
  // but rely on the calling code to ensure it's a valid ID.
  // If the previous code sent 'null', the calling screen must be fixed.
  final int reportId;

  const WarningScreen({super.key, required this.reportId});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  Report? _report;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchItemById(widget.reportId);
  }

  Future<void> _fetchItemById(int id) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Assuming SupabaseReportService.fetchReports() returns a List<Map<String, dynamic>>
      final reportsData = await SupabaseReportService.fetchReports();

      // Find the specific report based on the passed ID
      final reportMap = reportsData.firstWhere(
        (data) => data['id'] == id,
        orElse: () => throw Exception('Report not found with ID: $id'),
      );

      final fetchedReport = Report.fromSupabase(reportMap);

      if (mounted) {
        setState(() {
          _report = fetchedReport;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load specific report data.')),
        );
      }
      debugPrint(
        'Error fetching report (ID: ${widget.reportId}) from Supabase: $e',
      );
    }
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _goBack(BuildContext context) {
    // Navigate back to the notifications screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  // Extracted main content into a separate method for clarity
  Widget _buildWarningContent(double screenWidth) {
    if (_report == null) {
      return const Center(child: Text('Report not found or failed to load.'));
    }

    // Get the non-nullable Report object
    final Report report = _report!;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Admin Warning',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // ...
          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [const Color(0xFFFFFDE7), Colors.orange.shade50],
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
                  const TextSpan(text: 'Admin has issued a warning regarding '),
                  TextSpan(
                    text: report.title,
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
                  // Pass the item's unique identifier (String itemId)
                  ItemDetailScreen(id: report.itemId),
                ),
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
              // 💡 FIX 4: Correctly pass the non-nullable reportId and reportTitle
              // from the successfully loaded '_report' object.
              onPressed: () => _navigateTo(
                context,
                ContactAdminDialog(
                  reportId: report.id,
                  reportTitle: report.title,
                ),
              ),
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
              onPressed: () => _goBack(context),
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
          // ...
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
              onPressed: () => _fetchItemById(widget.reportId),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else if (_report == null) {
      // This is reached if report is not found/orElse in fetchReports
      content = Center(
        child: Text('No warning found for ID: ${widget.reportId}.'),
      );
    } else {
      content = _buildWarningContent(screenWidth);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- Top Header Section --- (omitted for brevity)
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
                      onTap: () => _goBack(context),
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
                    const SizedBox(height: 10),
                    Text(
                      'Report ID: ${widget.reportId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Display the main content (loading/error or the warning UI)
            _isLoading || _hasError || _report == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(child: content),
                  )
                : content,
          ],
        ),
      ),
    );
  }
}
