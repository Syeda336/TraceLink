import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:tracelink/supabase_lost_service.dart';
import 'package:tracelink/supabase_found_service.dart';
import 'admin_logout.dart';

// -----------------------------------------------------------------------------
// DATA MODELS
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
  });

  // Factory constructor to create an Item from Supabase data map
  factory Item.fromSupabase(Map<String, dynamic> data, String statusType) {
    // Determine the reported by field based on status (simple mock)
    // NOTE: Supabase tables might have different column names for the user who reported.
    final reportedBy = statusType == 'Lost'
        ? 'Lost User (ID: L001)'
        : 'Found User (ID: F005)';

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
    );
  }
}

class Claim {
  final String title;
  final String claimedBy;
  final String foundBy;
  final String imageUrl;
  final String date;
  final String status; // 'Pending', 'Verified', 'Returned'
  final Item item; // Link back to the original item data

  const Claim({
    required this.title,
    required this.claimedBy,
    required this.foundBy,
    required this.imageUrl,
    required this.date,
    required this.status,
    required this.item,
  });
}

class Report {
  final String title;
  final String reportedUser;
  final String reportedBy;
  final String date;
  final String status; // 'Pending', 'Resolved'
  final String misconductDetail;
  final String itemId; // Link to the item being discussed (optional)

  const Report({
    required this.title,
    required this.reportedUser,
    required this.reportedBy,
    required this.date,
    required this.status,
    required this.misconductDetail,
    required this.itemId,
  });

  // Utility method to create a copy with a new status
  Report copyWith({String? status}) {
    return Report(
      title: title,
      reportedUser: reportedUser,
      reportedBy: reportedBy,
      date: date,
      status: status ?? this.status,
      misconductDetail: misconductDetail,
      itemId: itemId,
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER METHODS
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
  bool _isLoading = true;

  // Mock data for the claims and reports section (initialized)
  List<Claim> claims = [
    Claim(
      title: 'Claim for Blue Backpack',
      claimedBy: 'Alice J.',
      foundBy: 'Bob K.',
      imageUrl:
          'https://images.unsplash.com/photo-1551213458-eb9c57d7210e?fit=crop&w=400&q=80',
      date: '2025-11-26',
      status: 'Pending',
      item: Item(
        title: 'Blue Backpack',
        description: 'A small blue hiking backpack...',
        reportedBy: 'Lost User',
        imageUrl:
            'https://images.unsplash.com/photo-1551213458-eb9c57d7210e?fit=crop&w=400&q=80',
        status: 'Lost',
      ),
    ),
  ];

  List<Report> reports = [
    Report(
      title: 'Fraudulent Claim Attempt',
      reportedUser: 'Charlie D.',
      reportedBy: 'Admin Assistant',
      date: '2025-11-27',
      status: 'Pending',
      misconductDetail:
          'User attempted to claim the Silver Key without providing verification details. Possible scammer.',
      itemId: 'KEY-001',
    ),
    Report(
      title: 'Inappropriate Language',
      reportedUser: 'Eve L.',
      reportedBy: 'System Bot',
      date: '2025-11-26',
      status: 'Resolved',
      misconductDetail:
          'Used profanity in a public item description. Warning issued.',
      itemId: 'ITEM-010',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  // Method to fetch data from Supabase
  Future<void> _fetchItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
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

      if (mounted) {
        setState(() {
          // Assign fetched data. No need for ?? [] since .toList() returns a List<Item>
          _lostItems = fetchedLostItems;
          _foundItems = fetchedFoundItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data. Check console.')),
        );
      }
      // In a real app, you'd log this error
      debugPrint('Error fetching items from Supabase: $e');
    }
  }

  // Method to delete a report from the list
  void _deleteReport(Report report) {
    if (!mounted) return;
    final title = report.title;
    setState(() {
      reports.remove(report);
    });
    // Pop the detail screen if it's currently open
    // NOTE: This assumes the detail screen is the direct previous route.
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report for "$title" deleted.'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // Method to mark a report as resolved
  void _resolveReport(Report report) {
    if (!mounted) return;
    // Find the index of the report to update
    final index = reports.indexOf(report);
    if (index != -1) {
      final title = reports[index].title;
      setState(() {
        // Use copyWith for immutability and clarity
        reports[index] = reports[index].copyWith(status: 'Resolved');
      });
      // Close the detail screen
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
      contentList = _lostItems.map((item) => _ItemCard(item: item)).toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(message: 'No Lost Item reports found.'),
        );
      }
    } else if (_selectedTab == 'Found') {
      contentList = _foundItems
          .map((item) => _FoundItemCard(item: item))
          .toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(message: 'No Found Item reports found.'),
        );
      }
    } else if (_selectedTab == 'Claims') {
      contentList = claims
          .map((claim) => _GeneralClaimCard(claim: claim))
          .toList();
      if (contentList.isEmpty) {
        contentList.add(
          const _EmptyStateMessage(message: 'No pending claims at this time.'),
        );
      }
    } else if (_selectedTab == 'Reports') {
      contentList = reports.map((report) {
        return _ReportCard(
          report: report,
          // When onDelete is called from the card, it triggers the state method
          onDelete: () => _deleteReport(report),
          onViewDetail: () {
            _navigateToScreen(
              context,
              AdminViewReportDetail(
                report: report,
                // Pass the state methods to the detail screen
                onDelete: () => _deleteReport(report),
                onResolve: () => _resolveReport(report),
              ),
            );
          },
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
                '${reports.where((r) => r.status == 'Pending').length} pending reports',
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
                    _ClaimsHeader(claims: claims),
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
                      Navigator.pop(context);
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
  const _ItemCard({required this.item});

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
                    _navigateToScreen(
                      context,
                      AdminViewItem1Screen(item: item),
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
                        item: item,
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
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {
                          // TODO: Implement actual state update for deleting item
                          // This would typically involve calling a delete API and refreshing the list.
                        },
                      ),
                    );
                  },
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

  const _FoundItemCard({required this.item});

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
                      AdminViewItem1Screen(item: item),
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
                        item: item,
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
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {
                          // TODO: Implement actual state update for deleting item
                        },
                      ),
                    );
                  },
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

  const _GeneralClaimCard({required this.claim});

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

  @override
  Widget build(BuildContext context) {
    final Item item = claim.item;

    String imageUrl = claim.imageUrl.isEmpty
        ? 'https://placehold.co/70x70/cccccc/000000?text=N/A'
        : claim.imageUrl;

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
                              claim.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                        'Found By: ${claim.foundBy}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        claim.date,
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
                    _buildActionButton(
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      label: 'View Details',
                      onTap: () {
                        _navigateToScreen(
                          context,
                          AdminViewItem1Screen(item: item),
                        );
                      },
                    ),

                    const SizedBox(width: 8.0),

                    if (claim.status != 'Returned')
                      _buildActionButton(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'Mark Returned',
                        onTap: () {
                          _navigateToScreen(
                            context,
                            AdminShowReturnScreen(
                              item: item,
                              onReturnConfirmed: () {
                                // TODO: Implement claim status update and item status update
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 16.0),

                _buildActionButton(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: Colors.red.shade700,
                  onTap: () {
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {
                          // TODO: Implement claim/item deletion
                        },
                      ),
                    );
                  },
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

  const _ReportCard({
    required this.report,
    required this.onDelete,
    required this.onViewDetail,
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
                    _buildActionButton(
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      label: 'View Detail',
                      color: Colors.blue.shade700,
                      onTap: onViewDetail,
                    ),

                    const SizedBox(width: 8.0),

                    _buildActionButton(
                      context,
                      icon: Icons.delete_outline,
                      label: 'Delete Report',
                      color: Colors.red.shade700,
                      onTap: onDelete,
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
// DETAIL SCREENS (UNCHANGED)
// -----------------------------------------------------------------------------

class AdminViewItem1Screen extends StatelessWidget {
  final Item item;
  const AdminViewItem1Screen({super.key, required this.item});

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
    Color statusColor;
    if (item.status == 'Lost') {
      statusColor = Colors.red.shade400;
    } else if (item.status == 'Found') {
      statusColor = Colors.orange.shade400;
    } else {
      statusColor = Colors.blue.shade400;
    }

    String imageUrl = item.imageUrl.isEmpty
        ? 'https://placehold.co/600x400/cccccc/000000?text=No+Image'
        : item.imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
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
                imageUrl,
                height: 200,
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
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
                    item.status,
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
              item.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 32),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        buildDetailRow('Category', item.category),
                        buildDetailRow('Location', item.location),
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
                      children: [
                        buildDetailRow('Date', item.date),
                        buildDetailRow('Reported By', item.reportedBy),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildDetailRow('Contact', item.contact),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _navigateToScreen(
                  context,
                  AdminShowReturnScreen(
                    item: item,
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
                _navigateToScreen(
                  context,
                  AdminDeleteItemMaskScreen(
                    item: item,
                    onDeleteConfirmed: () {
                      // TODO: Logic for deleting item
                    },
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Delete Report',
                style: TextStyle(color: Colors.red, fontSize: 16),
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
  final Item item;
  final VoidCallback onReturnConfirmed;

  const AdminShowReturnScreen({
    super.key,
    required this.item,
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
                        'Are you sure you want to mark "${item.title}" as returned? This indicates that the owner has successfully received their item.',
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
                          onReturnConfirmed();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${item.title} marked as Returned!',
                              ),
                              backgroundColor: Colors.green.shade600,
                            ),
                          );
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
  final Item item;
  final VoidCallback onDeleteConfirmed;

  const AdminDeleteItemMaskScreen({
    super.key,
    required this.item,
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
                    const Text(
                      'Delete Report',
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
                        'Are you sure you want to delete "${item.title}"? This action cannot be undone. This should only be used for fake or already resolved reports.',
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
                          onDeleteConfirmed();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} report deleted.'),
                              backgroundColor: Colors.red.shade600,
                            ),
                          );
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

class AdminViewReportDetail extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onResolve;

  const AdminViewReportDetail({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onResolve,
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
                        onTap: () {
                          // Navigates to splash screen, which calls onResolve after timer
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserContactedSplash(
                                report: report,
                                onFinishNavigation:
                                    onResolve, // This resolves the report and pops this screen
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12.0),
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.error_outline,
                        label: 'Warn User',
                        color: darkOrange,
                        onTap: () {
                          // Navigates to splash screen, which calls onResolve after timer
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserWarnedSplash(
                                report: report,
                                onFinishNavigation:
                                    onResolve, // This resolves the report and pops this screen
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  Row(
                    children: [
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.delete_outline,
                        label: 'Delete Report',
                        color: darkRed,
                        onTap:
                            onDelete, // This deletes the report and pops this screen
                      ),
                      const SizedBox(width: 12.0),
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.check_circle_outline,
                        label: 'Mark as Resolved',
                        color: darkGreen,
                        onTap:
                            onResolve, // This resolves the report and pops this screen
                        borderColor: darkGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
