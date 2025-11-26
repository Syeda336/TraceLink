import 'package:flutter/material.dart';
import 'warning_admin.dart'; // Target screen for the "Close" button

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  // Function to navigate back to the warning screen using a replacement route
  void _closeAndNavigateBack(BuildContext context) {
    // Use pushReplacement to replace the current screen in the stack.
    // This assumes the warning_screen is the one the user should return to.
    Navigator.pushReplacement(
      context,
      // You can use a standard MaterialPageRoute here, or use RightSlideRoute
      // for the open animation and simply pop to close it if you're using it
      // as a modal. For simplicity and to match the close action, we'll
      // replace the route here.
      MaterialPageRoute(builder: (context) => const WarningScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent automatic "back" button since we have a custom close action
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Item Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quick preview of the reported item',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Image Card ---
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Stack(
                children: [
                  // Placeholder for the image (Use an Asset or NetworkImage)
                  Image.asset(
                    'lib/images/key.jfif', // Replace with your image path
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Item Title & Category ---
            const Text(
              'Set of Keys',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Keys & Accessories',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9C27B0), // Purple color
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),

            // --- Posted by Card ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5), // Light purple background
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    // Placeholder for profile picture
                    backgroundColor: Color(0xFFCE93D8),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Posted by',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        'Sarah Johnson',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Location and Date ---
            const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF9C27B0)),
                SizedBox(width: 10),
                Text(
                  'Location:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Text('Library - 2nd Floor', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF9C27B0)),
                SizedBox(width: 10),
                Text(
                  'Date:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Text('March 15, 2024', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 25),

            // --- Description ---
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Set of keys with a blue keychain. Found near the study area on the second floor of the main library.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      // --- Close Button (Fixed at the bottom) ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
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
              onTap: () => _closeAndNavigateBack(context),
              borderRadius: BorderRadius.circular(30),
              child: const Center(
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
