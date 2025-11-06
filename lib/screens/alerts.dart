import 'package:flutter/material.dart';

class EmergencyAlerts extends StatelessWidget {
  const EmergencyAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 180, // Adjusted height for the header content
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // Vibrant, dark colors similar to the image
                  colors: [Color(0xFFFF5200), Color(0xFFE50914)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // Go back to the previous screen
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Emergency Alerts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'High-priority lost items that need urgent attention',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20), // Space after the header
              // Item from Image 2: Student ID - John Martinez
              _AlertItemCard(
                itemName: 'Student ID - John Martinez',
                description:
                    'Lost student ID card with photo. Urgent - needed for...',
                location: 'Main Building, Room 305',
                timeAgo: '15 min ago',
                views: '45 views',
                isHighPriority: true,
                // Placeholder for image
                imageWidget: Image.asset(
                  'lib/images/key.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16), // Space between cards
              // Item from Image 1 (Top): MacBook Pro 16"
              _AlertItemCard(
                itemName: 'MacBook Pro 16"',
                description:
                    'Silver MacBook Pro left in library. Contains important...',
                location: 'Library, Study Room 12',
                timeAgo: '1h ago',
                views: '89 views',
                isHighPriority: true,
                // Placeholder for image
                imageWidget: Image.asset(
                  'lib/images/key.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16), // Space between cards
              // Item from Image 1 (Bottom): Prescription Glasses
              _AlertItemCard(
                itemName: 'Prescription Glasses',
                description:
                    'Black frame glasses in blue case. Cannot see without...',
                location: 'Cafeteria, Table near window',
                timeAgo: '2h ago',
                views: '34 views',
                isHighPriority:
                    false, // This one is 'Priority' not 'High Priority'
                // Placeholder for image
                imageWidget: Image.asset(
                  'lib/images/key.jfif',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20), // Padding at the bottom
            ]),
          ),
        ],
      ),
    );
  }
}

// --- Alert Item Card Widget ---
class _AlertItemCard extends StatelessWidget {
  final String itemName;
  final String description;
  final String location;
  final String timeAgo;
  final String views;
  final bool isHighPriority;
  final Widget imageWidget; // Widget for the image placeholder

  const _AlertItemCard({
    required this.itemName,
    required this.description,
    required this.location,
    required this.timeAgo,
    required this.views,
    required this.isHighPriority,
    required this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the priority tag text and color
    final String priorityText = isHighPriority ? 'High Priority' : 'Priority';
    final Color priorityColor = isHighPriority
        ? const Color(0xFFDC3545)
        : Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Image/Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200], // Background for placeholder
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageWidget, // Use the passed imageWidget
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  priorityText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.watch_later_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.remove_red_eye_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                views,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle "Mark as Seen"
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mark as Seen',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Report Sighting"
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(
                            0xFFFF5200,
                          ), // Vibrant red/orange
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Report Sighting',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Placeholder Widget for Images ---
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.3), // A subtle background color
      child: Center(child: Icon(icon, size: 60, color: color)),
    );
  }
}
