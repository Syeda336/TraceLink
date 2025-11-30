import 'package:flutter/material.dart';
import 'admin_lostitems1.dart';

// Assuming the following services provide the necessary data fetching methods:
// Note: These imports are essential for the code to compile and run.
import 'package:tracelink/firebase_service.dart';
import 'package:tracelink/supabase_lost_service.dart';
import 'package:tracelink/supabase_found_service.dart';
import 'package:tracelink/supabase_reports_problems.dart';
import 'package:tracelink/supabase_claims_service.dart';

// Enum to manage which section is currently displayed
enum DashboardSection {
  mainDashboard,
  activeUsers,
  totalItems,
  claims,
  reports,
}

class AdminWelcome extends StatefulWidget {
  const AdminWelcome({super.key});
  @override
  AdminWelcomeState createState() => AdminWelcomeState();
}

class AdminWelcomeState extends State<AdminWelcome> {
  // --- Dashboard Data ---
  int activeUsers = 0;
  int totalItems = 0;
  int totalClaims = 0;
  int totalReports = 0;

  // --- State Variables ---
  bool isLoading = true;
  DashboardSection _selectedSection = DashboardSection.mainDashboard;

  // --- Detailed Data Lists for the Sections ---
  List<Map<String, dynamic>> _reportsList = [];
  List<Map<String, dynamic>> _usersList = [];
  List<Map<String, dynamic>> _lostItemsList = [];
  List<Map<String, dynamic>> _foundItemsList = [];
  List<Map<String, dynamic>> _claimsList = [];

  // Create an instance of the service for non-static calls
  final _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  /// Fetches all necessary dashboard counts and detail lists concurrently.
  Future<void> loadDashboardData() async {
    try {
      // Use Future.wait to fetch data concurrently for faster loading
      final results = await Future.wait([
        _firebaseService.getUserCount(),
        SupabaseLostService().getLostCount(),
        SupabaseFoundService().getFoundCount(),
        SupabaseClaimService().getClaimedCount(),
        SupabaseReportService().getReports(),
        SupabaseLostService.fetchLostItems(),
        SupabaseFoundService.fetchFoundItems(),
        SupabaseClaimService.fetchClaimedItems(),
        SupabaseReportService.fetchReports(),
        _firebaseService.getUsersList(), // Fix 1 applied: Call on instance
      ]);

      if (!mounted) return; // Check if the widget is still in the tree

      setState(() {
        // Assigning counts
        activeUsers = results[0] as int;
        final int lostCount = results[1] as int;
        final int foundCount = results[2] as int;
        totalClaims = results[3] as int;
        totalReports = results[4] as int;
        totalItems = lostCount + foundCount;

        // Assigning fetched detail lists
        _lostItemsList = results[5] as List<Map<String, dynamic>>;
        _foundItemsList = results[6] as List<Map<String, dynamic>>;
        _claimsList = results[7] as List<Map<String, dynamic>>;
        _reportsList = results[8] as List<Map<String, dynamic>>;
        _usersList = results[9] as List<Map<String, dynamic>>;

        isLoading = false;
      });
    } catch (e) {
      // In a real application, you would show an error message to the user
      print("Error loading dashboard data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to handle card tap and update the displayed section
  void _navigateToSection(DashboardSection section) {
    setState(() {
      _selectedSection = section;
    });
  }

  // Helper to get the title for the detail view AppBar
  String _getSectionTitle(DashboardSection section) {
    switch (section) {
      case DashboardSection.activeUsers:
        return 'Active Users (${_usersList.length})';
      case DashboardSection.totalItems:
        return 'Total Items (${_lostItemsList.length + _foundItemsList.length})';
      case DashboardSection.claims:
        return 'Total Claims (${_claimsList.length})';
      case DashboardSection.reports:
        return 'User Reports (${_reportsList.length})';
      case DashboardSection.mainDashboard:
      default:
        return 'Admin Dashboard';
    }
  }

  // --- WIDGET BUILDER (The main entry point) ---
  @override
  Widget build(BuildContext context) {
    final bool isDetailView =
        _selectedSection != DashboardSection.mainDashboard;

    return Scaffold(
      appBar: isDetailView
          ? AppBar(
              title: Text(
                _getSectionTitle(_selectedSection),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    _navigateToSection(DashboardSection.mainDashboard),
              ),
              backgroundColor: const Color(0xFF007BFF),
            )
          : AppBar(
              // Simple AppBar for main dashboard without a back button
              title: Text(
                _getSectionTitle(DashboardSection.mainDashboard),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF007BFF),
            ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(context),
      ),
    );
  }

  // Widget to switch between main dashboard and detail sections
  Widget _buildBody(BuildContext context) {
    switch (_selectedSection) {
      case DashboardSection.mainDashboard:
        return _buildMainDashboard(context);
      case DashboardSection.reports:
        return _buildReportsSection();
      case DashboardSection.activeUsers:
        return _buildActiveUsersSection();
      case DashboardSection.totalItems:
        return _buildTotalItemsSection();
      case DashboardSection.claims:
        return _buildClaimsSection();
      default: // Fix 2 applied: Handles all cases and ensures non-null return
        return _buildMainDashboard(context);
    }
  }

  // -----------------------------------------
  // 🔨 MAIN DASHBOARD WIDGET
  // -----------------------------------------
  Widget _buildMainDashboard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: const Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- TOP ICON SECTION ---
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(127),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF007BFF),
                          Color(0xFF2196F3),
                          Color(0xFF0056B3),
                        ],
                      ),
                    ),
                    width: 127,
                    height: 127,
                  ),
                  const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 80,
                  ),
                ],
              ),
            ),

            // --- WELCOME TEXT AND ROLE ---
            const Text(
              "Welcome Back!",
              style: TextStyle(
                color: Color(0xFF007BFF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administrator",
              style: TextStyle(
                color: Color(0xFF002B5B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 26, top: 8),
              width: double.infinity,
              child: const Text(
                "You're logged in as an administrator. You have full control over the TraceLink system.",
                style: TextStyle(color: Color(0xFF002B5B), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

            // ------------------- DASHBOARD CARDS -------------------
            Column(
              children: [
                // ----------------- FIRST ROW (Active Users, Total Items) -----------------
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people_alt,
                        iconColor: Colors.blue.shade700,
                        value: "$activeUsers",
                        label: "Active Users",
                        onTap: () =>
                            _navigateToSection(DashboardSection.activeUsers),
                      ),
                    ),
                    const SizedBox(width: 17),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.inventory_2,
                        iconColor: Colors.green.shade700,
                        value: "$totalItems",
                        label: "Total Items",
                        onTap: () =>
                            _navigateToSection(DashboardSection.totalItems),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ----------------- SECOND ROW (Claims, Reports) -----------------
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.gavel,
                        iconColor: Colors.deepOrange.shade700,
                        value: "$totalClaims",
                        label: "Claims",
                        onTap: () =>
                            _navigateToSection(DashboardSection.claims),
                      ),
                    ),
                    const SizedBox(width: 17),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.report_problem,
                        iconColor: Colors.red.shade700,
                        value: "$totalReports",
                        label: "Reports",
                        onTap: () =>
                            _navigateToSection(DashboardSection.reports),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ---------- NAVIGATION BUTTON ----------
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboard1LostItems(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF007BFF),
                      Color(0xFF2196F3),
                      Color(0xFF0056B3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                margin: const EdgeInsets.only(top: 40, bottom: 24),
                child: const Center(
                  child: Text(
                    "Go to Full Dashboard View",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const Center(
              child: Text(
                "Remember to use your admin powers responsibly 👑",
                style: TextStyle(color: Color(0xFF002B5B), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // REUSABLE CARD WIDGET (Using Icons instead of image URLs)
  // -----------------------------------------
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBBDEFB)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF002B5B),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF002B5B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // 1. REPORTS SECTION WIDGET (Displays data) 📝
  // -----------------------------------------
  Widget _buildReportsSection() {
    if (_reportsList.isEmpty) {
      return const Center(child: Text('No user reports found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _reportsList.length,
      itemBuilder: (context, index) {
        final report = _reportsList[index];

        final String title = report['Title'] ?? 'No Title Provided';
        final String reportedUser =
            report['Complaint_User_Name'] ?? 'Unknown User';
        final String itemName = report['Item Name'] ?? 'N/A';
        final String status = report['Status'] ?? 'New';

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: const Color(0xFFFFF8E1),
          child: ListTile(
            leading: const Icon(Icons.warning, color: Colors.amber),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reported By: $reportedUser'),
                Text('Related Item: $itemName'),
                Text(
                  'Status: $status',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing details for report: $title')),
              );
            },
          ),
        );
      },
    );
  }

  // -----------------------------------------
  // 2. ACTIVE USERS SECTION WIDGET (Displays user data) 🧑‍💻
  // -----------------------------------------
  Widget _buildActiveUsersSection() {
    if (_usersList.isEmpty) {
      return const Center(child: Text('No active users found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _usersList.length,
      itemBuilder: (context, index) {
        final user = _usersList[index];

        final String email = user['email'] ?? 'No Email';
        final String name = user['displayName'] ?? 'User ID: ${user['uid']}';
        final bool isAdmin = user['isAdmin'] ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: isAdmin ? const Color(0xFFE3F2FD) : Colors.white,
          child: ListTile(
            leading: Icon(
              isAdmin ? Icons.star : Icons.person,
              color: isAdmin ? const Color(0xFF007BFF) : Colors.grey,
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(email),
            trailing: Text(isAdmin ? 'Admin' : 'User'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing user profile for: $name')),
              );
            },
          ),
        );
      },
    );
  }

  // -----------------------------------------
  // 3. TOTAL ITEMS SECTION WIDGET (Displays Lost and Found data) 📦
  // -----------------------------------------
  Widget _buildTotalItemsSection() {
    // Combine Lost and Found lists
    final combinedItems = [..._lostItemsList, ..._foundItemsList];

    // Sort by a common key (e.g., 'Date') to display them chronologically or by ID
    // Note: Assuming 'Date Lost' is the date key for both. You may need to adjust the key based on your Supabase schema.
    combinedItems.sort((a, b) {
      final dateA = a['Date Lost'] ?? '';
      final dateB = b['Date Lost'] ?? '';
      return dateB.compareTo(dateA); // Newest first
    });

    if (combinedItems.isEmpty) {
      return const Center(child: Text('No lost or found items found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: combinedItems.length,
      itemBuilder: (context, index) {
        final item = combinedItems[index];

        // Determine if the item is from the Lost list
        // Note: This check relies on object identity, which works because we combined the original lists.
        final bool isLost = _lostItemsList.contains(item);
        final String type = isLost ? 'Lost' : 'Found';
        final Color color = isLost
            ? const Color(0xFFFBE9E7)
            : const Color(0xFFE8F5E9);

        // Ensure these keys match your 'Lost' or 'Found' Supabase table columns:
        final String itemName = item['Item Name'] ?? 'No Name';
        final String description = item['Description'] ?? 'No description.';
        final String date = item['Date Lost'] ?? 'Unknown Date';
        final String? imageUrl = item['Image'];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: color,
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback icon if image fails to load
                          return Icon(
                            isLost
                                ? Icons.search_off
                                : Icons.check_circle_outline,
                            color: isLost
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                            size: 30,
                          );
                        },
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                      )
                    : Icon(
                        // Default fallback icon if URL is missing
                        isLost ? Icons.search_off : Icons.check_circle_outline,
                        color: isLost
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        size: 30,
                      ),
              ),
            ),
            title: Text(
              itemName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  'Date: $date',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(type),
              backgroundColor: isLost
                  ? Colors.red.shade100
                  : Colors.green.shade100,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing item: $itemName ($type)')),
              );
            },
          ),
        );
      },
    );
  }

  // -----------------------------------------
  // 4. CLAIMS SECTION WIDGET (Displays data from _claimsList) 🤝
  // -----------------------------------------
  Widget _buildClaimsSection() {
    if (_claimsList.isEmpty) {
      return const Center(child: Text('No claims found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _claimsList.length,
      itemBuilder: (context, index) {
        final claim = _claimsList[index];

        // Ensure these keys match your 'claimed_items' Supabase table columns:
        final String claimedItem = claim['Item Name'] ?? 'Unknown Item';
        final String claimant = claim['User Name'] ?? 'Unknown User';
        final String status = claim['status'] ?? 'Pending';

        Color statusColor;
        switch (status) {
          case 'Approved':
            statusColor = Colors.green;
            break;
          case 'Rejected':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.orange;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: const Color(0xFFE0F7FA),
          child: ListTile(
            leading: const Icon(Icons.handshake, color: Color(0xFF007BFF)),
            title: Text(
              'Claim for: $claimedItem',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Claimed by: $claimant'),
            trailing: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reviewing claim by $claimant for $claimedItem',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
