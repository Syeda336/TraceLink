import 'package:flutter/material.dart';
// Assuming admin_logout.dart contains the necessary AdminDashboardLogoutConfirmation widget
import 'admin_logout.dart';

import 'package:flutter/services.dart';
import 'dart:async'; // Required for Timer

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

// NEW DATA MODEL FOR REPORTS
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
}

// -----------------------------------------------------------------------------
// HELPER METHODS
// -----------------------------------------------------------------------------

// Helper method to navigate to a new screen
void _navigateToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => screen, fullscreenDialog: true),
  );
}

// Action Button Helper
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
// MODAL & SPLASH SCREENS (STUBS)
// -----------------------------------------------------------------------------

// MODIFIED SCREEN 1: Item Details
class AdminViewItem1Screen extends StatelessWidget {
  final Item item;
  const AdminViewItem1Screen({super.key, required this.item});

  // Helper widget for the detail rows
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
    // Determine status color/style
    Color statusColor;
    if (item.status == 'Lost') {
      statusColor = Colors.red.shade400;
    } else if (item.status == 'Found') {
      statusColor = Colors.orange.shade400;
    } else {
      statusColor = Colors.blue.shade400;
    }

    // Defensive check for image URL
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
            // Item Image
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
            // Title and Status Tag
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
            // Details Grid
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
            // Contact Information
            buildDetailRow('Contact', item.contact),
            const SizedBox(height: 24),
            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                _navigateToScreen(
                  context,
                  AdminShowReturnScreen(item: item, onReturnConfirmed: () {}),
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
                    onDeleteConfirmed: () {},
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

// MODIFIED SCREEN 2: Mark as Returned Confirmation (Modal Overlay)
// MODIFIED SCREEN 2: Mark as Returned Confirmation (Modal Overlay)
class AdminShowReturnScreen extends StatelessWidget {
  final Item item;
  // New: Callback function to execute the actual 'mark returned' logic.
  final VoidCallback onReturnConfirmed;

  const AdminShowReturnScreen({
    super.key,
    required this.item,
    required this.onReturnConfirmed, // Now required
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. The Mask/Background Tappable Area (Closes Modal only)
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

                    // --- MARK AS RETURNED BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Execute the 'Mark as Returned' logic passed from the parent
                          onReturnConfirmed();

                          // 2. Close ONLY this modal overlay (pop once)
                          Navigator.of(context).pop();

                          // 3. Show Snackbar (Can be shown here or in the parent, keeping it here for continuity)
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

                    // --- CANCEL BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        // Close ONLY the modal
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

// MODIFIED SCREEN 3: Delete Report Confirmation (Modal Overlay)
class AdminDeleteItemMaskScreen extends StatelessWidget {
  final Item item;
  // Callback function to execute the actual deletion logic, if successful.
  // This function should be passed from the parent screen (the detail screen).
  final VoidCallback onDeleteConfirmed;

  const AdminDeleteItemMaskScreen({
    super.key,
    required this.item,
    required this.onDeleteConfirmed, // New required callback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. The Mask/Background Tappable Area
          GestureDetector(
            // Action changed: tapping the mask now ONLY closes the modal
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(color: Colors.black54),
          ),

          // 2. The Delete Confirmation Dialog
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

                    // --- DELETE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Execute the deletion logic passed via the callback
                          onDeleteConfirmed();

                          // 2. ONLY close this modal (AdminDeleteItemMaskScreen)
                          Navigator.of(context).pop();

                          // 3. Show Snackbar (remains here, though often placed in the calling screen)
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

                    // --- CANCEL BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        // Tap to close only the modal (pop once)
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

// -----------------------------------------------------------------------------
// NEW REPORT DETAIL SCREEN (BASED ON IMAGE THEME - BRIGHT BLUE)
// -----------------------------------------------------------------------------

class AdminViewReportDetail extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onResolve; // Added new action

  const AdminViewReportDetail({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onResolve,
  });

  // Helper widget for detail rows
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

  // Helper for action buttons to match the image style
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
    Color brightBlue = Colors.lightBlue.shade700; // Bright Blue Theme
    Color whiteText = Colors.white;
    Color darkRed = Colors.red.shade700;
    Color darkOrange = Colors.orange.shade700;
    Color darkGreen = Colors.green.shade700;

    // Status Tag Color/Style
    Color statusBgColor = report.status == 'Pending' ? brightBlue : darkGreen;
    Color statusTextColor = whiteText;

    // Report Header (Similar to image, but using bright blue theme)
    Widget reportHeader = Container(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [brightBlue, Colors.blue.shade300], // Using a blue gradient
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
                  // Status Tag
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

                  // Report Details
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

                  // Misconduct Detail Box (Highlighted)
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

                  // Action Buttons (Row 1)
                  Row(
                    children: [
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.mail_outline,
                        label: 'Contact User',
                        color: brightBlue,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserContactedSplash(
                                report: report, // Pass the report
                                onFinishNavigation:
                                    onResolve, // Pass the callback
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
                          // Opens admin_splash_userwarn.dart
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserWarnedSplash(
                                report: report, // Pass the report
                                onFinishNavigation:
                                    onResolve, // Pass the callback
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  // Action Buttons (Row 2 - Delete and Resolve)
                  Row(
                    children: [
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.delete_outline,
                        label: 'Delete Item',
                        color: darkRed,
                        onTap: onDelete,
                      ),
                      const SizedBox(width: 12.0),
                      _buildReportActionButton(
                        context: context,
                        icon: Icons.check_circle_outline,
                        label: 'Mark as Resolved',
                        color: darkGreen,
                        onTap: onResolve,
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
// MAIN DASHBOARD AND SUPPORT WIDGETS
// -----------------------------------------------------------------------------

class AdminDashboard1LostItems extends StatefulWidget {
  const AdminDashboard1LostItems({super.key});

  @override
  State<AdminDashboard1LostItems> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboard1LostItems> {
  // Tabs: 'Lost', 'Found', 'Claims', 'Reports'
  String _selectedTab = 'Lost';

  // Mock data for the lost items list
  final List<Item> lostItems = const [
    Item(
      title: 'Black Wallet',
      description: 'Black leather wallet with student ID and credit cards',
      reportedBy: 'john_doe',
      imageUrl: 'lib/images/black_wallet.jfif',
      status: 'Lost',
      category: 'Accessories',
      date: 'Oct 10, 2025',
      location: 'Library, 2nd Floor',
      contact: 'john.doe@university.edu',
    ),
    Item(
      title: 'Blue Backpack',
      description: 'Blue backpack with laptop and notebooks inside.',
      reportedBy: 'sarah_smith',
      imageUrl: 'lib/images/blue_backpack.jfif',
      status: 'Lost',
      category: 'Bags',
      date: 'Sep 25, 25',
      location: 'Student Union Hall',
      contact: 'sarah.s@university.edu',
    ),
  ];

  // Mock data for the found items list
  final List<Item> foundItems = const [
    Item(
      title: 'Set of Keys',
      description: 'Set of keys with blue keychain',
      reportedBy: 'emma_wilson',
      imageUrl: 'lib/images/key.jfif',
      status: 'Found',
      category: 'Miscellaneous',
      date: 'Oct 14, 2025',
      location: 'Main Desk',
      contact: 'emma.w@university.edu',
    ),
    Item(
      title: 'Student ID Card',
      description: 'Student ID belonging to Alex...',
      reportedBy: 'lisa_davis',
      imageUrl: 'lib/images/card.jfif',
      status: 'Found',
      category: 'Documents',
      date: 'Oct 15, 2025',
      location: 'Library Entrance',
      contact: 'lisa.d@university.edu',
    ),
  ];

  // Mock data for the claims section
  final List<Claim> claims = [
    Claim(
      title: 'Set of Keys',
      claimedBy: 'alex_brown',
      foundBy: 'emma_wilson',
      imageUrl: 'lib/images/key.jfif',
      date: 'Oct 14, 2025',
      status: 'Pending',
      item: const Item(
        title: 'Set of Keys',
        description: 'Set of keys with blue keychain',
        reportedBy: 'emma_wilson',
        imageUrl: 'lib/images/key.jfif',
        status: 'Found',
        category: 'Miscellaneous',
        date: 'Oct 14, 2025',
        location: 'Main Desk',
        contact: 'emma.w@university.edu',
      ),
    ),
    Claim(
      title: 'Black Wallet',
      claimedBy: 'john_doe',
      foundBy: 'mike_jones',
      imageUrl: 'lib/images/black_wallet.jfif',
      date: 'Oct 15, 2025',
      status: 'Verified',
      item: const Item(
        title: 'Black Wallet',
        description: 'Black leather wallet with student ID and credit cards',
        reportedBy: 'mike_jones',
        imageUrl: 'lib/images/black_wallet.jfif',
        status: 'Found',
        category: 'Accessories',
        date: 'Oct 15, 2025',
        location: 'Cafeteria',
        contact: 'mike.j@university.edu',
      ),
    ),
    Claim(
      title: 'Water Bottle',
      claimedBy: 'sarah_clark',
      foundBy: 'tom_harris',
      imageUrl: 'lib/images/bottle.jfif',
      date: 'Oct 16, 2025',
      status: 'Returned',
      item: const Item(
        title: 'Water Bottle',
        description: 'Clear plastic water bottle with a grey lid.',
        reportedBy: 'tom_harris',
        imageUrl: 'lib/images/bottle.jfif',
        status: 'Found',
        category: 'Miscellaneous',
        date: 'Oct 16, 2025',
        location: 'Gym',
        contact: 'tom.h@university.edu',
      ),
    ),
  ];

  // NEW: Mock data for Misconduct Reports (MUST be mutable for deletion)
  List<Report> reports = [
    const Report(
      title: 'Set of Keys',
      reportedUser: 'emma_wilson',
      reportedBy: 'alex_brown',
      date: 'Oct 14, 2025',
      status: 'Pending',
      misconductDetail:
          'Finder is not responding to messages and refusing to return the item',
      itemId: 'keys101',
    ),
    const Report(
      title: 'Student ID Card',
      reportedUser: 'lisa_davis',
      reportedBy: 'john_parker',
      date: 'Oct 15, 2025',
      status: 'Pending',
      misconductDetail: 'Asking for money to return the item',
      itemId: 'idcard002',
    ),
    const Report(
      title: 'Blue Backpack',
      reportedUser: 'unknown_finder',
      reportedBy: 'sarah_smith',
      date: 'Oct 16, 2025',
      status: 'Resolved',
      misconductDetail: 'Fake report - item was never actually found.',
      itemId: 'backpack404',
    ),
  ];

  // NEW: Method to delete a report from the list
  void _deleteReport(Report report) {
    setState(() {
      reports.remove(report);
    });
    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report for "${report.title}" deleted.'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // NEW: Method to mark a report as resolved
  void _resolveReport(Report report) {
    // Find the index of the report to update
    final index = reports.indexOf(report);
    if (index != -1) {
      setState(() {
        reports[index] = Report(
          title: report.title,
          reportedUser: report.reportedUser,
          reportedBy: report.reportedBy,
          date: report.date,
          status: 'Resolved', // Update status
          misconductDetail: report.misconductDetail,
          itemId: report.itemId,
        );
      });
      // Close the detail screen
      Navigator.of(context).pop();
      // Show a confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report for "${report.title}" marked as Resolved.'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5); // A nice blue for the theme

    // Determine the list of widgets to display based on the selected tab
    List<Widget> contentList;
    if (_selectedTab == 'Lost') {
      contentList = lostItems.map((item) => _ItemCard(item: item)).toList();
    } else if (_selectedTab == 'Found') {
      contentList = foundItems
          .map((item) => _FoundItemCard(item: item))
          .toList();
    } else if (_selectedTab == 'Claims') {
      contentList = claims
          .map((claim) => _GeneralClaimCard(claim: claim))
          .toList();
    } else if (_selectedTab == 'Reports') {
      // NEW: REPORTS TAB CONTENT LIST
      contentList = reports.map((report) {
        return _ReportCard(
          report: report,
          onDelete: () => _deleteReport(report), // Pass deletion function
          onViewDetail: () {
            // Navigate to the new detail screen
            _navigateToScreen(
              context,
              AdminViewReportDetail(
                report: report,
                onDelete: () => _deleteReport(report),
                onResolve: () => _resolveReport(report),
              ),
            );
          },
        );
      }).toList();
    } else {
      // Fallback
      contentList = [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'No content for this tab.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
        ),
      ];
    }

    // NEW: Reports Header Widget (for the Reports Tab only)
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
              // FIX: Defensive check on reports list access
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
          _HeaderSection(primaryColor: primaryColor),

          // 2. FIXED TAB BAR
          _FixedTabBar(
            selectedTab: _selectedTab,
            onTabSelected: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),

          // 3. SCROLLING ITEM LIST (FIXED: Using ListView)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              children: [
                // Headers are conditional based on selected tab
                if (_selectedTab == 'Claims') _ClaimsHeader(claims: claims),
                if (_selectedTab == 'Reports') // NEW: Reports Header
                  reportHeader,
                ...contentList,
              ],
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
                  // Home Button (Implied: stays on Lost section)
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      // Action for Home: typically reload dashboard or navigate to home section
                      Navigator.pop(context);
                    },
                  ),
                  // Logout Button (opens admin_logout.dart)
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
                ? Border.all(
                    color: Colors.lightBlue.shade300,
                    width: 2,
                  ) // Light blue outline
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
      color: Colors.white, // Assuming a white background for the tab row
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

// -----------------------------------------------------------------------------
// CARD WIDGETS
// -----------------------------------------------------------------------------

// LOST ITEM CARD (Original Card)
class _ItemCard extends StatelessWidget {
  final Item item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Determine status color/style
    Color statusColor = item.status == 'Lost'
        ? Colors.red.shade400
        : Colors.blue.shade400;

    // Defensive check for image URL
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
                // Image Placeholder
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
                          // Status Tag
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
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'View',
                  onTap: () {
                    // Opens Item Details (Screen 1)
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
                    // Opens Mark as Returned Confirmation (Screen 2)
                    _navigateToScreen(
                      context,
                      AdminShowReturnScreen(
                        item: item,
                        onReturnConfirmed: () {},
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
                    // Opens Delete Report Confirmation (Screen 3)
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {},
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

// FOUND ITEM CARD
class _FoundItemCard extends StatelessWidget {
  final Item item;

  const _FoundItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Status Tag Color (Found is Green)
    const Color statusColor = Colors.green;

    // Defensive check for image URL
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
                // Image Placeholder
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
                          // Status Tag: 'Found'
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
                              item.status, // This will be 'Found' based on mock data
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
            // Action Buttons (View, Return, Delete)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'View',
                  onTap: () {
                    // Opens Item Details (Screen 1)
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
                    // Opens Mark as Returned Confirmation (Screen 2)
                    _navigateToScreen(
                      context,
                      AdminShowReturnScreen(
                        item: item,
                        onReturnConfirmed: () {},
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
                    // Opens Delete Report Confirmation (Screen 3)
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {},
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

// CLAIMS HEADER
class _ClaimsHeader extends StatelessWidget {
  final List<Claim> claims;
  const _ClaimsHeader({required this.claims});

  @override
  Widget build(BuildContext context) {
    // FIX: Defensive use of .where() as it relies on the list being initialized
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

// GENERAL CLAIM CARD
class _GeneralClaimCard extends StatelessWidget {
  final Claim claim;

  const _GeneralClaimCard({required this.claim});

  // Determine the status color based on the claim status
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

  // Determine the status text style
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
    // The underlying Item data is used for view/return/delete
    final Item item = claim.item;

    // Defensive check for image URL
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
                // Image Placeholder
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
                          // Status Tag
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
            // Action Buttons (View Details, Mark Returned, Delete)
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align the Row and Delete button to the start (left)
              children: [
                // 1. The original Row containing 'View Details' and 'Mark Returned'
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // View Details Button
                    _buildActionButton(
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      label: 'View Details',
                      onTap: () {
                        // Opens Item Details (Screen 1)
                        _navigateToScreen(
                          context,
                          AdminViewItem1Screen(item: item),
                        );
                      },
                    ),

                    // Space between buttons
                    const SizedBox(width: 8.0),

                    // Mark Returned Button (Conditional)
                    if (claim.status != 'Returned')
                      _buildActionButton(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'Mark Returned',
                        onTap: () {
                          // Opens Mark as Returned Confirmation (Screen 2)
                          _navigateToScreen(
                            context,
                            AdminShowReturnScreen(
                              item: item,
                              onReturnConfirmed: () {},
                            ),
                          );
                        },
                      ),
                  ],
                ),

                // Add vertical space between the Row and the Delete button
                const SizedBox(height: 16.0),

                // 2. The Delete button (now in its own section/line)
                _buildActionButton(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: Colors.red.shade700,
                  onTap: () {
                    // Opens Delete Report Confirmation (Screen 3)
                    _navigateToScreen(
                      context,
                      AdminDeleteItemMaskScreen(
                        item: item,
                        onDeleteConfirmed: () {},
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

// NEW CARD WIDGET FOR MISCONDUCT REPORTS
class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onViewDetail; // New callback for viewing details

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

    // Status Tag Widget
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
            // Misconduct Detail Box
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons for Reports
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align contents to the left
              children: [
                // 1. The Row containing 'Contact User' and 'Warn User'
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Contact User Button
                    _buildActionButton(
                      context,
                      icon: Icons.mail_outline,
                      label: 'Contact User',
                      color: Colors.blue.shade700,
                      onTap: () {
                        // Opens admin_splash_user_contacted.dart
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserContactedSplash(
                              report: report, // Pass the report
                              onFinishNavigation:
                                  onViewDetail, // Pass the callback
                            ),
                          ),
                        );
                      },
                    ),

                    // Space between buttons
                    const SizedBox(width: 8.0),

                    // Warn User Button
                    _buildActionButton(
                      context,
                      icon: Icons.error_outline,
                      label: 'Warn User',
                      color: Colors.orange.shade700,
                      onTap: () {
                        // Opens admin_splash_userwarn.dart
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserWarnedSplash(
                              report: report, // Pass the report
                              onFinishNavigation:
                                  onViewDetail, // Pass the callback
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Vertical space between the Row and the Delete button
                const SizedBox(height: 16.0),

                // 2. The Delete Item button (now on its own line)
                _buildActionButton(
                  context,
                  icon: Icons.delete_outline,
                  label: 'Delete Item',
                  color: Colors.red.shade700,
                  onTap:
                      onDelete, // Executes the deletion logic passed from the parent (_deleteReport)
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
// 1. ADMIN WARNED SPLASH SCREEN (Provided by User)
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
    // Start a timer for 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Navigate to the AdminViewReportDetail and remove all previous routes
        Navigator.pop(context);
        widget.onFinishNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to light for better contrast
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Container(
        // Full screen reddish-orange gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF5252), // A vibrant red
              Color(0xFFFF8A80), // A lighter, warm orange-red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon with checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow for depth
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline, // Checkmark icon
                  color: Color(0xFFFF5252), // Red color for the checkmark
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              // "User Warned!" text
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
              // Subtitle text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "The user has been warned to return the item",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70, // Slightly transparent white
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

// -----------------------------------------------------------------------------
// 2. ADMIN CONTACTED SPLASH SCREEN (Provided by User)
// -----------------------------------------------------------------------------

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
    // Start a timer for 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Navigate to the AdminViewReportDetail and remove all previous routes
        Navigator.pop(context);
        widget.onFinishNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to dark for better contrast with the light background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: Container(
        // Full screen green/yellow gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 127, 193, 53), // A light, vibrant green
              Color.fromARGB(255, 226, 241, 54), // A bright yellow-green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular icon with checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.1,
                      ), // Soft shadow for depth
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline, // Checkmark icon
                  color: Color(0xFF69F0AE), // A vibrant green for the checkmark
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              // "User Contacted!" text
              const Text(
                "User Contacted!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26, // Darker shadow for more pop
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "The user has been contacted through\nnotification to return the item.", // Two lines as in the image
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70, // Slightly transparent white
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12, // Softer shadow for subtitle
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
