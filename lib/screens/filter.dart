import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // --- State Variables to manage filter selections ---
  // Item Type
  String _selectedItemType = 'All Items';
  // Date Range (Representing the slider value)
  double _dateRangeValue = 7.0; // Default to 7 days
  // Location
  String _selectedLocation = 'Cafeteria'; // Default selected location

  // --- Functions for user interaction ---

  // Handles the logic for closing the screen after applying filters
  void _applyFilters() {
    // 1. Show the success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Filters applied successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // 2. Close the screen (Pop) after a short delay for the SnackBar
    Future.delayed(const Duration(milliseconds: 500), () {
      // Pass the filters back if needed, here we just close the screen
      Navigator.of(context).pop();
    });
  }

  // Handles the logic for resetting filters
  void _resetFilters() {
    setState(() {
      _selectedItemType = 'All Items';
      _dateRangeValue = 7.0;
      _selectedLocation = ''; // Clear selected location
      // In a real app, you'd reset checkboxes and other states here too
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Filters have been reset.'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The images suggest a purple/pink gradient background for the top of the modal/screen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Header (Filters and X button) ---
              _buildHeader(),

              // --- Scrolling Content ---
              Expanded(
                child: Container(
                  // Use a white container for the content area to match the image style
                  decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ), // Space for the bottom buttons
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Section 1: Item Type (Image 2)
                        _buildFilterCard(
                          title: 'Item Type',
                          content: _buildItemTypeSelector(),
                        ),

                        // Section 2: Categories (Image 2 + Image 3)
                        _buildFilterCard(
                          title: 'Categories',
                          content: _buildCategoriesSelector(),
                        ),

                        // Section 3: Colors (Image 3)
                        _buildFilterCard(
                          title: 'Colors',
                          content: _buildColorsSelector(),
                        ),

                        // Section 4: Date Range (Image 1)
                        _buildFilterCard(
                          title: 'Date Range',
                          content: _buildDateRangeSelector(),
                        ),

                        // Section 5: Location (Image 4)
                        _buildFilterCard(
                          title: 'Location',
                          content: _buildLocationSelector(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- Bottom Bar (Reset and Apply) ---
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
            onPressed: () => Navigator.of(context).pop(), // Close screen on 'x'
          ),
        ],
      ),
    );
  }

  // Card wrapper style used for all sections
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
          const Color(0xFF8E2DE2),
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
          Text(value, style: const TextStyle(fontSize: 16)),
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
      children: const [
        // Part 1 (Image 2)
        _CategoryCheckbox('Electronics'),
        _CategoryCheckbox('Accessories'),
        SizedBox(height: 10),
        // Part 2 (Image 3 - continuation)
        _CategoryCheckbox('Documents'),
        _CategoryCheckbox('Clothing'),
        _CategoryCheckbox('Keys'),
        _CategoryCheckbox('Books'),
      ],
    );
  }

  // Section 3: Colors (Checkboxes grid)
  Widget _buildColorsSelector() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3, // Control the height of the rows
      crossAxisSpacing: 10,
      mainAxisSpacing: 5,
      children: const [
        _ColorCheckbox('Black', Colors.black),
        _ColorCheckbox('Blue', Colors.blue),
        _ColorCheckbox('Red', Colors.red),
        _ColorCheckbox('Brown', Color(0xFF8B4513)), // Deep brown
        _ColorCheckbox('Silver', Colors.grey),
        _ColorCheckbox('White', Colors.white),
        _ColorCheckbox('Green', Colors.green),
        _ColorCheckbox('Yellow', Colors.yellow),
      ],
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
              style: const TextStyle(
                color: Color(0xFF8E2DE2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 day', style: TextStyle(color: Colors.grey)),
              Text('30 days', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  // Section 5: Location (Chips)
  Widget _buildLocationSelector() {
    final List<String> locations = [
      'Library',
      'Computer Lab',
      'Cafeteria',
      'Gym',
      'Classroom',
      'Parking Lot',
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: locations.map((location) {
        final bool isSelected = _selectedLocation == location;
        return ActionChip(
          label: Text(location),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF8E2DE2) : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF8E2DE2)
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
            offset: const Offset(0, -3), // changes position of shadow
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
                side: BorderSide(color: Colors.grey.shade400),
                foregroundColor: Colors.black87,
              ),
              child: const Text('Reset', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 15),
          // Apply Filters Button (Gradient)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8E2DE2),
                    Color(0xFF4A00E0),
                  ], // Purple gradient
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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

// --- Reusable Widgets for Checkboxes ---

// Stateful widget for Category Checkboxes
class _CategoryCheckbox extends StatefulWidget {
  final String label;
  const _CategoryCheckbox(this.label);

  @override
  State<_CategoryCheckbox> createState() => _CategoryCheckboxState();
}

class _CategoryCheckboxState extends State<_CategoryCheckbox> {
  bool _isChecked = false;

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
              value: _isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked = newValue!;
                });
              },
              activeColor: const Color(0xFF4A00E0),
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Stateful widget for Color Checkboxes (with a color dot)
class _ColorCheckbox extends StatefulWidget {
  final String label;
  final Color color;
  const _ColorCheckbox(this.label, this.color);

  @override
  State<_ColorCheckbox> createState() => _ColorCheckboxState();
}

class _ColorCheckboxState extends State<_ColorCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                _isChecked = newValue!;
              });
            },
            activeColor: const Color(0xFF4A00E0),
          ),
        ),
        const SizedBox(width: 10),
        // Color dot visualization
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            border: widget.color == Colors.white
                ? Border.all(color: Colors.grey.shade400)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(widget.label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
