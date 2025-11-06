import 'package:flutter/material.dart';

// Import the hypothetical Home.dart screen
// Note: In a real app, you would need to define this screen.
import 'home.dart';
import 'filter.dart'; // Assumed to contain FiltersScreen

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // State variables for the horizontally scrolling filters
  String _selectedCategory = 'All';
  String _selectedColor = 'All';

  // --- Helper Function to Navigate to FiltersScreen ---
  void _openFiltersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const FiltersScreen(), // Opens the filter.dart screen
      ),
    );
  }

  // Helper function to build the Category/Color filter rows
  Widget _buildFilterRow({
    required String title,
    required List<String> filters,
    required String selectedFilter,
    required Function(String) onChipSelected, // Callback for chip selection
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = filter == selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: isSelected
                        ? const Color(0xFF8E2DE2)
                        : Colors.grey[200],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (bool selected) {
                      if (selected) {
                        // When a chip is selected, update the local state AND open the full filter screen
                        onChipSelected(filter);
                        _openFiltersScreen();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 120,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                // Gradient similar to the image background
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Back Arrow Button (Navigate to home.dart)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Functionality to open home.dart
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Search Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Search Bar and Filter Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Filter Button (Opens filter.dart/FiltersScreen)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.tune, color: Colors.black),
                              onPressed:
                                  _openFiltersScreen, // FIXED: Opens FiltersScreen
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // --- Category Filters ---
              _buildFilterRow(
                title: 'Category',
                filters: const [
                  'All',
                  'Electronics',
                  'Accessories',
                  'Documents',
                  'Cloth',
                ],
                selectedFilter: _selectedCategory,
                onChipSelected: (newCategory) {
                  setState(() {
                    _selectedCategory = newCategory;
                  });
                },
              ),
              // --- Color Filters ---
              _buildFilterRow(
                title: 'Color',
                filters: const [
                  'All',
                  'Black',
                  'Blue',
                  'Red',
                  'Brown',
                  'Silver',
                ],
                selectedFilter: _selectedColor,
                onChipSelected: (newColor) {
                  setState(() {
                    _selectedColor = newColor;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '4 items found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // --- Item Cards Grid ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.6,
                  children: [
                    // Item Card 1: Lost Backpack
                    _ItemCard(
                      status: 'Lost',
                      itemName: 'Backpack',
                      location: 'Cafeteria',
                      date: 'Oct 12, 2025',
                      isLost: true,
                      imageWidget: Image.asset(
                        'lib/images/blue_backpack.jfif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Item Card 2: Found Set of Keys
                    _ItemCard(
                      status: 'Found',
                      itemName: 'Set of Keys',
                      location: 'Gym',
                      date: 'Oct 12, 2025',
                      isLost: false,
                      imageWidget: Image.asset(
                        'lib/images/key.jfif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Item Card 3: Lost MacBook Pro
                    _ItemCard(
                      status: 'Lost',
                      itemName: 'MacBook Pro',
                      location: 'Computer Lab',
                      date: 'Oct 10, 2025',
                      isLost: true,
                      imageWidget: Image.asset(
                        'lib/images/laptop.jfif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Item Card 4: Found Wallet
                    _ItemCard(
                      status: 'Found',
                      itemName: 'Wallet',
                      location: 'Library',
                      date: 'Oct 11, 2025',
                      isLost: false,
                      // Note: I'm keeping the Image.asset here, assuming you have a dummy asset setup in your project
                      imageWidget: Image.asset(
                        'lib/images/black_wallet.jfif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}

// --- Item Card Widget (Remains the same) ---
class _ItemCard extends StatelessWidget {
  final String status;
  final String itemName;
  final String location;
  final String date;
  final bool isLost;
  final Widget imageWidget;

  const _ItemCard({
    required this.status,
    required this.itemName,
    required this.location,
    required this.date,
    required this.isLost,
    required this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the status tag color
    final Color statusColor = isLost ? const Color(0xFF9932CC) : Colors.green;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image/Placeholder
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: imageWidget,
                    ),
                  ),
                  // Status Tag (Lost/Found)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Item Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Widget for Images (Remains the same) ---
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      child: Center(child: Icon(icon, size: 60, color: color)),
    );
  }
}
