import 'package:flutter/material.dart';

import 'home.dart';
import 'search_bar.dart';
import 'search_lost.dart';
import 'item_description.dart'; // Assuming this imports the ItemDescriptionScreen

// --- Main Screen Code: search_found.dart ---

class SearchFound extends StatelessWidget {
  const SearchFound({super.key});

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
          // Tab bar look-alike custom widget, with Found Items active
          _LostFoundToggle(),
          // List of found items
          Expanded(child: FoundItemsList()),
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
          // Lost Items Button (Inactive, clickable)
          Expanded(
            child: TextButton(
              onPressed: () {
                // Navigate to search_lost.dart
                // Use pushReplacement to avoid a growing stack when switching tabs
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SearchLost()),
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
                'Lost Items',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Found Items Button (Active)
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
                  'Found Items',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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

// --- Found Items List Widget ---

class FoundItemsList extends StatelessWidget {
  const FoundItemsList({super.key});

  final List<Map<String, String>> foundItems = const [
    {
      'name': 'Set of Keys',
      'location': 'Cafeteria Entrance',
      'date': 'Oct 12, 2025',
      'category': 'Keys',
      'categoryColor': 'green',
      'image': 'lib/images/key.jfif', // Asset path
    },
    {
      'name': 'Student ID Card',
      'location': 'Main Gate',
      'date': 'Oct 13, 2025',
      'category': 'Documents',
      'categoryColor': 'light_green',
      'image': 'lib/images/card.jfif', // Asset path
    },
    {
      'name': 'Water Bottle',
      'location': 'Gym',
      'date': 'Oct 13, 2025',
      'category': 'Accessories',
      'categoryColor': 'light_green',
      'image': 'lib/images/bottle.jfif', // Asset path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: foundItems.length,
      itemBuilder: (context, index) {
        final item = foundItems[index];
        return FoundItemCard(
          name: item['name']!,
          location: item['location']!,
          date: item['date']!,
          category: item['category']!,
          imagePath: item['image']!,
          // These are for color-coding the images/tags
          imageColor: index == 0
              ? Colors.grey.shade400
              : index == 1
              ? Colors.blueGrey
              : Colors.lightBlue.shade200,
          categoryColor: item['categoryColor']! == 'green'
              ? Colors.lightGreen.shade400
              : Colors.lightGreen.shade200,
        );
      },
    );
  }
}

// --- Item Card Widget (Updated with InkWell) ---

class FoundItemCard extends StatelessWidget {
  final String name;
  final String location;
  final String date;
  final String category;
  final Color imageColor;
  final Color categoryColor;
  final String imagePath;

  const FoundItemCard({
    required this.name,
    required this.location,
    required this.date,
    required this.category,
    required this.imageColor,
    required this.categoryColor,
    required this.imagePath,
    super.key,
  });

  // Function to handle the tap event
  void _onCardTap(BuildContext context) {
    // Navigate to the ItemDescriptionScreen, passing the item's name
    // This assumes ItemDescriptionScreen accepts an argument like the one
    // defined in the previous response.
    Navigator.of(context).push(
      MaterialPageRoute(
        // NOTE: We assume ItemDescriptionScreen has a constructor that accepts 'itemName'
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Ensures the image fills the container
                    // Consider adding a simple error builder for debugging:
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red.shade100,
                        child: const Center(
                          child: Text(
                            'Image Error',
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
                        // Category Tag (Green styling)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.black87,
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
