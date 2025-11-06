import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen
import 'item_description.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- Fixed Header (Community Feed) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  // Back Arrow Button (Top Left Corner Button)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                  const Text(
                    'Community Feed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // --- Feed Content (Ordered as requested in previous prompt) ---
          SliverList(
            delegate: SliverChildListDelegate([
              // 1. Post by Sarah Johnson - Found: Set of Keys
              _FeedPostCard(
                userInitials: 'SJ',
                userName: 'Sarah Johnson',
                timeAgo: '2h ago',
                status: 'Found',
                isVerified: true,
                postText:
                    'Found these keys near the cafeteria entrance. They have a blue keychain.',
                location: 'Cafeteria Entrance',
                likes: 12,
                comments: 3,
                imageWidget: Image.asset(
                  'lib/images/key.jfif',
                  fit: BoxFit.cover,
                ),
              ),

              // 2. Post by Mike Chen - Lost: Blue Backpack
              _FeedPostCard(
                userInitials: 'MC',
                userName: 'Mike Chen',
                timeAgo: '5h ago',
                status: 'Lost',
                isVerified: true,
                postText:
                    'Lost my blue Jansport backpack in the Science Building. Contains textbooks and a laptop.',
                location: 'Science Building',
                likes: 8,
                comments: 5,
                imageWidget: Image.asset(
                  'lib/images/blue_backpack.jfif',
                  fit: BoxFit.cover,
                ),
              ),

              // 3. Post by Emma Wilson - Found: Student ID
              _FeedPostCard(
                userInitials: 'EW',
                userName: 'Emma Wilson',
                timeAgo: '1d ago',
                status: 'Found',
                isVerified: false,
                postText:
                    'Found a student ID card at the main gate. Please DM me to claim.',
                location: 'Main Gate',
                likes: 24,
                comments: 7,
                imageWidget: Image.asset(
                  'lib/images/card.jfif',
                  fit: BoxFit.cover,
                ),
              ),

              // 4. Post by Emma Wilson - Found: Wallet (from image that showed user detail)
              _FeedPostCard(
                userInitials: 'EW',
                userName: 'Emma Wilson',
                timeAgo: '1d ago',
                status: 'Found',
                isVerified: false,
                postText:
                    'Found a black wallet near the main entrance. It contains several cards. Please contact me to describe and claim.',
                location: 'Main Entrance',
                likes: 42,
                comments: 11,
                imageWidget: Image.asset(
                  'lib/images/black_wallet.jfif',
                  fit: BoxFit.cover,
                ),
              ),

              // Add more feed posts as needed for a complete feed...
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}

// --- Feed Post Card Widget ---
class _FeedPostCard extends StatelessWidget {
  final String userInitials;
  final String userName;
  final String timeAgo;
  final String status;
  final bool isVerified;
  final String postText;
  final String location;
  final int likes;
  final int comments;
  final Widget imageWidget;

  const _FeedPostCard({
    required this.userInitials,
    required this.userName,
    required this.timeAgo,
    required this.status,
    required this.isVerified,
    required this.postText,
    required this.location,
    required this.likes,
    required this.comments,
    required this.imageWidget,
  });

  // Simple function to extract item name from the first sentence
  String _itemNameFromPostText(String text) {
    if (text.startsWith('Found these keys')) return 'Set of Keys';
    if (text.startsWith('Lost my blue')) return 'Blue Backpack';
    if (text.startsWith('Found a student ID')) return 'Student ID';
    if (text.startsWith('Found a black wallet')) return 'Black Wallet';
    return 'Item';
  }

  // --- NEW: Function to handle the image tap action ---
  void _openItemDescription(BuildContext context) {
    final itemName = _itemNameFromPostText(postText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(itemName: itemName),
      ),
    );
  }
  // --- END NEW FUNCTION ---

  @override
  Widget build(BuildContext context) {
    final bool isLost = status == 'Lost';
    final Color statusColor = isLost ? const Color(0xFF9932CC) : Colors.green;
    final Color initialsColor = isLost ? Colors.purple : Colors.pink;
    final String itemName = _itemNameFromPostText(
      postText,
    ); // Get item name once

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info and Status Tag
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: initialsColor.withOpacity(0.8),
                  child: Text(
                    userInitials,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isVerified)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      Text(timeAgo, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Post Image/Content - WRAPPED IN GESTUREDETECTOR
          GestureDetector(
            onTap: () => _openItemDescription(context), // <--- NEW
            child: SizedBox(
              width: double.infinity,
              height: 600,
              child: ClipRRect(
                child: imageWidget, // Placeholder or actual image
              ),
            ),
          ),
          // END IMAGE WRAP

          // Post Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${status}: $itemName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(postText, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),

          // Footer: Location and Actions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Likes
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text('$likes', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    // Comments
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text('$comments', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    // Share
                    const Icon(
                      Icons.share_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Placeholder Widget for Images (Used in the Feed) ---
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({
    required this.color,
    required this.icon,
    super.key,
  }); // Added super.key

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.3),
      child: Center(child: Icon(icon, size: 60, color: color)),
    );
  }
}
