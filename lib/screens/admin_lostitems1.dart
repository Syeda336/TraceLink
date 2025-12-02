import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'package:tracelink/supabase_lost_service.dart';

import 'package:tracelink/supabase_found_service.dart';
import 'admin_logout.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../notifications_service.dart';

import 'package:tracelink/supabase_claims_service.dart';
import 'package:tracelink/supabase_reports_problems.dart';

// -----------------------------------------------------------------------------
// DATA MODELS (UPDATED)
// -----------------------------------------------------------------------------
class Item {
  final String title;
  final String description;
  final String reportedBy;
  final String imageUrl;
  final String status; // 'Lost', 'Found', 'Returned'

  final String category;
  final String date;
  final String location;
  final String contact;
  final int uniqueId; // Added a unique identifier for deletion

  const Item({
    required this.title,
    required this.description,
    required this.reportedBy,
    required this.imageUrl,
    required this.status,
    this.category = 'N/A',
    this.date = 'N/A',
    this.location = 'N/A',
    this.contact = 'N/A',
    required this.uniqueId, // Default value
  });

  // Factory constructor to create an Item from Supabase data map
  factory Item.fromSupabase(Map<String, dynamic> data, String statusType) {
    final reporterName = data['User Name'] ?? 'Unknown User Name';
    final reporterId = data['User ID'] ?? 'N/A';
    final reportedBy = '$reporterName (ID: $reporterId)';

    return Item(
      title: data['Item Name'] ?? 'No Title',
      description: data['Description'] ?? 'No description provided.',
      reportedBy: reportedBy,
      imageUrl: data['Image'] ?? '',
      status: data['status'] as String? ?? 'Unknown',
      category: data['Category'] ?? 'Uncategorized',
      date: data['Date Lost/Date Found'] ?? 'Unknown Date',
      location: data['Location'] ?? 'Unknown Location',
      contact: 'Admin Contact: 555-1234',
      uniqueId: data['id'] ?? 0,
    );
  }
}

class Claim {
  final String title; // Item Name
  final String claimedBy; // User Name
  final String claimedById; // User ID
  final String
  foundByNotes; // Additional Notes (used to imply who found it, or just claim detail)
  final String contact; // Contact
  final String date; // created_at
  final String uniqueFeatures; // Unique Features
  final String status; // 'Pending', 'Verified', 'Returned'

  final String imageUrl;
  final int uniqueId;

  const Claim({
    required this.title,
    required this.claimedBy,
    required this.claimedById,
    required this.foundByNotes,
    required this.contact,
    required this.date,
    required this.uniqueFeatures,
    required this.status,
    required this.imageUrl,
    required this.uniqueId, // Default value
  });

  // Factory constructor to create a Claim from Supabase data map
  factory Claim.fromSupabase(Map<String, dynamic> data) {
    return Claim(
      title: data['Item Name'] ?? 'No Title',
      claimedBy: data['User Name'] ?? 'Unknown User',
      claimedById: data['User ID'] ?? 'N/A',
      foundByNotes: data['Additional Notes'] ?? 'No notes provided.',
      contact: data['Contact'] ?? 'N/A',
      date: data['created_at']?.toString().split('T').first ?? 'Unknown Date',
      uniqueFeatures: data['Unique Features'] ?? 'None specified',
      status: data['status'] as String? ?? 'Pending',
      imageUrl: data['Image'] ?? '',
      uniqueId: data['id'] ?? 0,
    );
  }

  Claim copyWith({String? status}) {
    return Claim(
      title: title,
      claimedBy: claimedBy,
      claimedById: claimedById,
      foundByNotes: foundByNotes,
      contact: contact,
      date: date,
      uniqueFeatures: uniqueFeatures,
      status: status ?? this.status,
      imageUrl: imageUrl,
      uniqueId: uniqueId,
    );
  }
}

class Report {
  final String title; // Title
  final String reportedUser; // Reported_User_name (Target)
  final String reportedUserId; // Reported_User_ID (Target ID)
  final String reportedBy; // Complaint_User_Name (Reporter)
  final String date; // created_at
  final String status; // 'Pending', 'Resolved'
  final String misconductDetail; // Description
  final String itemId; // Item Name (used as ID/Name)
  //final String reportId; // Added for unique identification/deletion
  final int uniqueId;

  const Report({
    required this.title,
    required this.reportedUser,
    required this.reportedUserId,
    required this.reportedBy,
    required this.date,
    required this.status,
    required this.misconductDetail,
    required this.itemId,
    //required this.reportId,
    required this.uniqueId,
  });

  // Factory constructor to create a Report from Supabase data map
  factory Report.fromSupabase(Map<String, dynamic> data) {
    // Use a combination or an actual unique ID from your Supabase row
    // final uniqueId = data['id'] ?? 0;

    return Report(
      title: data['Title'] ?? 'No Title',
      reportedUser: data['Complaint_User_name'] ?? 'Unknown User',
      reportedUserId: data['Reported_User_ID'] ?? 'N/A',
      reportedBy: data['Reported_User_name'] ?? 'Unknown Reporter',
      date: data['created_at']?.toString().split('T').first ?? 'Unknown Date',
      status: data['status'] as String? ?? 'Pending', // Assumed status column
      misconductDetail: data['Description'] ?? 'No details provided.',
      itemId: data['Item Name'] ?? 'N/A',
      uniqueId: data['id'] ?? 0, // Using Item Name as a mock ID for now
    );
  }

  // Utility method to create a copy with a new status
  Report copyWith({String? status}) {
    return Report(
      title: title,
      reportedUser: reportedUser,
      reportedUserId: reportedUserId,
      reportedBy: reportedBy,
      date: date,
      status: status ?? this.status,
      misconductDetail: misconductDetail,
      itemId: itemId,
      //reportId: reportId,
      uniqueId: uniqueId,
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER METHODS (UNCHANGED)
// -----------------------------------------------------------------------------

void _navigateToScreen(BuildContext context, Widget screen) {
  // Use push for regular screen navigation
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => screen, fullscreenDialog: true),
  );
}

Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color color = Colors.blue,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// MAIN DASHBOARD AND SUPPORT WIDGETS
// -----------------------------------------------------------------------------

class AdminDashboard1LostItems extends StatefulWidget {
  const AdminDashboard1LostItems({super.key});

  @override
  State<AdminDashboard1LostItems> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboard1LostItems> {
  // State variables for data and loading
  String _selectedTab = 'Lost';

  // State Lists initialized to empty lists
  List<Item> _lostItems = [];
  List<Item> _foundItems = [];
  List<Claim> _claims = [];
  List<Report> _reports = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  // Method to fetch data from Supabase (UPDATED to include Claims and Reports)
  Future<void> _fetchItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 1. Fetch Lost Items
      final lostData = await SupabaseLostService.fetchLostItems();
      final fetchedLostItems = lostData
          .map((data) => Item.fromSupabase(data, 'Lost'))
          .toList();

      // 2. Fetch Found Items
      final foundData = await SupabaseFoundService.fetchFoundItems();
      final fetchedFoundItems = foundData
          .map((data) => Item.fromSupabase(data, 'Found'))
          .toList();

      // 3. Fetch Claims (NEW)
      final claimsData = await SupabaseClaimService.fetchClaimedItems();
      final fetchedClaims = claimsData
          .map((data) => Claim.fromSupabase(data))
          .toList();

      // 4. Fetch Reports (NEW)
      final reportsData = await SupabaseReportService.fetchReports();
      final fetchedReports = reportsData
          .map((data) => Report.fromSupabase(data))
          .toList();

      if (mounted) {
        setState(() {
          _lostItems = fetchedLostItems;
          _foundItems = fetchedFoundItems;
          _claims = fetchedClaims; // Update state
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data. Check console.')),
        );
      }
      // In a real app, you'd log this error
      debugPrint('Error fetching items/claims/reports from Supabase: $e');
    }
  }

  // Helper method to get user ID from username/email in the report
  Future<String?> _getUserIdFromReport(Report report) async {
    try {
      debugPrint('🔍 Looking up user ID for: ${report.reportedUser}');

      // Query users collection to find the user by their name or email
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: report.reportedUser)
          .limit(1)
          .get();

      // If not found by fullName, try by email
      if (userQuery.docs.isEmpty) {
        userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: report.reportedUser)
            .limit(1)
            .get();
      }

      if (userQuery.docs.isNotEmpty) {
        final userId = userQuery.docs.first.id;
        debugPrint(' Found user ID: $userId for ${report.reportedUser}');
        return userId;
      } else {
        debugPrint(' User not found: ${report.reportedUser}');
        // Fallback: Try to extract from reportedBy if reportedUser is not found
        QuerySnapshot reporterQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('fullName', isEqualTo: report.reportedBy)
            .limit(1)
            .get();

        if (reporterQuery.docs.isNotEmpty) {
          final userId = reporterQuery.docs.first.id;
          debugPrint('✅ Using reporter ID as fallback: $userId');
          return userId;
        }

        return null;
      }
    } catch (e) {
      debugPrint(' Error looking up user ID: $e');
      return null;
    }
  }

  // Updated warn user method with real notification
  void _warnUser(Report report) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final String? targetUserId = await _getUserIdFromReport(report);

    // Hide loading
    Navigator.of(context).pop();

    if (targetUserId != null && targetUserId.isNotEmpty) {
      // Send real notification to the user
      await NotificationsService.sendWarningNotification(
        targetUserId: targetUserId,
        itemTitle: report.title,
        itemId: report.itemId,
        adminMessage:
            'Please return the item immediately to avoid further action.',
      );

      debugPrint('⚠️ Warning notification sent to user: $targetUserId');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Warning sent to ${report.reportedUser}'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } else {
      debugPrint(' Could not find user ID for report');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find user ${report.reportedUser}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }

    // Show the splash screen
    _navigateToScreen(
      context,
      UserWarnedSplash(
        report: report,
        onFinishNavigation: () {
          // Any cleanup after navigation
          // We will resolve the report here.
          _resolveReport(report);
        },
      ),
    );
  }

  // Updated contact user method with real notification
  void _contactUser(Report report) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final String? targetUserId = await _getUserIdFromReport(report);

    // Hide loading
    Navigator.of(context).pop();

    if (targetUserId != null && targetUserId.isNotEmpty) {
      // Send contact notification
      await NotificationsService.addNotification(
        userId: targetUserId,
        title: 'Admin Contact',
        message: 'Administrator has contacted you regarding "${report.title}"',
        type: 'message',
        data: {
          'screen': 'chat',
          'adminContact': true,
          'itemTitle': report.title,
        },
      );

      debugPrint('📧 Contact notification sent to user: $targetUserId');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact message sent to ${report.reportedUser}'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } else {
      debugPrint(' Could not find user ID for report');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find user ${report.reportedUser}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }

    // Show the splash screen
    _navigateToScreen(
      context,
      UserContactedSplash(
        report: report,
        onFinishNavigation: () {
          // Any cleanup after navigation
          // We will resolve the report here.
          _resolveReport(report);
        },
      ),
    );
  }

  // Method to ban user with notification
  void _banUser(Report report) async {
    final String? targetUserId = await _getUserIdFromReport(report);

    if (targetUserId != null && targetUserId.isNotEmpty) {
      // Send ban notification
      await NotificationsService.addNotification(
        userId: targetUserId,
        title: 'Account Suspended',
        message:
            'Your account has been temporarily suspended due to misconduct.',
        type: 'warning',
        data: {'screen': 'warning_admin', 'banReason': report.misconductDetail},
      );

      debugPrint('🔨 Ban notification sent to user: $targetUserId');
    }

    // Navigate to ban confirmation screens
    _navigateToScreen(context, const AdminSplashUserBanned());

    // Resolve the report after the action is initiated
    _resolveReport(report);
  }

  // Method to mark item as returned with notification
  void _markItemReturned(Item item, String claimedByUser) async {
    final String? targetUserId = await _getUserIdFromName(claimedByUser);

    if (targetUserId != null && targetUserId.isNotEmpty) {
      // Send return notification
      await NotificationsService.addNotification(
        userId: targetUserId,
        title: 'Item Returned',
        message: 'Your item "${item.title}" has been marked as returned.',
        type: 'claim',
        data: {
          'itemTitle': item.title,
          'status': 'returned',
          'screen': 'claims',
        },
      );

      debugPrint('✅ Return notification sent to user: $targetUserId');
    }
  }

  // Helper method to get user ID from name (for item returns)
  Future<String?> _getUserIdFromName(String userName) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: userName)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        return userQuery.docs.first.id;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error looking up user by name: $e');
      return null;
    }
  }

  // --- DELETE LOGIC: Reports ---

  // Method to show delete confirmation and send notification
  void _showDeleteConfirmation(Report report, {bool fromDetail = false}) async {
    // IMPORTANT: Check if the context is still valid before showing dialog
    if (!mounted) return;

    _navigateToScreen(
      context,
      AdminDeleteItemMaskScreen(
        itemTitle: report.title,
        onDeleteConfirmed: () async {
          await _deleteReport(report, fromDetail: fromDetail);
        },
      ),
    );
  }

  // Method to delete a report from the list (UPDATED to use _reports)
  Future<void> _deleteReport(Report report, {bool fromDetail = false}) async {
    if (!mounted) return;

    // 1. Delete from Supabase (MOCK)
    try {
      await SupabaseReportService.deleteReport(report.uniqueId as int);
    } catch (e) {
      debugPrint('Error deleting report from Supabase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete report for "${report.title}".'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    // 2. Remove from local state and refresh
    final title = report.title;
    setState(() {
      _reports.removeWhere(
        (r) =>
            r.itemId == report.itemId &&
            r.reportedUserId == report.reportedUserId,
      );
    });
    // Refresh the whole list to ensure UI consistency
    _fetchItems();

    // 3. Close the detail screen if this action was triggered from there
    if (fromDetail && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // 4. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report for "$title" deleted.'),
        backgroundColor: Colors.red.shade600,
      ),
    );

    // 5. Optionally send deletion notification after successful delete
    final String? targetUserId = await _getUserIdFromReport(report);
    if (targetUserId != null) {
      await NotificationsService.addNotification(
        userId: targetUserId,
        title: 'Report Resolved',
        message:
            'The report regarding "${report.title}" has been resolved by admin.',
        type: 'item_update',
        data: {'itemTitle': report.title, 'status': 'resolved'},
      );
    }
  }

  // Method to mark a report as resolved (UPDATED to use _reports)
  void _resolveReport(Report report) {
    if (!mounted) return;
    // Find the index of the report to update
    final index = _reports.indexWhere((r) => r.uniqueId == report.uniqueId);
    if (index != -1) {
      final title = _reports[index].title;
      setState(() {
        // Use copyWith for immutability and clarity
        _reports[index] = _reports[index].copyWith(status: 'Resolved');
      });
      // Close the detail screen if it's currently open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // Show a confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report for "$title" marked as Resolved.'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    }
  }

  // Method to mark a claim as returned (FIXED: Calls fetchItems)
  void _markClaimAsReturned(Claim claim) {
    if (!mounted) return;
    final index = _claims.indexWhere((c) => c.uniqueId == claim.uniqueId);
    if (index != -1) {
      final title = _claims[index].title;
      setState(() {
        _claims[index] = _claims[index].copyWith(status: 'Returned');
      });
      // Refresh item list (or ideally update the specific item)
      _fetchItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claim for "$title" marked as Returned.'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    }
  }

  // --- DELETE LOGIC: Lost Items (FIXED: To use AdminDeleteItemMaskScreen and refresh) ---
  void _deleteLostItem(Item item) async {
    if (!mounted) return;

    // 1. Delete from Supabase (MOCK)
    try {
      await SupabaseLostService.deleteLostItem(item.uniqueId as int);
    } catch (e) {
      debugPrint('Error deleting lost item from Supabase: $e');
      return;
    }

    // 2. Remove from local state
    setState(() {
      _lostItems.removeWhere((i) => i.uniqueId == item.uniqueId);
    });
    // Refresh the whole list
    _fetchItems();

    // 3. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} deleted from Lost Items.'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // --- DELETE LOGIC: Found Items (FIXED: To use AdminDeleteItemMaskScreen and refresh) ---
  void _deleteFoundItem(Item item) async {
    if (!mounted) return;

    // 1. Delete from Supabase (MOCK)
    try {
      await SupabaseFoundService.deleteFoundItem(item.uniqueId as int);
    } catch (e) {
      debugPrint('Error deleting found item from Supabase: $e');
      return;
    }

    // 2. Remove from local state
    setState(() {
      _foundItems.removeWhere((i) => i.uniqueId == item.uniqueId);
    });
    // Refresh the whole list
    _fetchItems();

    // 3. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} deleted from Found Items.'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // --- DELETE LOGIC: Claims (FIXED: To use AdminDeleteItemMaskScreen and refresh) ---
  void _deleteClaim(Claim claim) async {
    if (!mounted) return;

    // 1. Delete from Supabase (MOCK)
    try {
      await SupabaseClaimService.deleteClaimedItem(claim.uniqueId);
    } catch (e) {
      debugPrint('Error deleting claim from Supabase: $e');
      return;
    }

    // 2. Remove from local state
    setState(() {
      _claims.removeWhere((c) => c.uniqueId == claim.uniqueId);
    });
    // Refresh the whole list
    _fetchItems();

    // 3. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Claim for ${claim.title} deleted.'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5);

    List<Widget> contentList = [];

    if (_isLoading) {
      contentList = [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading data from database...'),
              ],
            ),
          ),
        ),
      ];
    } else if (_selectedTab == 'Lost') {
      contentList = _lostItems
          .map(
            (item) => _ItemCard(
              item: item,
              // Use AdminDeleteItemMaskScreen for deletion
              onDelete: () => _navigateToScreen(
                context,
                AdminDeleteItemMaskScreen(
                  itemTitle: item.title,
                  onDeleteConfirmed: () => _deleteLostItem(item),
                ),
              ),
            ),
          )
          .toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(message: 'No lost items reported yet.'),
        );
      }
    } else if (_selectedTab == 'Found') {
      contentList = _foundItems
          .map(
            (item) => _FoundItemCard(
              item: item,
              // Use AdminDeleteItemMaskScreen for deletion
              onDelete: () => _navigateToScreen(
                context,
                AdminDeleteItemMaskScreen(
                  itemTitle: item.title,
                  onDeleteConfirmed: () => _deleteFoundItem(item),
                ),
              ),
            ),
          )
          .toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(message: 'No found items reported yet.'),
        );
      }
    } else if (_selectedTab == 'Claims') {
      contentList = _claims.map((claim) {
        return _GeneralClaimCard(
          claim: claim,
          onMarkReturned: () => _markClaimAsReturned(claim),
          // Use AdminDeleteItemMaskScreen for deletion
          onDelete: () => _navigateToScreen(
            context,
            AdminDeleteItemMaskScreen(
              itemTitle: claim.title,
              onDeleteConfirmed: () => _deleteClaim(claim),
            ),
          ),
        );
      }).toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(
            message: 'No item claims have been submitted yet.',
          ),
        );
      }
    } else if (_selectedTab == 'Reports') {
      contentList = _reports.map((report) {
        return _ReportCard(
          report: report,
          // Report: Delete logic is now in _showDeleteConfirmation
          onDelete: () => _showDeleteConfirmation(report),
          onViewDetail: () {
            _navigateToScreen(
              context,
              AdminViewReportDetail(
                report: report,
                // Pass a flag to indicate the detail screen needs to be popped on delete/resolve
                onDelete: () =>
                    _showDeleteConfirmation(report, fromDetail: true),
                //onResolve: () => _resolveReport(report),
                onWarnUser: () => _warnUser(report),
                onContactUser: () => _contactUser(report),
                onBanUser: () => _banUser(report),
              ),
            );
          },
          onWarnUser: () => _warnUser(report), // Pass _warnUser directly
        );
      }).toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(
            message: 'No user misconduct reports to review.',
          ),
        );
      }
    }

    Widget reportHeader = Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.blue.shade700, size: 28),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Misconduct Reports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                '${_reports.where((r) => r.status == 'Pending').length} pending reports',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          // 1. FIXED HEADER SECTION
          const _HeaderSection(primaryColor: primaryColor),

          // 2. FIXED TAB BAR
          _FixedTabBar(
            selectedTab: _selectedTab,
            onTabSelected: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),

          // 3. SCROLLING ITEM LIST
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchItems,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                children: [
                  if (_selectedTab == 'Claims' && !_isLoading)
                    _ClaimsHeader(claims: _claims),
                  if (_selectedTab == 'Reports' && !_isLoading) reportHeader,
                  ...contentList,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIX: Added static method for context access
  static _AdminDashboardScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<_AdminDashboardScreenState>()!;
  }
}

// NEW STUB SCREEN: USER BANNED (BRIGHT BLUE THEME WITH WHITE TEXT)
class AdminSplashUserBanned extends StatelessWidget {
  const AdminSplashUserBanned({super.key});

  @override
  Widget build(BuildContext context) {
    // Bright blue theme with white text
    Color brightBlue = Colors.lightBlue.shade700;
    Color whiteText = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Banned', style: TextStyle(color: whiteText)),
        backgroundColor: brightBlue,
        iconTheme: IconThemeData(color: whiteText), // Back button icon color
      ),
      backgroundColor: brightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.do_not_disturb_on_outlined, size: 80, color: whiteText),
            const SizedBox(height: 20),
            Text(
              'User Banned Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: whiteText,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the confirmation screen (White theme, Dark Blue text)
                _navigateToScreen(context, const AdminSplashUserBanConfirmed());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteText,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: brightBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NEW STUB SCREEN: USER BAN CONFIRMATION (WHITE THEME WITH DARK BLUE TEXT)
class AdminSplashUserBanConfirmed extends StatelessWidget {
  const AdminSplashUserBanConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    // White theme with dark blue text
    Color whiteBackground = Colors.white;
    Color darkBlueText = Colors.blue.shade900;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ban Confirmed', style: TextStyle(color: darkBlueText)),
        backgroundColor: whiteBackground,
        iconTheme: IconThemeData(color: darkBlueText), // Back button icon color
        elevation: 1,
      ),
      backgroundColor: whiteBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: darkBlueText),
            const SizedBox(height: 20),
            Text(
              'Ban Action Logged and Completed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBlueText,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'The user has been successfully restricted from accessing the platform.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: darkBlueText.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Pop both the Ban Confirmed screen and the Ban splash screen
                // We pop twice because the AdminDashboard calls _navigateToScreen,
                // which pushes the first splash screen. The splash screen then
                // calls _navigateToScreen for the confirmed screen.
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlueText,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Go Back to Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final Color primaryColor;

  const _HeaderSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Admin Dashboard 🛡️',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      // Navigate back to previous screen (assuming main menu)
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminDashboardLogoutConfirmation(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Manage all reports and handle user misconduct',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FixedTabBar extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const _FixedTabBar({required this.selectedTab, required this.onTabSelected});

  Widget _buildTabButton(BuildContext context, String title) {
    bool isSelected = title == selectedTab;
    return InkWell(
      onTap: () => onTabSelected(title),
      borderRadius: BorderRadius.circular(20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            border: isSelected
                ? Border.all(color: Colors.lightBlue.shade300, width: 2)
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.lightBlue.shade700 : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabButton(context, 'Lost'),
          _buildTabButton(context, 'Found'),
          _buildTabButton(context, 'Claims'),
          _buildTabButton(context, 'Reports'),
        ],
      ),
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  final String message;
  const _EmptyStateMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(
              Icons.sentiment_satisfied_alt,
              size: 40,
              color: Colors.black38,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CARD WIDGETS
// -----------------------------------------------------------------------------

class _ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onDelete; // Added for delete functionality

  const _ItemCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color statusColor = item.status == 'Lost'
        ? Colors.red.shade400
        : Colors.blue.shade400;

    String imageUrl = item.imageUrl.isEmpty
        ? 'https://placehold.co/70x70/cccccc/000000?text=N/A'
        : item.imageUrl;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'By: ${item.reportedBy}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'View',
                  onTap: () {
                    // Use a generic ItemDetailScreen
                    _navigateToScreen(
                      context,
                      AdminViewItemDetailScreen(
                        // Pass an Item, or use a new screen for Found/Lost items
                        item: item,
                        isClaim: false,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Return',
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminShowReturnScreen(
                        itemTitle: item.title,
                        onReturnConfirmed: () {
                          // TODO: Implement actual state update for returning item
                          // This would typically involve calling an update API and refreshing the list.
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: Colors.red.shade700,
                  onTap: onDelete, // Use the provided onDelete callback
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FoundItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onDelete; // Added for delete functionality

  const _FoundItemCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const Color statusColor = Colors.green;

    String imageUrl = item.imageUrl.isEmpty
        ? 'https://placehold.co/70x70/cccccc/000000?text=N/A'
        : item.imageUrl;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'By: ${item.reportedBy}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'View',
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminViewItemDetailScreen(item: item, isClaim: false),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Return',
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminShowReturnScreen(
                        itemTitle: item.title,
                        onReturnConfirmed: () {
                          // TODO: Implement actual state update for returning item
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: Colors.red.shade700,
                  onTap: onDelete, // Use the provided onDelete callback
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClaimsHeader extends StatelessWidget {
  final List<Claim> claims;
  const _ClaimsHeader({required this.claims});

  @override
  Widget build(BuildContext context) {
    int pendingCount = claims.where((c) => c.status == 'Pending').length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.lightBlue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_filled,
            color: Colors.lightBlue.shade700,
            size: 28,
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Item Claims',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
          const Spacer(),
          Text(
            '$pendingCount pending claims',
            style: TextStyle(
              fontSize: 16,
              color: Colors.lightBlue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralClaimCard extends StatelessWidget {
  final Claim claim;
  final VoidCallback onMarkReturned;
  final VoidCallback onDelete;

  const _GeneralClaimCard({
    required this.claim,
    required this.onMarkReturned,
    required this.onDelete,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade600;
      case 'Verified':
        return Colors.blue.shade600;
      case 'Returned':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildStatusTag(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  // Refactored: Removed 'Expanded' from here.
  // The caller must wrap this in Expanded if it needs to fill space in a Row/Column.
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final Color primaryColor = color ?? Theme.of(context).primaryColor;

    return TextButton.icon(
      icon: Icon(icon, size: 18, color: primaryColor),
      label: Text(label, style: TextStyle(color: primaryColor)),
      onPressed: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Determine the URL to use. Use final for local variables.
    final String imageUrl = claim.imageUrl;

    // Validate URL using Uri.tryParse().isAbsolute for robustness
    const double imageSize = 70.0;
    final Color placeholderColor = Colors.grey.shade200;

    final bool isUrlValid = Uri.tryParse(imageUrl)?.isAbsolute == true;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 2. Image Widget Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: isUrlValid
                      ? Image.network(
                          imageUrl,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // --- Display error icon on failure ---
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              color: placeholderColor,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            // Optional: Show loading progress indicator
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              color: placeholderColor,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          // --- Display plain container when URL is empty/invalid ---
                          width: imageSize,
                          height: imageSize,
                          color: placeholderColor,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              claim.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusTag(claim.status),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Claimed By: ${claim.claimedBy}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Unique Features: ${claim.uniqueFeatures}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Claim Date: ${claim.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Wrap with Expanded now that _buildActionButton is just a TextButton.icon
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Icons.remove_red_eye_outlined,
                        label: 'View Item',
                        onTap: () {
                          // Navigate to the new detail screen for claims
                          _navigateToScreen(
                            context,
                            AdminViewItemDetailScreen(
                              claim: claim,
                              isClaim: true,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    if (claim.status == 'Pending' || claim.status == 'Verified')
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          icon: Icons.check_circle_outline,
                          label: 'Mark Returned',
                          onTap: () {
                            // Navigate to return screen with the item title
                            _navigateToScreen(
                              context,
                              AdminShowReturnScreen(
                                itemTitle: claim.title,
                                onReturnConfirmed: onMarkReturned,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Fix: Wrap the Delete button in a Row to correctly contain the Expanded child
                if (claim.status != 'Returned')
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          icon: Icons.delete_outline,
                          label: 'Delete Claim',
                          color: Colors.red.shade700,
                          onTap: onDelete, // Use the provided onDelete callback
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onViewDetail;
  final VoidCallback onWarnUser;

  const _ReportCard({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onViewDetail,
    required this.onWarnUser,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.red.shade600;
      case 'Resolved':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // Helper for the action buttons at the bottom
  Widget _buildCardActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: color),
        label: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          side: BorderSide(color: color.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(report.status);

    Widget statusTag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        report.status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                statusTag,
              ],
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Reported User: ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '${report.reportedUser}\n',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const TextSpan(
                    text: 'Reported By: ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextSpan(
                    text: '${report.reportedBy}\n',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  TextSpan(
                    text: report.date,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.pink.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report.misconductDetail,
                      style: TextStyle(
                        color: Colors.pink.shade700,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCardActionButton(
                      context: context,
                      icon: Icons.remove_red_eye_outlined,
                      label: 'View Detail',
                      color: Colors.blue.shade700,
                      onTap: onViewDetail,
                    ),

                    const SizedBox(width: 8.0),

                    // NEW BUTTON: Warn User
                    _buildCardActionButton(
                      context: context,
                      icon: Icons.error_outline,
                      label: 'Warn User',
                      color: Colors.orange.shade700,
                      onTap: () {
                        // Display the warning confirmation overlay/dialog
                        _navigateToScreen(
                          context,
                          AdminWarnUserMaskScreen(
                            report: report,
                            onWarnConfirmed: onWarnUser,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0), // Separator for the next row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // NEW BUTTON: Delete
                    _buildCardActionButton(
                      context: context,
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: Colors.red.shade700,
                      onTap: onDelete, // Use the provided onDelete callback
                    ),
                    const SizedBox(width: 8.0),
                    _buildCardActionButton(
                      context: context,
                      icon: Icons.check_circle_outline,
                      label: 'Resolve',
                      color: Colors.green.shade700,
                      onTap: () {
                        // Directly resolve (mock)
                        // The detail screen handles popping if it was open
                        if (report.status == 'Pending') {
                          _AdminDashboardScreenState.of(
                            context,
                          )._resolveReport(report);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DETAIL SCREENS (UPDATED/NEW)
// -----------------------------------------------------------------------------

// NEW DETAIL SCREEN FOR BOTH ITEM AND CLAIM
class AdminViewItemDetailScreen extends StatelessWidget {
  final Item? item; // For Lost/Found Items
  final Claim? claim; // For Claims
  final bool isClaim;

  const AdminViewItemDetailScreen({
    super.key,
    this.item,
    this.claim,
    required this.isClaim,
  }) : assert(item != null || claim != null);

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = isClaim ? (claim?.title ?? 'N/A') : (item?.title ?? 'N/A');
    String description = isClaim
        ? (claim?.foundByNotes ?? 'N/A')
        : (item?.description ?? 'N/A');
    String imageUrl = isClaim
        ? (claim?.imageUrl ?? '')
        : (item?.imageUrl ?? '');
    String status = isClaim
        ? (claim?.status ?? 'N/A')
        : (item?.status ?? 'N/A');
    String reporter = isClaim
        ? (claim?.claimedBy ?? 'N/A')
        : (item?.reportedBy ?? 'N/A');
    String reporterId = isClaim
        ? (claim?.claimedById ?? 'N/A')
        : item?.reportedBy.split('(ID: ').last.replaceAll(')', '') ??
              'N/A'; // Extract ID
    String date = isClaim ? (claim?.date ?? 'N/A') : (item?.date ?? 'N/A');
    String location = isClaim ? 'N/A' : (item?.location ?? 'N/A');
    String category = isClaim ? 'N/A' : (item?.category ?? 'N/A');
    String contact = isClaim
        ? (claim?.contact ?? 'N/A')
        : (item?.contact ?? 'N/A');
    String uniqueFeatures = isClaim ? (claim?.uniqueFeatures ?? 'N/A') : 'N/A';

    // Determine the actual item/claim object for deletion handling
    final itemToDelete = item;
    final claimToDelete = claim;

    Color statusColor;
    if (status == 'Lost' || status == 'Pending') {
      statusColor = Colors.red.shade400;
    } else if (status == 'Found' || status == 'Verified') {
      statusColor = Colors.orange.shade400;
    } else {
      statusColor = Colors.blue.shade400;
    }

    String finalImageUrl = imageUrl.isEmpty
        ? 'https://placehold.co/600x400/cccccc/000000?text=No+Image'
        : imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(isClaim ? 'Claim Details' : 'Item Details'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                finalImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              isClaim
                  ? 'Additional Notes: $description'
                  : 'Description: $description',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 32),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isClaim)
                          buildDetailRow('Claimed By', reporter)
                        else
                          buildDetailRow(
                            'Reported By',
                            reporter.split(' (ID:').first,
                          ), // Cleaned for display
                        buildDetailRow('User ID', reporterId),
                        buildDetailRow(isClaim ? 'Claim Date' : 'Date', date),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 32,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isClaim)
                          buildDetailRow('Contact', contact)
                        else
                          buildDetailRow('Category', category),
                        if (isClaim)
                          buildDetailRow('Unique Features', uniqueFeatures)
                        else
                          buildDetailRow('Location', location),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _navigateToScreen(
                  context,
                  AdminShowReturnScreen(
                    itemTitle: title,
                    onReturnConfirmed: () {
                      // TODO: Logic for returning item
                    },
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Mark as Returned',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Determine which delete action to pass
                VoidCallback deleteAction;
                if (itemToDelete != null && itemToDelete.status == 'Lost') {
                  deleteAction = () => _AdminDashboardScreenState.of(
                    context,
                  )._deleteLostItem(itemToDelete);
                } else if (itemToDelete != null &&
                    itemToDelete.status == 'Found') {
                  deleteAction = () => _AdminDashboardScreenState.of(
                    context,
                  )._deleteFoundItem(itemToDelete);
                } else if (claimToDelete != null) {
                  deleteAction = () => _AdminDashboardScreenState.of(
                    context,
                  )._deleteClaim(claimToDelete);
                } else {
                  deleteAction = () => debugPrint('Delete action not set.');
                }

                _navigateToScreen(
                  context,
                  AdminDeleteItemMaskScreen(
                    itemTitle: title,
                    onDeleteConfirmed: () {
                      deleteAction();
                      // FIX: Pop the detail screen after deletion is confirmed
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: Text(
                isClaim ? 'Delete Claim' : 'Delete Item',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class AdminShowReturnScreen extends StatelessWidget {
  final String itemTitle;
  final VoidCallback onReturnConfirmed;

  const AdminShowReturnScreen({
    super.key,
    required this.itemTitle,
    required this.onReturnConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black54),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Mark as Returned',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Are you sure you want to mark "$itemTitle" as returned? This indicates that the owner has successfully received their item.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // NOTE: onDeleteConfirmed is called *before* the pop in the masks,
                          // but here we call it after to ensure the dashboard state updates
                          // (since it calls the state method).
                          Navigator.of(context).pop();
                          onReturnConfirmed(); // Calls _markClaimAsReturned which handles the state update/snack bar
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mark as Returned',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.black26),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDeleteItemMaskScreen extends StatelessWidget {
  final String itemTitle;
  final VoidCallback onDeleteConfirmed;

  const AdminDeleteItemMaskScreen({
    super.key,
    required this.itemTitle,
    required this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(color: Colors.black54),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // FIX: Standardized Title
                    const Text(
                      'Delete Entry',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      // FIX: Standardized Message (from report delete)
                      child: Text(
                        'Are you sure you want to delete "$itemTitle"? This action cannot be undone. This should only be used for fake or already resolved entries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Call the delete logic first (which updates the state/Supabase)
                          onDeleteConfirmed();
                          // Then pop the mask screen
                          Navigator.of(context).pop();
                          // NOTE: The delete logic now handles the snackbar/popping of the detail screen.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.black26),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NEW SCREEN: WARN USER MASK
class AdminWarnUserMaskScreen extends StatelessWidget {
  final Report report;
  final VoidCallback onWarnConfirmed;

  const AdminWarnUserMaskScreen({
    super.key,
    required this.report,
    required this.onWarnConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(color: Colors.black54),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Warn User for Misconduct',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You are about to warn:\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          TextSpan(
                            text: '${report.reportedUser}\n',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          TextSpan(
                            text: '(User ID: ${report.reportedUserId})',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'This action will send a warning notification to the user regarding the misconduct.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Pop the mask screen only
                          Navigator.of(context).pop();
                          // Execute the warning logic (which includes the splash screen and resolution)
                          onWarnConfirmed();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Confirm & Warn User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.black26),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminViewReportDetail extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;
  //final VoidCallback onResolve;
  final VoidCallback onWarnUser;
  final VoidCallback onContactUser;
  final VoidCallback onBanUser;

  const AdminViewReportDetail({
    super.key,
    required this.report,
    required this.onDelete,
    //required this.onResolve,
    required this.onWarnUser,
    required this.onContactUser,
    required this.onBanUser,
  });

  Widget buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: color),
        label: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          side: BorderSide(color: borderColor ?? color.withOpacity(0.5)),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color brightBlue = Colors.lightBlue.shade700;
    Color whiteText = Colors.white;
    Color darkRed = Colors.red.shade700;
    Color darkOrange = Colors.orange.shade700;
    Color darkGreen = Colors.green.shade700;

    Color statusBgColor = report.status == 'Pending' ? brightBlue : darkGreen;
    Color statusTextColor = whiteText;

    Widget reportHeader = Container(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [brightBlue, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.report_problem, color: whiteText, size: 28),
              const SizedBox(width: 10),
              Text(
                'User Misconduct Report',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: whiteText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Report Title: ${report.title}',
            style: TextStyle(fontSize: 16, color: whiteText.withOpacity(0.8)),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
        backgroundColor: brightBlue,
        foregroundColor: whiteText,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            reportHeader,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Status: ${report.status}',
                        style: TextStyle(
                          color: statusTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Report Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brightBlue,
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),
                  buildDetailRow(
                    'Reported User:',
                    report.reportedUser,
                    valueColor: darkRed,
                  ),
                  buildDetailRow(
                    'User ID:',
                    report.reportedUserId,
                  ), // Added User ID
                  buildDetailRow('Reported By:', report.reportedBy),
                  buildDetailRow('Date:', report.date),
                  buildDetailRow('Item ID:', report.itemId),
                  const Divider(height: 20, thickness: 1),
                  const SizedBox(height: 16),
                  Text(
                    'Misconduct Detail',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brightBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error, color: darkRed, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            report.misconductDetail,
                            style: TextStyle(
                              color: darkRed,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Action buttons
                  Row(
                    children: [
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.mail_outline,
                        label: 'Contact User',
                        color: brightBlue,
                        onTap: onContactUser,
                      ),
                      const SizedBox(width: 12.0),
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.error_outline,
                        label: 'Warn User',
                        color: darkOrange,
                        onTap: onWarnUser,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  Row(
                    children: [
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.block,
                        label: 'Ban User',
                        color: darkRed,
                        onTap: onBanUser,
                      ),
                      const SizedBox(width: 12.0),
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.delete_outline,
                        label: 'Delete Report',
                        color: darkRed,
                        onTap: onDelete,
                        borderColor: darkRed.withOpacity(0.5),
                        backgroundColor: Colors.red.shade50,
                      ),
                    ],
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

// -----------------------------------------------------------------------------
// SPLASH SCREENS (UNCHANGED)
// -----------------------------------------------------------------------------

class UserWarnedSplash extends StatefulWidget {
  final Report report;
  final VoidCallback onFinishNavigation;
  const UserWarnedSplash({
    super.key,
    required this.report,
    required this.onFinishNavigation,
  });

  @override
  UserWarnedSplashScreenState createState() => UserWarnedSplashScreenState();
}

class UserWarnedSplashScreenState extends State<UserWarnedSplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Only pop the splash screen, the calling screen remains on the stack
        Navigator.pop(context);
        widget.onFinishNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.warning_amber, // Changed icon to match 'Warned' action
                  color: Color(0xFFFF5252),
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "User Warned!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "The user has been warned regarding the reported misconduct.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserContactedSplash extends StatefulWidget {
  final Report report;
  final VoidCallback onFinishNavigation;
  const UserContactedSplash({
    super.key,
    required this.report,
    required this.onFinishNavigation,
  });

  @override
  UserContactedSplashScreenState createState() =>
      UserContactedSplashScreenState();
}

class UserContactedSplashScreenState extends State<UserContactedSplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Only pop the splash screen, the calling screen remains on the stack
        Navigator.pop(context);
        widget.onFinishNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(
                0xFF4CAF50,
              ), // Changed color to a more standard green for 'Contacted/Success'
              Color(0xFF81C784),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons
                      .email_outlined, // Changed icon to match 'Contacted' action
                  color: Color(0xFF4CAF50),
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "User Contacted!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "The user has been contacted through a system notification.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}