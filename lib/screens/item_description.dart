import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Assuming the theme_provider.dart is in the same directory or accessible
import '../theme_provider.dart';
import '../supabase_lost_service.dart'; // 🌟 Import the new service
import '../supabase_found_service.dart'; // 🌟 Import the new service

import 'chat.dart';
import 'claim_submit.dart'; // Make sure VerifyOwnershipScreen in this file accepts parameters

const Color primaryBlue = Color(
  0xFF42A5F5,
); // Bright Blue (A light-medium blue)
const Color darkBlue = Color(0xFF1976D2); // Dark Blue (A darker, deeper blue)
const Color lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue for section backgrounds

class Item {
  // Column names from your Supabase table
  final int id;
  final String itemName; // Matches 'Item Name'
  final String category;
  final String color;
  final String description;
  final String location;
  final DateTime datePosted; // Generalizing from dateLost/dateFound
  final String imageUrl; // Matches 'Image' (the URL)
  final String status;
  final String userInitials;
  final String userName; // 🌟 Maps to 'Reporter Name'
  final String userEmail; // 🌟 NEW: To potentially store the reporter's email
  final String userId; // 🌟 NEW: To store the 'User ID' (Student ID)

  Item({
    required this.id,
    required this.itemName,
    required this.category,
    required this.color,
    required this.description,
    required this.location,
    required this.datePosted,
    required this.imageUrl,
    required this.status,
    required this.userInitials,
    required this.userName,
    required this.userEmail, // Added
    required this.userId, // Added
  });

  // 🌟 Factory constructor to create an Item from a Supabase row (Map)
  factory Item.fromSupabase(Map<String, dynamic> data) {
    // --- 🎯 FIX: Extract REAL User Data from Supabase Columns ---
    final fetchedUserName = data['User Name'] as String? ?? 'Community User';
    final fetchedUserId = data['User ID'] as String? ?? 'N/A';
    final fetchedUserEmail = data['User Email'] as String? ?? 'N/A';

    final initials = fetchedUserName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join();

    // Determine the correct date key to use based on status
    final dateKey = data['status'] == 'Lost' ? 'Date Lost' : 'Date Found';

    return Item(
      id: data['id'],
      itemName: data['Item Name'] as String? ?? 'N/A',
      category: data['Category'] as String? ?? 'N/A',
      color: data['Color'] as String? ?? 'N/A',
      description: data['Description'] as String? ?? 'N/A',
      location: data['Location'] as String? ?? 'N/A',
      // Safely parse the date using the determined key
      datePosted:
          DateTime.tryParse(data[dateKey] as String? ?? '') ?? DateTime.now(),
      imageUrl: data['Image'] as String? ?? '', // The image URL
      status: data['status'] as String? ?? 'Unknown',
      userInitials: initials.isEmpty
          ? 'CU'
          : initials.toUpperCase(), // Use computed initials
      userName: fetchedUserName, // Use Reporter Name
      userEmail: fetchedUserEmail, // Use Reporter Email
      userId: fetchedUserId, // Use User ID (Student ID)
    );
  }
}

// --- Main Item Detail Screen (Converted to StatefulWidget) ---
class ItemDetailScreen extends StatefulWidget {
  final int id;
  const ItemDetailScreen({super.key, required this.id});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  // 🎯 FIX 4: Define state variables for data handling
  List<Item> _masterItems = [];
  Item? _selectedItem;
  bool _isLoading = true;
  bool _hasError = false;

  // --- Theme-Adaptive Color Helpers ---
  Color _getPrimaryTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.white : darkBlue;
  }

  Color _getSecondaryTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800;
  }

  Color _getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF121212) : Colors.white;
  }

  Color _getCardColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF1E1E1E) : lightBlueBackground;
  }

  // NOTE: cardOutlineColor is unused but kept for consistency
  Color _getCardOutlineColor(bool isDarkMode) {
    return isDarkMode ? primaryBlue : darkBlue;
  }

  Color _getAppBarIconBackground(bool isDarkMode) {
    return isDarkMode
        ? primaryBlue.withOpacity(0.8)
        : Colors.white.withOpacity(0.8);
  }

  @override
  void initState() {
    super.initState();
    // 🌟 Start data fetching when the widget initializes
    _fetchItemsFromSupabase();
  }

  // Helper to format the date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // 🌟 NEW/FIXED: Fetch data from Supabase and find the target item
  Future<void> _fetchItemsFromSupabase() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 1. Fetch data from both tables concurrently
      final lostItemsFuture = SupabaseLostService.fetchLostItems();
      final foundItemsFuture = SupabaseFoundService.fetchFoundItems();

      final List<Map<String, dynamic>> lostData = await lostItemsFuture;
      final List<Map<String, dynamic>> foundData = await foundItemsFuture;

      // 🎯 Inject the status into the data maps
      final List<Map<String, dynamic>> lostItemsWithStatus = lostData.map((
        row,
      ) {
        return {...row, 'status': 'Lost'};
      }).toList();

      final List<Map<String, dynamic>> foundItemsWithStatus = foundData.map((
        row,
      ) {
        return {
          ...row,
          'status': 'Found',
          'Date Lost': row['Date Found'],
        }; // Use Date Found if status is Found
      }).toList();

      // 2. Combine the lost and found data into one list
      final List<Map<String, dynamic>> combinedData = [
        ...lostItemsWithStatus,
        ...foundItemsWithStatus,
      ];

      // 3. Convert the combined raw Supabase data into a List of Item objects
      final List<Item> items = combinedData
          .map((row) => Item.fromSupabase(row))
          .toList();

      // 4. Find the item that matches the name passed to the screen
      final Item? selectedItem = items.firstWhere(
        (item) => item.id == widget.id,
        orElse: () => throw Exception('Item not found: ${widget.id}'),
      );

      setState(() {
        _masterItems =
            items; // Though masterItems is not strictly needed here, it's good practice
        _selectedItem = selectedItem;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch data or item not found: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to react to theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final primaryTextColor = _getPrimaryTextColor(isDarkMode);
        final secondaryTextColor = _getSecondaryTextColor(isDarkMode);
        final backgroundColor = _getBackgroundColor(isDarkMode);
        final cardColor = _getCardColor(isDarkMode);
        final cardOutlineColor = _getCardOutlineColor(isDarkMode);

        // Define a base text style for dark/light mode
        final baseTextStyle = TextStyle(
          color: secondaryTextColor,
          fontSize: 16,
        );

        if (_isLoading) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: CircularProgressIndicator(color: primaryBlue)),
          );
        }

        if (_hasError || _selectedItem == null) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: Text(
                'Failed to load item details or item not found.',
                style: TextStyle(color: primaryTextColor),
              ),
            ),
          );
        }

        // Use the found item from the state
        final item = _selectedItem!;

        return Scaffold(
          backgroundColor: backgroundColor, // Dynamic screen background
          // The body is wrapped in a Stack to place the content and action buttons
          body: Stack(
            children: [
              // Screen Content (Scrollable)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Image 4: Item Header with Image, Title, Location, Date ---
                    _buildItemImageHeader(
                      context,
                      isDarkMode,
                      primaryTextColor,
                      secondaryTextColor,
                      item, // Pass the item object
                    ),
                    // This Padding helps to align the content below the image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ), // Spacing after the image header card
                          // --- Image 1: Posted By Section ---
                          _buildPostedBySection(
                            primaryTextColor,
                            cardColor,
                            cardOutlineColor,
                            item, // Pass the item object
                          ),
                          const SizedBox(height: 20),

                          // --- Image 2: Description Section ---
                          _buildDescriptionSection(
                            primaryTextColor,
                            cardColor,
                            cardOutlineColor,
                            baseTextStyle,
                            item, // Pass the item object
                          ),
                          const SizedBox(height: 20),

                          // --- Image 3: Additional Details Section ---
                          _buildAdditionalDetailsSection(
                            primaryTextColor,
                            cardColor,
                            cardOutlineColor,
                            item, // Pass the item object
                          ),
                          const SizedBox(
                            height: 100,
                          ), // Space for the floating action buttons to overlap
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // --- Floating Action Buttons (Message & Claim Item) ---
              _buildBottomActionButtons(
                context,
                isDarkMode,
                backgroundColor,
                primaryTextColor,
                item, // 🎯 PASS THE ITEM OBJECT HERE
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Widget for Image 4: Item Header ---
  Widget _buildItemImageHeader(
    BuildContext context,
    bool isDarkMode,
    Color primaryTextColor,
    Color secondaryTextColor,
    Item item, // 🎯 Use the Item object
  ) {
    return Column(
      children: [
        Stack(
          children: [
            // Display the item image from URL
            Image.network(
              item.imageUrl.isNotEmpty
                  ? item.imageUrl
                  : 'https://via.placeholder.com/60', // Item's image URL
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 300,
                color: isDarkMode
                    ? Colors.grey.shade700
                    : const Color.fromARGB(255, 206, 232, 247),
                child: Icon(
                  Icons.broken_image,
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : const Color.fromARGB(255, 158, 158, 158),
                  size: 60,
                ),
              ),
            ),
            // Gradient Overlay for better readability of icons
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            // Top Left Back Button
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  10, // Adjust for status bar
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: _getAppBarIconBackground(isDarkMode),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryTextColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
        // Details card overlaying the bottom of the image
        Transform.translate(
          offset: const Offset(0, -5), // Pull the card up
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getBackgroundColor(isDarkMode), // Dynamic background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.black : darkBlue).withOpacity(
                    0.2,
                  ),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName, // 🎯 Display Item Name
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                        primaryBlue, // Bright Blue Text (constant for accent)
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(
                      0.15,
                    ), // Light background for the tag (constant for accent)
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status, // 🎯 Display Item Status
                    style: const TextStyle(
                      color: primaryBlue, // Bright Blue Text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: primaryTextColor, // Dynamic Icon
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.location, // 🎯 Display Location
                        style: TextStyle(
                          fontSize: 16,
                          color: secondaryTextColor, // Dynamic Text
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: primaryTextColor, // Dynamic Icon
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.status} on ${_formatDate(item.datePosted)}', // 🎯 Display Date Posted
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor, // Dynamic Text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget for Image 1: Posted By Section ---
  Widget _buildPostedBySection(
    Color primaryTextColor,
    Color cardColor,
    Color cardOutlineColor,
    Item item, // 🎯 Use the Item object
  ) {
    // The initials are already correctly calculated and stored in item.userInitials

    // We will hardcode 'Student' for the status, as this data isn't provided
    // in the Item model (only Name, ID, Email).
    const String userStatus = 'Student';

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: cardColor, // Dynamic Background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posted By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor, // Dynamic Text
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color:
                      primaryBlue, // Bright Blue Avatar background (constant)
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.userInitials, // ✅ Display item's initials
                    style: const TextStyle(
                      color: Colors.white, // White Text on bright blue
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // User Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName, // ✅ Display User Name from item object
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor, // Dynamic Text
                      ),
                    ),
                    Text(
                      userStatus, // 🎯 Display User Status (Hardcoded for now)
                      style: TextStyle(
                        color: primaryTextColor.withOpacity(
                          0.8,
                        ), // Dynamic Text
                        fontSize: 14,
                      ),
                    ),
                    // Display User ID (Student ID) and Email
                    Text(
                      'ID: ${item.userId}', // ✅ Display User ID from item object
                      style: TextStyle(
                        color: primaryTextColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      item.userEmail, // ✅ Display User Email from item object
                      style: TextStyle(
                        color: primaryTextColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.green.shade100, // Keep light green for "Verified"
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 2: Description Section ---
  Widget _buildDescriptionSection(
    Color primaryTextColor,
    Color cardColor,
    Color cardOutlineColor,
    TextStyle baseTextStyle,
    Item item, // 🎯 Use the Item object
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: cardColor, // Dynamic Background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor, // Dynamic Text
            ),
          ),
          const SizedBox(height: 15),
          Text(
            item.description, // 🎯 Display Description
            style: baseTextStyle.copyWith(height: 1.5), // Dynamic Text
          ),
        ],
      ),
    );
  }

  // --- Widget for Image 3: Additional Details Section ---
  Widget _buildAdditionalDetailsSection(
    Color primaryTextColor,
    Color cardColor,
    Color cardOutlineColor,
    Item item, // 🎯 Use the Item object
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryTextColor, // Dynamic Text
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardColor, // Dynamic Background
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        color: primaryTextColor.withOpacity(
                          0.6,
                        ), // Dynamic Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.category, // 🎯 Display Category
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryTextColor, // Dynamic Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardColor, // Dynamic Background
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color',
                      style: TextStyle(
                        color: primaryTextColor.withOpacity(
                          0.6,
                        ), // Dynamic Text
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.color, // 🎯 Display Color
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryTextColor, // Dynamic Text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Widget for Bottom Action Buttons ---
  Widget _buildBottomActionButtons(
    BuildContext context,
    bool isDarkMode,
    Color backgroundColor,
    Color primaryTextColor,
    Item item, // ✅ Added Item object here
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: backgroundColor, // Dynamic Background
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.black : darkBlue).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to chat screen, passing the reporter's details
                    // The ChatScreen will use these details to establish a chat
                    // with the item's reporter.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatPartnerName: item.userName, // **Reporter's Name**
                          chatPartnerInitials:
                              item.userInitials, // **Reporter's Initials**
                          avatarColor: Colors.blueAccent,
                          receiverId: item
                              .userId, // Keep existing parameter (or pass a color)
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: isDarkMode
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey.shade200,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        color: primaryTextColor, // Dynamic Icon
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Message',
                        style: TextStyle(
                          color: primaryTextColor, // Dynamic Text
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to claim verification screen, passing item name and image URL
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyOwnershipScreen(
                          itemName: item.itemName, // ✅ Pass Item Name
                          imageUrl: item.imageUrl, // ✅ Pass Image URL
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        primaryBlue, // Bright Blue Button (constant accent)
                    elevation: 0,
                  ),
                  child: const Text(
                    'Claim Item',
                    style: TextStyle(
                      color: Colors.white, // White Text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

// --- Assuming chat.dart looks something like this (Updated) ---
// You will need to create/update your ChatScreen to accept the new parameter.
/*
class ChatScreen extends StatelessWidget {
  final String chatPartnerName;
  final String chatPartnerInitials;
  final String? chatPartnerId; // <-- NEW: Use this to pass the Reporter's ID
  final Color? avatarColor;

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerInitials,
    this.chatPartnerId, // <-- New Parameter
    this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    // ... Chat screen UI implementation
    // Use chatPartnerName and chatPartnerId to set up the chat logic (e.g., fetch messages)
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $chatPartnerName')),
      body: Center(
        child: Text('Chat with User ID: ${chatPartnerId ?? 'N/A'}'),
      ),
    );
  }
}
*/
