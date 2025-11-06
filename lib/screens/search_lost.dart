import 'package:flutter/material.dart';

import 'home.dart';
import 'search_bar.dart';
import 'search_found.dart';
import 'item_description.dart';

class SearchLost extends StatelessWidget {
  const SearchLost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set the background color to white to match the screenshot
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to home.dart
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Lost & Found',
          style: TextStyle(
            color: Colors.black,
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
                // Creates the purple circle background for the search icon
                color: Colors.deepPurple.shade100.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.deepPurple.shade700),
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
      body: const Column(
        children: [
          // Tab bar look-alike custom widget
          _LostFoundToggle(),
          // List of lost items
          Expanded(child: LostItemsList()),
        ],
      ),
    );
  }
}

// --- Custom Toggle for Lost/Found Tabs ---

class _LostFoundToggle extends StatelessWidget {
  const _LostFoundToggle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Lost Items Button (Active)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Lost Items',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Found Items Button (Inactive, clickable)
          Expanded(
            child: TextButton(
              onPressed: () {
                // Navigate to search_found.dart
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SearchFound()),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Found Items',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Lost Items List Widget ---

class LostItemsList extends StatelessWidget {
  const LostItemsList({super.key});

  final List<Map<String, String>> lostItems = const [
    {
      'name': 'Black Wallet',
      'location': 'Library, 2nd Floor',
      'date': 'Oct 10, 2025',
      'category': 'Accessories',
      'image': 'lib/images/black_wallet.jfif', // Asset path
    },
    {
      'name': 'Blue Backpack',
      'location': 'Science Building',
      'date': 'Oct 11, 2025',
      'category': 'Accessories',
      'image': 'lib/images/blue_backpack.jfif', // Asset path
    },
    {
      'name': 'MacBook Pro',
      'location': 'Computer Lab',
      'date': 'Oct 12, 2025',
      'category': 'Electronics',
      'image': 'lib/images/laptop.jfif', // Asset path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: lostItems.length,
      itemBuilder: (context, index) {
        final item = lostItems[index];
        return ItemCard(
          name: item['name']!,
          location: item['location']!,
          date: item['date']!,
          category: item['category']!,
          imagePath: item['image']!,
          imageColor: index == 0
              ? Colors
                    .blueGrey // Simulate black wallet image
              : index == 1
              ? Colors
                    .lightBlue
                    .shade200 // Simulate backpack image
              : Colors.grey.shade400, // Simulate laptop image
        );
      },
    );
  }
}

// --- Item Card Widget (Updated with InkWell) ---

class ItemCard extends StatelessWidget {
  final String name;
  final String location;
  final String date;
  final String category;
  final Color imageColor;
  final String imagePath;

  const ItemCard({
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
        builder: (context) => ItemDetailScreen(itemName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      // **NEW: Use InkWell to make the entire card clickable**
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
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Ensures the image fills the container
                    // Using an errorBuilder for better debugging if the asset is missing
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red.shade100,
                        child: const Center(
                          child: Text(
                            'Asset\nError',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
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
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
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
