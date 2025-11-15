import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // For loading local assets/files
import 'dart:convert'; // For JSON decoding

import 'bottom_navigation.dart';
import 'search_bar.dart';
import 'item_description.dart'; // Assuming this holds ItemDetailScreen/ItemDescriptionScreen

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
            child: _isLostSelected
                ? const LostItemsList() // Shows Lost Items
                : const FoundItemsList(), // Shows Found Items
          ),
        ],
      ),
    );
  }
}

// --- Custom Toggle for Lost/Found Tabs (Stateless, receives callbacks) ---

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

// --- JSON Data Loading Function ---

// Helper function to load and decode JSON data from assets
Future<List<Map<String, dynamic>>> loadJsonData(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(response);
    // Cast the list elements to the expected type
    return data.cast<Map<String, dynamic>>();
  } catch (e) {
    // In a real app, you'd log this error
    print('Error loading JSON from $path: $e');
    return [];
  }
}

// --- Lost Items List Widget (Now loads data asynchronously) ---

class LostItemsList extends StatefulWidget {
  const LostItemsList({super.key});

  @override
  State<LostItemsList> createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  // Future to hold the result of the JSON loading operation
  late Future<List<Map<String, dynamic>>> _lostItemsFuture;

  @override
  void initState() {
    super.initState();
    // Start loading the data when the widget is created
    _lostItemsFuture = loadJsonData('lib/databases/lost_items.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _lostItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a spinner while data is loading
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if loading failed
          return Center(
            child: Text('Error loading lost items: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle case where file is empty or data is null
          return const Center(child: Text('No lost items reported yet.'));
        }

        // Data successfully loaded
        final lostItems = snapshot.data!;

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
              // Simple color logic based on index for variety
              imageColor: index == 0
                  ? Colors.blueGrey
                  : index == 1
                  ? Colors.lightBlue.shade200
                  : Colors.grey.shade400,
            );
          },
        );
      },
    );
  }
}

// --- Found Items List Widget (Now loads data asynchronously) ---

class FoundItemsList extends StatefulWidget {
  const FoundItemsList({super.key});

  @override
  State<FoundItemsList> createState() => _FoundItemsListState();
}

class _FoundItemsListState extends State<FoundItemsList> {
  // Future to hold the result of the JSON loading operation
  late Future<List<Map<String, dynamic>>> _foundItemsFuture;

  @override
  void initState() {
    super.initState();
    // Start loading the data when the widget is created
    _foundItemsFuture = loadJsonData('lib/databases/found_items.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _foundItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a spinner while data is loading
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if loading failed
          return Center(
            child: Text('Error loading found items: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle case where file is empty or data is null
          return const Center(child: Text('No items have been found yet.'));
        }

        // Data successfully loaded
        final foundItems = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: foundItems.length,
          itemBuilder: (context, index) {
            final item = foundItems[index];
            return ItemCard(
              name: item['name']!,
              location: item['location']!,
              date: item['date']!,
              category: item['category']!,
              imagePath: item['image']!,
              // Simple color logic based on index for variety
              imageColor: index == 0
                  ? Colors
                        .amber
                        .shade200 // Keys color
                  : index == 1
                  ? Colors
                        .blue
                        .shade100 // Card color
                  : Colors.green.shade100, // Bottle color
            );
          },
        );
      },
    );
  }
}

// --- Item Card Widget (Remains the same) ---

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
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover, // Ensures the image fills the container
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
