import 'package:flutter/material.dart';
import 'warning_admin.dart'; // Target screen for the "Close" button
import '../supabase_lost_service.dart';
import '../supabase_found_service.dart';

// ------------------------------------
// Item Class (Modified to ensure ID is always a String)
// ------------------------------------

class Item {
  final String id;
  // Column names from your Supabase table
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

    // 🎯 FIX: Explicitly convert the Supabase 'id' (which is likely int/numeric) to a String
    final idString = data['id']?.toString() ?? 'unknown_id';

    return Item(
      id: idString, // Store as String
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

// ------------------------------------
// ItemDetailScreen
// ------------------------------------

class ItemDetailScreen extends StatefulWidget {
  // id is passed as a String (itemId from the warning screen)
  final String id;

  const ItemDetailScreen({super.key, required this.id});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Item? _selectedItem;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchItemsFromSupabase();
  }

  void _closeAndNavigateBack(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WarningScreen()),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // 🌟 MODIFIED: The Item.fromSupabase factory handles the int-to-String conversion now.
  Future<void> _fetchItemsFromSupabase() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final lostItemsFuture = SupabaseLostService.fetchLostItems();
      final foundItemsFuture = SupabaseFoundService.fetchFoundItems();

      final List<Map<String, dynamic>> lostData = await lostItemsFuture;
      final List<Map<String, dynamic>> foundData = await foundItemsFuture;

      // Inject the status and prepare for Item creation
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
          // Use Date Found for Found items, but map it to 'Date Lost' so Item.fromSupabase
          // can use a single key for all. This is a hacky way to ensure one date logic.
          'Date Lost': row['Date Found'],
        };
      }).toList();

      // Combine the lost and found data into one list
      final List<Map<String, dynamic>> combinedData = [
        ...lostItemsWithStatus,
        ...foundItemsWithStatus,
      ];

      // Convert the combined raw Supabase data into a List of Item objects
      // The Item.fromSupabase factory now ensures item.id is a String.
      final List<Item> items = combinedData
          .map((row) => Item.fromSupabase(row))
          .toList();

      // Find the item by comparing the String ID passed via widget.id
      final Item? selectedItem = items.firstWhere(
        (item) => item.id == widget.id, // String comparison is now correct
        orElse: () => throw Exception('Item not found: ${widget.id}'),
      );

      setState(() {
        _selectedItem = selectedItem;
        _isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch data or item not found: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _selectedItem;

    return Scaffold(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(
              child: Text(
                'Failed to load item details or item not found.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : item == null
          ? const Center(
              child: Text(
                'Item data is missing.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
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
                        // 🎯 FIX 3: Use NetworkImage for the actual URL
                        item.imageUrl.isNotEmpty
                            ? Image.network(
                                item.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    // Fallback for failed image load
                                    Image.asset(
                                      'lib/images/key.jfif', // Use your local placeholder
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                              )
                            // Fallback for empty image URL
                            : Image.asset(
                                'lib/images/key.jfif', // Use your local placeholder
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
                              color: item.status == 'Found'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // 🎯 FIX 3: Use actual item status
                            child: Text(
                              item.status,
                              style: const TextStyle(
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
                  // 🎯 FIX 3: Use actual item name
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // 🎯 FIX 3: Use actual item category
                  Text(
                    item.category,
                    style: const TextStyle(
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          // 🎯 FIX 3: Use actual item initials
                          backgroundColor: const Color(0xFFCE93D8),
                          child: Text(
                            item.userInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.status == 'Lost'
                                  ? 'Reported by'
                                  : 'Found by',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            // 🎯 FIX 3: Use actual reporter name
                            Text(
                              item.userName,
                              style: const TextStyle(
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
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF9C27B0)),
                      const SizedBox(width: 10),
                      const Text(
                        'Location:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // 🎯 FIX 3: Use actual item location
                      Text(item.location, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF9C27B0),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${item.status == 'Lost' ? 'Lost' : 'Found'} Date:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // 🎯 FIX 3: Use actual item date
                      Text(
                        _formatDate(item.datePosted),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- Description ---
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 🎯 FIX 3: Use actual item description
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
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
              // 🎯 FIX: Call the private method with context
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
