import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'search_bar.dart';
import 'item_description.dart'; // Assuming this holds ItemDetailScreen/ItemDescriptionScreen

import '../supabase_lost_service.dart'; // 🌟 Import the new service
import '../supabase_found_service.dart'; // 🌟 Import the new service

// --- Main Lost/Found Screen (Stateful) ---

class SearchLost extends StatefulWidget {
  const SearchLost({super.key});

  @override
  State<SearchLost> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<SearchLost> {
  // State to track which tab is selected (true for Lost, false for Found)
  bool _isLostSelected = true;

  // Define the new bright blue theme color
  static const Color _primaryColor = Color.fromARGB(
    255,
    0,
    150,
    255,
  ); // Bright Blue
  static const Color _accentColor = Color.fromARGB(
    255,
    173,
    216,
    230,
    // 255,
  ); // Light Blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        // Set the background color to the bright blue theme
        backgroundColor: _primaryColor,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to home.dart
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomNavScreen()),
            );
          },
        ),
        title: const Text(
          'Lost & Found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false, // Align title to the left
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                // Creates the light blue circle background for the search icon
                color: _accentColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Navigate to search_bar.dart
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar-like custom widget now takes the state management functions
          _LostFoundToggle(
            isLostSelected: _isLostSelected,
            onLostTap: () {
              setState(() {
                _isLostSelected = true;
              });
            },
            onFoundTap: () {
              setState(() {
                _isLostSelected = false;
              });
            },
            activeColor: _primaryColor,
            inactiveColor: _accentColor,
          ),
          // List of items changes based on the state
          Expanded(
            // 🎯 REFACTORED: Use the reusable ItemListWidget
            child: ItemListWidget(status: _isLostSelected ? 'Lost' : 'Found'),
          ),
        ],
      ),
    );
  }
}

// --- Custom Toggle for Lost/Found Tabs (Stateless, remains the same) ---

class _LostFoundToggle extends StatelessWidget {
  final bool isLostSelected;
  final VoidCallback onLostTap;
  final VoidCallback onFoundTap;
  final Color activeColor;
  final Color inactiveColor;

  const _LostFoundToggle({
    required this.isLostSelected,
    required this.onLostTap,
    required this.onFoundTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Lost Items Button
          Expanded(
            child: GestureDetector(
              onTap: onLostTap, // Use the callback from the parent
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isLostSelected
                      ? inactiveColor
                      : Colors.transparent, // Highlight color based on state
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: isLostSelected
                        ? inactiveColor
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: isLostSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Lost Items',
                    style: TextStyle(
                      color: isLostSelected ? activeColor : Colors.grey,
                      fontWeight: isLostSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Found Items Button
          Expanded(
            child: GestureDetector(
              onTap: onFoundTap, // Use the callback from the parent
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: !isLostSelected
                      ? inactiveColor
                      : Colors.transparent, // Highlight color based on state
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: !isLostSelected
                        ? inactiveColor
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: !isLostSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Found Items',
                    style: TextStyle(
                      color: !isLostSelected ? activeColor : Colors.grey,
                      fontWeight: !isLostSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Defines the structure for each item, matching Supabase columns.
class Item {
  final String id;
  // Column names from your Supabase table
  final String itemName; // Matches 'Item Name'
  final String category;
  final String color;
  final String description;
  final String location;
  // 🎯 FIX: Use the actual column name for the date
  final DateTime date;
  final String imageUrl; // Matches 'Image' (the URL)
  final String status;

  Item({
    required this.id,
    required this.itemName,
    required this.category,
    required this.color,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.status,
  });

  // 🌟 Factory constructor to create an Item from a Supabase row (Map)
  factory Item.fromSupabase(Map<String, dynamic> data) {
    // Determine which date column to use based on the injected 'status'
    final dateKey = data['status'] == 'Lost' ? 'Date Lost' : 'Date Found';

    return Item(
      id: data['id'],
      itemName: data['Item Name'] as String? ?? 'N/A',
      category: data['Category'] as String? ?? 'N/A',
      color: data['Color'] as String? ?? 'N/A',
      description: data['Description'] as String? ?? 'N/A',
      location: data['Location'] as String? ?? 'N/A',
      // 🎯 FIX: Use the determined dateKey to parse the correct date string
      date: DateTime.tryParse(data[dateKey] as String? ?? '') ?? DateTime.now(),
      imageUrl: data['Image'] as String? ?? '', // The image URL
      // Get the status from the map (which is injected in the fetch function)
      status: data['status'] as String? ?? 'Unknown',
    );
  }
}

// --- 🌟 REUSABLE ITEM LIST WIDGET ---

class ItemListWidget extends StatefulWidget {
  final String status; // 'Lost' or 'Found'

  const ItemListWidget({required this.status, super.key});

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  // Future to hold the result of the data fetching operation
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    // 🎯 INITIAL CALL: Start the initial data fetch
    _itemsFuture = _fetchItems();
  }

  // 🎯 WIDGET CHANGE: Refresh the data future if the status changes
  @override
  void didUpdateWidget(covariant ItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      // If the parent widget changed the status, re-fetch data
      _itemsFuture = _fetchItems();
    }
  }

  // 🌟 NEW: Fetch data based on the current status
  Future<List<Item>> _fetchItems() async {
    List<Map<String, dynamic>> rawData;

    try {
      if (widget.status == 'Lost') {
        // Fetch only Lost items
        // 🎯 FIX: Use ?? [] for null-safety from the service layer
        rawData = await SupabaseLostService.fetchLostItems() ?? [];
      } else {
        // Fetch only Found items
        // 🎯 FIX: Use ?? [] for null-safety from the service layer
        rawData = await SupabaseFoundService.fetchFoundItems() ?? [];
      }

      // Inject the status into the data maps
      final List<Map<String, dynamic>> dataWithStatus = rawData.map((row) {
        return {...row, 'status': widget.status};
      }).toList();

      // Convert the raw Supabase data into a List of Item objects
      List<Item> items = dataWithStatus
          .map((row) => Item.fromSupabase(row))
          .toList();

      // Sort the list by the date (most recent first)
      items.sort((a, b) => b.date.compareTo(a.date));

      return items;
    } catch (e) {
      print('Failed to fetch ${widget.status} items: $e');
      // Return an empty list on error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 REVISED: Use FutureBuilder with the List<Item> type
    return FutureBuilder<List<Item>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a spinner while data is loading
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          // General error or data is null/empty
          return const Center(
            child: Text('An error occurred while loading data.'),
          );
        }

        final items = snapshot.data!;

        if (items.isEmpty) {
          // Handle case where no items are returned
          return Center(
            child: Text(
              'No ${widget.status.toLowerCase()} items reported yet.',
            ),
          );
        }

        // Data successfully loaded and is not empty
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ItemCard(
              // 🎯 FIX: Use the Item object's properties directly
              id: item.id,
              name: item.itemName,
              location: item.location,
              // Format the date to a simple string for the card
              date: '${item.date.day}/${item.date.month}/${item.date.year}',
              category: item.category,
              imagePath: item.imageUrl,
              // Simple color logic based on the status (Lost = Blueish, Found = Amberish)
              imageColor: item.status == 'Lost'
                  ? Colors.lightBlue.shade200
                  : Colors.amber.shade200,
            );
          },
        );
      },
    );
  }
}

// --- Item Card Widget (Remains the same) ---

class ItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String date;
  final String category;
  final Color imageColor;
  final String imagePath;

  const ItemCard({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.category,
    required this.imageColor,
    required this.imagePath,
    super.key,
  });

  // Function to handle the tap event
  void _onCardTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Navigate to the ItemDescriptionScreen, passing the item's name
        builder: (context) => ItemDetailScreen(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the primary color from the main screen's defined color
    const Color cardCategoryColor = Color.fromARGB(255, 0, 150, 255);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () => _onCardTap(context),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Display Area
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: imageColor, // This acts as a background/fallback color
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // 🎯 FIX: Changed Image.asset to Image.network for Supabase URLs
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover, // Ensures the image fills the container
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red.shade100,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Category Tag (Styled with the new theme color)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: cardCategoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: cardCategoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
