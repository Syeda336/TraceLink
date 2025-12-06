import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Import your ThemeProvider
import '../supabase_lost_service.dart'; // 🌟 Import the new service
import '../supabase_found_service.dart'; // 🌟 Import the new service

// --- 1. DATA MODEL (UPDATED FOR SUPABASE) ---
// Defines the structure for each item, matching Supabase columns.
class Item {
  final int id;
  // Column names from your Supabase table
  final String itemName; // Matches 'Item Name'
  final String category;
  final String color;
  final String description;
  final String location;
  final DateTime dateLost; // Matches 'Date Lost' (or Date Found)
  final String imageUrl; // Matches 'Image' (the URL)

  // 🎯 FIX 1: Add status field and remove the hardcoded value
  final String status;

  Item({
    required this.id,
    required this.itemName,
    required this.category,
    required this.color,
    required this.description,
    required this.location,
    required this.dateLost,
    required this.imageUrl,
    // 🎯 FIX 1: Require status in the constructor
    required this.status,
  });

  // 🌟 Factory constructor to create an Item from a Supabase row (Map)
  // The 'status' is now expected to be INJECTED into the data map
  factory Item.fromSupabase(Map<String, dynamic> data) {
    return Item(
      id: data['id'],
      itemName: data['Item Name'] as String? ?? 'N/A',
      category: data['Category'] as String? ?? 'N/A',
      color: data['Color'] as String? ?? 'N/A',
      description: data['Description'] as String? ?? 'N/A',
      location: data['Location'] as String? ?? 'N/A',
      // Supabase dates are usually ISO strings
      dateLost:
          DateTime.tryParse(data['Date Lost'] as String? ?? '') ??
          DateTime.now(),
      imageUrl: data['Image'] as String? ?? '', // The image URL
      // 🎯 FIX 2: Get the status from the map (which is injected in the fetch function)
      status: data['status'] as String? ?? 'Unknown',
    );
  }
}

// --- 2. SEARCH SCREEN ---

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // --- THEME COLORS (Fallback for the Lost/Found app style) ---
  final Color _lightBlueBackground = const Color(0xFFF0F8FF);
  final Color _brightBluePrimary = const Color(0xFF1E90FF);
  final Color _deepBlueBottom = const Color(0xFF007FFF);
  final Color _darkBlueText = const Color(0xFF00008B);
  final Color _whiteTextColor = Colors.white;

  // --- 🌟 STATE VARIABLES (MODIFIED) ---
  List<Item> _masterItems = []; // 🌟 Initialized as empty
  bool _isLoading = true; // 🌟 Loading state
  bool _hasError = false; // 🌟 Error state

  String _searchQuery = '';
  List<Item> _filteredItems = [];
  Map<String, dynamic> _activeFilters = {
    'itemType': 'All Items',
    'categories': <String>{},
    'colors': <String>{},
    'dateRangeDays': 30.0,
    'location': 'All Locations',
  };

  @override
  void initState() {
    super.initState();
    _fetchItemsFromSupabase(); // 🌟 Start data fetching
  }

  // 🌟 NEW: Fetch data from Supabase
  Future<void> _fetchItemsFromSupabase() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 1. Fetch data from both tables concurrently (for better performance)
      final lostItemsFuture = SupabaseLostService.fetchLostItems();
      final foundItemsFuture = SupabaseFoundService.fetchFoundItems();

      // Wait for both futures to complete
      final List<Map<String, dynamic>> lostData = await lostItemsFuture;
      final List<Map<String, dynamic>> foundData = await foundItemsFuture;

      // 🎯 FIX 3: Inject the status into the data maps
      final List<Map<String, dynamic>> lostItemsWithStatus = lostData.map((
        row,
      ) {
        return {...row, 'status': 'Lost'};
      }).toList();

      final List<Map<String, dynamic>> foundItemsWithStatus = foundData.map((
        row,
      ) {
        return {...row, 'status': 'Found'};
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

      setState(() {
        _masterItems = items;
        _isLoading = false;
      });

      // Apply filters to the newly fetched data
      _applySearchAndFilters();
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // --- FILTERING AND SEARCH LOGIC (MODIFIED FOR STATUS) ---
  void _applySearchAndFilters() {
    setState(() {
      List<Item> tempItems = List.from(_masterItems);

      // 1. Apply Filtering Logic
      tempItems = tempItems.where((item) {
        // 🎯 FIX 4: Update the status filtering logic
        // Filter by Item Type (Lost/Found)
        if (_activeFilters['itemType'] == 'Lost Items Only' &&
            item.status != 'Lost') {
          return false;
        }
        if (_activeFilters['itemType'] == 'Found Items Only' &&
            item.status != 'Found') {
          return false;
        }
        // ... (Rest of the filtering logic is the same) ...
        // Filter by Categories
        Set<String> selectedCategories = _activeFilters['categories'];
        if (selectedCategories.isNotEmpty &&
            !selectedCategories.contains(item.category)) {
          return false;
        }

        // Filter by Colors
        Set<String> selectedColors = _activeFilters['colors'];
        if (selectedColors.isNotEmpty && !selectedColors.contains(item.color)) {
          return false;
        }

        // Filter by Location
        String selectedLocation = _activeFilters['location'];
        if (selectedLocation != 'All Locations' &&
            item.location != selectedLocation) {
          return false;
        }

        // Filter by Date Range (e.g., last X days)
        double days = _activeFilters['dateRangeDays'];
        DateTime cutoffDate = DateTime.now().subtract(
          Duration(days: days.round()),
        );
        // Use item.dateLost (or dateFound, but the model calls it dateLost)
        if (item.dateLost.isBefore(cutoffDate)) {
          return false;
        }

        return true;
      }).toList();

      // 2. Apply Search Query Logic (and display matches on top)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();

        // Filter the remaining items by search query
        tempItems = tempItems.where((item) {
          return item.itemName.toLowerCase().contains(
                query,
              ) || // 🌟 Use itemName
              item.category.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query);
        }).toList();
      }

      // 3. Update the displayed list
      _filteredItems = tempItems;
    });
  }

  // --- Helper Function to Open Filters as a Bottom Sheet (UNCHANGED) ---
  void _openFiltersSection() {
    // Access the current theme provider
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Dynamic colors based on the provider state
    final Color primaryColor = themeProvider.isDarkMode
        ? const Color.fromARGB(255, 10, 49, 122)
        : _brightBluePrimary;
    final Color textColor = themeProvider.isDarkMode
        ? Colors.white
        : _darkBlueText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterSectionContent(
          brightBluePrimary: primaryColor, // Pass dynamic color
          darkBlueText: textColor, // Pass dynamic text color
          initialFilters: _activeFilters,
          onApplyFilters: (newFilters) {
            // Update the state with new filters and re-apply search/filters
            setState(() {
              _activeFilters = newFilters;
            });
            _applySearchAndFilters();
          },
        );
      },
    );
  }

  // --- Helper function to build the Category/Color filter rows (UNCHANGED) ---
  Widget _buildFilterRow({
    required String title,
    required List<String> filters,
    required String selectedFilter,
    required Function(String) onChipSelected,
    required Color primaryColor,
    required Color secondaryColor,
    required Color lightBackgroundColor,
    required Color darkTextColor,
    required Color whiteTextColor,
  }) {
    // ... (Widget implementation remains the same) ...
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkTextColor, // Use dynamic text color
            ),
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
                    selectedColor: primaryColor, // Use dynamic primary color
                    backgroundColor:
                        lightBackgroundColor, // Use dynamic background color
                    labelStyle: TextStyle(
                      color: isSelected
                          ? whiteTextColor
                          : darkTextColor, // Use dynamic colors
                    ),
                    onSelected: (bool selected) {
                      if (selected) {
                        onChipSelected(filter);
                        _openFiltersSection();
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
    // ⭐️ Access the ThemeProvider state
    final themeProvider = Provider.of<ThemeProvider>(context);

    // ⭐️ Dynamically determine colors based on the theme state
    final Color primaryColor = themeProvider.isDarkMode
        ? Colors.green.shade700
        : _brightBluePrimary;
    final Color secondaryColor = themeProvider.isDarkMode
        ? Colors.green.shade900
        : _deepBlueBottom;
    final Color backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF121212)
        : _lightBlueBackground;
    final Color textColor = themeProvider.isDarkMode
        ? Colors.white
        : _darkBlueText;
    final Color cardColor = themeProvider.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    // 🌟 Conditional content based on loading/error state
    Widget content;
    if (_isLoading) {
      content = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Loading items...'),
            ),
          ],
        ),
      );
    } else if (_hasError) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Failed to load items. Check your Supabase connection.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _fetchItemsFromSupabase,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (_filteredItems.isEmpty) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No items found matching your search and filters.'),
        ),
      );
    } else {
      // Normal content (Filters and GridView)
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterRow(
            title: 'Category',
            filters: const [
              'All',
              'Electronics',
              'Accessories',
              'Documents',
              'Clothing',
              'Keys', // Added Keys for completeness
            ],
            selectedFilter: 'All',
            onChipSelected: (newCategory) {},
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            lightBackgroundColor: cardColor,
            darkTextColor: textColor,
            whiteTextColor: _whiteTextColor,
          ),
          _buildFilterRow(
            title: 'Color',
            filters: const ['All', 'Black', 'Blue', 'Red', 'Brown', 'Silver'],
            selectedFilter: 'All',
            onChipSelected: (newColor) {},
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            lightBackgroundColor: cardColor,
            darkTextColor: textColor,
            whiteTextColor: _whiteTextColor,
          ),

          // --- Results Count ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_filteredItems.length} items found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          // --- Item Cards Grid ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.6,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return _ItemCard(
                  id: item.id,
                  status: item.status, // 🎯 FIX 5: Use the actual status
                  itemName: item.itemName, // 🌟 Use itemName
                  location: item.location,
                  date:
                      '${item.dateLost.month}/${item.dateLost.day}/${item.dateLost.year}', // 🌟 Use dateLost
                  isLost:
                      item.status == 'Lost', // 🎯 FIX 5: Use the actual status
                  statusColor: primaryColor,
                  // 🌟 Use Image.network for the URL
                  imageWidget: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    // Optional: Placeholder while loading
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          // 🎯 FIX: Use cumulativeBytesLoaded instead of cumulativeProgress
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  cardColor: cardColor,
                  darkTextColor: textColor,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    // 🌟 Main Build structure with dynamic content
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 🌟 SliverAppBar remains the same
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
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
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: _whiteTextColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Search Items',
                            style: TextStyle(
                              color: _whiteTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Search Bar and Filter Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: _whiteTextColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                  _applySearchAndFilters();
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(color: textColor),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: textColor,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Filter Button (Opens filter section)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.tune, color: _whiteTextColor),
                              onPressed: _openFiltersSection,
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
          // 🌟 SliverList with the conditional content
          SliverList(delegate: SliverChildListDelegate([content])),
        ],
      ),
    );
  }
}

// --- Item Card Widget (Remains the same, but receives network image) ---
class _ItemCard extends StatelessWidget {
  final int id;
  final String status;
  final String itemName;
  final String location;
  final String date;
  final bool isLost;
  final Widget imageWidget; // This will be Image.network
  final Color statusColor;
  final Color cardColor;
  final Color darkTextColor;

  const _ItemCard({
    required this.id,
    required this.status,
    required this.itemName,
    required this.location,
    required this.date,
    required this.isLost,
    required this.statusColor,
    required this.imageWidget,
    required this.cardColor,
    required this.darkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // Lost items use the main statusColor (dynamic). Found items use green.
    // 🎯 FIX 6: Use status to determine the tag color
    final Color tagColor = isLost ? statusColor : Colors.green;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor, // Use dynamic card color
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
                      child: imageWidget, // 🌟 The network image widget
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagColor,
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ID: ${id}', // Display the Item ID
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkTextColor,
                      ),
                    ),
                    Text(
                      itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkTextColor, // Use dynamic text color
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: darkTextColor.withOpacity(
                          0.7,
                        ), // Use dynamic text color
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: darkTextColor.withOpacity(
                          0.7,
                        ), // Use dynamic text color
                        fontSize: 14,
                      ),
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

// -----------------------------------------------------
// --- 3. FILTER SECTION CONTENT (MODAL) (UNCHANGED) ---
// -----------------------------------------------------
// ... (The FilterSectionContent and its helper widgets remain exactly the same) ...

class FilterSectionContent extends StatefulWidget {
  final Color brightBluePrimary;
  final Color darkBlueText;
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterSectionContent({
    super.key,
    required this.brightBluePrimary,
    required this.darkBlueText,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterSectionContent> createState() => _FilterSectionContentState();
}

class _FilterSectionContentState extends State<FilterSectionContent> {
  late String _selectedItemType;
  late Set<String> _selectedCategories;
  late Set<String> _selectedColors;
  late double _dateRangeValue;
  late String _selectedLocation;

  // Global list of all possible filter options
  final List<String> _allCategories = [
    'Electronics',
    'Accessories',
    'Documents',
    'Clothing',
    'Keys',
    'Books',
  ];
  final Map<String, Color> _allColors = {
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Red': Colors.red,
    'Brown': const Color(0xFF8B4513),
    'Silver': Colors.grey,
    'White': Colors.white,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
  };
  final List<String> _allLocations = [
    'All Locations',
    'Library',
    'Computer Lab',
    'Cafeteria',
    'Gym',
    'Classroom',
    'Parking Lot',
  ];

  @override
  void initState() {
    super.initState();
    // Safely initialize state variables using null-aware operators
    _selectedItemType = widget.initialFilters['itemType'] ?? 'All Items';
    _selectedCategories = Set<String>.from(
      widget.initialFilters['categories'] ?? {},
    );
    _selectedColors = Set<String>.from(widget.initialFilters['colors'] ?? {});
    _dateRangeValue = widget.initialFilters['dateRangeDays'] ?? 30.0;
    _selectedLocation = widget.initialFilters['location'] ?? 'All Locations';
  }

  // --- Functions for user interaction (apply/reset) ---

  void _applyFilters() {
    // 1. Compile the final filter map
    final Map<String, dynamic> finalFilters = {
      'itemType': _selectedItemType,
      'categories': _selectedCategories,
      'colors': _selectedColors,
      'dateRangeDays': _dateRangeValue,
      'location': _selectedLocation,
    };

    // 2. Call the callback function in the parent screen to update the search results
    widget.onApplyFilters(finalFilters);

    // 3. Show success and close
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Filters applied successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();
    });
  }

  void _resetFilters() {
    // 1. Reset local state variables to default "All" settings
    setState(() {
      _selectedItemType = 'All Items';
      _selectedCategories.clear();
      _selectedColors.clear();
      _dateRangeValue = 30.0;
      _selectedLocation = 'All Locations';
    });

    // 2. Manually construct the map representing the default/reset state
    final Map<String, dynamic> resetFilters = {
      'itemType': 'All Items',
      'categories': <String>{}, // Empty set
      'colors': <String>{}, // Empty set
      'dateRangeDays': 30.0,
      'location': 'All Locations',
    };

    // 3. CRITICAL FIX: Call the callback function with the reset map
    // This immediately tells the parent screen to refresh and show all items.
    widget.onApplyFilters(resetFilters);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Filters have been reset. Displaying all items.'),
        duration: Duration(milliseconds: 1500),
      ),
    );

    // 4. Close the modal
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildFilterCard(
                      title: 'Item Type',
                      content: _buildItemTypeSelector(),
                    ),
                    _buildFilterCard(
                      title: 'Categories',
                      content: _buildCategoriesSelector(),
                    ),
                    _buildFilterCard(
                      title: 'Colors',
                      content: _buildColorsSelector(),
                    ),
                    _buildFilterCard(
                      title: 'Date Range',
                      content: _buildDateRangeSelector(),
                    ),
                    _buildFilterCard(
                      title: 'Location',
                      content: _buildLocationSelector(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // --- Helper Widgets for the Filter Section ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.brightBluePrimary,
            widget.brightBluePrimary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Refine your search results',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.darkBlueText,
                ),
              ),
              const SizedBox(height: 15),
              content,
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: Item Type (Radio buttons)
  Widget _buildItemTypeSelector() {
    return Column(
      children: [
        _buildItemTypeOption(
          'All Items',
          Colors.black,
          _selectedItemType == 'All Items',
        ),
        _buildItemTypeOption(
          'Lost Items Only',
          widget.brightBluePrimary,
          _selectedItemType == 'Lost Items Only',
          label: 'Lost',
        ),
        _buildItemTypeOption(
          'Found Items Only',
          Colors.green,
          _selectedItemType == 'Found Items Only',
          label: 'Found',
        ),
      ],
    );
  }

  Widget _buildItemTypeOption(
    String value,
    Color activeColor,
    bool isSelected, {
    String? label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _selectedItemType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedItemType = newValue!;
              });
            },
            activeColor: activeColor,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: widget.darkBlueText),
          ),
          if (label != null) const SizedBox(width: 8),
          if (label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // Section 2: Categories (Checkboxes)
  Widget _buildCategoriesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _allCategories
          .map(
            (category) => _CategoryCheckbox(
              label: category,
              activeColor: widget.brightBluePrimary,
              isChecked: _selectedCategories.contains(category),
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue == true) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            ),
          )
          .toList(),
    );
  }

  // Section 3: Colors (Checkboxes grid)
  Widget _buildColorsSelector() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 5,
      children: _allColors.entries
          .map(
            (entry) => _ColorCheckbox(
              label: entry.key,
              color: entry.value,
              activeColor: widget.brightBluePrimary,
              isChecked: _selectedColors.contains(entry.key),
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue == true) {
                    _selectedColors.add(entry.key);
                  } else {
                    _selectedColors.remove(entry.key);
                  }
                });
              },
            ),
          )
          .toList(),
    );
  }

  // Section 4: Date Range (Slider)
  Widget _buildDateRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Last ${_dateRangeValue.round()} days',
              style: TextStyle(
                color: widget.brightBluePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.brightBluePrimary,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10.0,
              disabledThumbRadius: 10.0,
            ),
            trackHeight: 8.0,
          ),
          child: Slider(
            value: _dateRangeValue,
            min: 1,
            max: 30,
            divisions: 29,
            onChanged: (double newValue) {
              setState(() {
                _dateRangeValue = newValue;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 day',
                style: TextStyle(color: widget.darkBlueText.withOpacity(0.7)),
              ),
              Text(
                '30 days',
                style: TextStyle(color: widget.darkBlueText.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Section 5: Location (Chips)
  Widget _buildLocationSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _allLocations.map((location) {
        final bool isSelected = _selectedLocation == location;
        return ActionChip(
          label: Text(location),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : widget.darkBlueText,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: isSelected ? widget.brightBluePrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? widget.brightBluePrimary
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedLocation = location;
            });
          },
        );
      }).toList(),
    );
  }

  // Bottom action bar
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Reset Button
          Expanded(
            child: OutlinedButton(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(
                  color: widget.brightBluePrimary.withOpacity(0.7),
                ),
                foregroundColor: widget.darkBlueText,
              ),
              child: const Text('Reset', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 15),
          // Apply Filters Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.brightBluePrimary,
              ),
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

// --- Reusable Widgets for Checkboxes (Stateless) (UNCHANGED) ---

class _CategoryCheckbox extends StatelessWidget {
  final String label;
  final Color activeColor;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const _CategoryCheckbox({
    required this.label,
    required this.activeColor,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: activeColor,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ColorCheckbox extends StatelessWidget {
  final String label;
  final Color color;
  final Color activeColor;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const _ColorCheckbox({
    required this.label,
    required this.color,
    required this.activeColor,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: color == Colors.white
                ? Border.all(color: Colors.grey.shade400)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
