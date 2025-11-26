import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart'; // Import provider to access the theme
import '../theme_provider.dart'; // Import your dynamic theme provider
import '../supabase_lost_service.dart'; // 🌟 Import the new service
import '../supabase_found_service.dart'; // 🌟 Import the new service

// Assuming these files exist in your project structure
import 'home.dart';
import 'item_description.dart';

// --- Define the NEW Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// 🎯 FIX 1: Complete the Item model with sensible defaults and methods
class Item {
  // Column names from your Supabase table
  final String userInitials;
  final String userName;
  final String itemName; // Matches 'Item Name'
  final String category;
  final String color;
  final String description;
  final String location;
  final DateTime dateLost; // Matches 'Date Lost' (or Date Found)
  final String imageUrl; // Matches 'Image' (the URL)

  final String status; // 'Lost' or 'Found'

  // Variables for local state management (likes/comments)
  int likes;
  int comments;
  bool isLiked;

  // Added a placeholder for verification
  final bool isVerified;

  Item({
    required this.userInitials,
    required this.userName,
    required this.itemName,
    required this.category,
    required this.color,
    required this.description,
    required this.location,
    required this.dateLost,
    required this.imageUrl,
    required this.status,
    this.likes = 0, // sensible default
    this.comments = 0, // sensible default
    this.isLiked = false, // sensible default
    this.isVerified = true, // sensible default
  });

  // 🌟 Factory constructor to create an Item from a Supabase row (Map)
  factory Item.fromSupabase(Map<String, dynamic> data) {
    // 🎯 FIX 2: Default user info and placeholder values for missing data
    // In a real app, user data would be fetched separately via a user_id foreign key
    final defaultUserName = data['user_id'] != null
        ? 'User ${data['user_id'].toString().substring(0, 4)}'
        : 'Community User';
    final defaultInitials = defaultUserName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join('');

    return Item(
      userInitials: defaultInitials, // Placeholder/derived
      userName: defaultUserName, // Placeholder/derived
      itemName: data['Item Name'] as String? ?? 'N/A',
      category: data['Category'] as String? ?? 'N/A',
      color: data['Color'] as String? ?? 'N/A',
      description: data['Description'] as String? ?? 'N/A',
      location: data['Location'] as String? ?? 'N/A',
      // Supabase dates are usually ISO strings. Using 'Date Lost' for both for simplicity.
      dateLost:
          DateTime.tryParse(data['Date Lost'] as String? ?? '') ??
          DateTime.tryParse(data['Date Found'] as String? ?? '') ??
          DateTime.now(),
      imageUrl: data['Image'] as String? ?? '', // The image URL
      status: data['status'] as String? ?? 'Unknown',
      // Simulating likes/comments (In a real app, these would be fetched from separate tables)
      likes: (data['likes'] as int?) ?? 0,
      comments: (data['comments'] as int?) ?? 0,
      isLiked: (data['isLiked'] as bool?) ?? false,
      isVerified: true, // Placeholder
    );
  }

  // Helper method to generate the post text (similar to the old implementation)
  String get postDisplayText {
    return status == 'Lost' ? '${description}' : '${description}';
  }
}

// 1. CommunityFeed StatefulWidget
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  // 🎯 FIX 3: Use the correct list name and Item model
  bool _isLoading = true;
  bool _hasError = false;
  List<Item> _masterItems = []; // Correct list for fetched items

  // 🎯 FIX 4: Use a Map<String, List<String>> to store comments,
  // mapping an item's unique ID/index to its comments. Using index for simplicity.
  late Map<int, List<String>> _commentData;

  @override
  void initState() {
    super.initState();
    _commentData = {};
    _fetchItemsFromSupabase(); // 🌟 Start data fetching
  }

  // Helper to simulate time ago logic
  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  // 🌟 NEW: Fetch data from Supabase (Provided in the prompt, kept for completeness)
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

      final List<Map<String, dynamic>> combinedData = [
        ...lostItemsWithStatus,
        ...foundItemsWithStatus,
      ];

      final List<Item> items = combinedData
          .map((row) => Item.fromSupabase(row))
          .toList();

      // 🎯 FIX 5: Sort the items by dateLost (most recent first)
      items.sort((a, b) => b.dateLost.compareTo(a.dateLost));

      setState(() {
        _masterItems = items;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // 🎯 FIX 6: Update feature handlers to use the correct list and Item model
  void _toggleLike(int index) {
    setState(() {
      final post = _masterItems[index];
      if (post.isLiked) {
        post.likes--;
      } else {
        post.likes++;
      }
      post.isLiked = !post.isLiked;
    });
  }

  // 🎯 FIX 7: Update share logic to use Item properties
  void _sharePost(Item post) {
    final String shareText =
        '${post.status} Item: ${post.itemName} - Found/Lost at/Near: ${post.location}. Contact ${post.userName} on our app.';
    Share.share(shareText, subject: '${post.status} Item in Community Feed');
  }

  // 🎯 FIX 8: Update comment sheet to use Item properties
  void _showCommentSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CommentSheetContent(
          // Pass the Item object
          postData: _masterItems[index],
          currentComments: _commentData[index] ?? [],
          onCommentSubmitted: (comment) {
            _addCommentToPost(index, comment);
          },
        );
      },
    );
  }

  void _addCommentToPost(int index, String comment) {
    setState(() {
      _masterItems[index].comments++;
      _commentData.update(
        index,
        (comments) => [...comments, comment],
        ifAbsent: () => [comment],
      );
    });

    _saveCommentToFile(postId: index.toString(), commentText: comment);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Comment submitted! (Saved locally/simulated)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveCommentToFile({
    required String postId,
    required String commentText,
  }) {
    print('--- Database Write Simulation ---');
    print('Saving to comments.json: Post ID $postId, Comment: "$commentText"');
    print('New Comments for Post $postId: ${_commentData[int.parse(postId)]}');
    print('---------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 100,
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              const Text(
                'Community Feed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),

      // 🎯 FIX 9: Use _masterItems instead of the non-existent _feedPosts
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load feed data 😔'),
                  ElevatedButton(
                    onPressed: _fetchItemsFromSupabase,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            )
          : _masterItems.isEmpty
          ? const Center(child: Text('No lost or found items posted yet.'))
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    ..._masterItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      Item post = entry.value; // Use Item model

                      return Column(
                        children: [
                          // 🎯 FIX 10: Use _FeedPostCard with the correct Item model
                          _FeedPostCard(
                            item: post,
                            timeAgo: _timeAgo(post.dateLost),
                            onLikeTapped: () => _toggleLike(index),
                            onCommentTapped: () => _showCommentSheet(index),
                            onShareTapped: () => _sharePost(post),
                          ),
                          Divider(
                            height: 1,
                            thickness: 8,
                            color: theme.dividerColor.withOpacity(0.1),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
                  ]),
                ),
              ],
            ),
    );
  }
}

// --- Enhanced Feed Post Card Widget (Theme Adapted) ---
// 🎯 FIX 11: Update _FeedPostCard to use the Item model
class _FeedPostCard extends StatelessWidget {
  final Item item; // Use Item model
  final String timeAgo;
  final VoidCallback onLikeTapped;
  final VoidCallback onCommentTapped;
  final VoidCallback onShareTapped;

  const _FeedPostCard({
    required this.item,
    required this.timeAgo,
    required this.onLikeTapped,
    required this.onCommentTapped,
    required this.onShareTapped,
  });

  // Helper to extract the item name for description screen/details
  String _itemNameFromPostText(String text) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final match = regex.firstMatch(text);
    return match?.group(1)?.trim() ?? 'Item';
  }

  void _openItemDescription(BuildContext context) {
    // Pass the actual item name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(itemName: item.itemName),
      ),
    );
  }

  // Helper to get the correct image widget (NetworkImage or Placeholder)
  Widget _getItemImage(BuildContext context) {
    final theme = Theme.of(context);
    if (item.imageUrl.isNotEmpty &&
        Uri.tryParse(item.imageUrl)?.isAbsolute == true) {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return PlaceholderImage(
            color: theme.colorScheme.error,
            icon: Icons.broken_image,
          );
        },
      );
    } else {
      return PlaceholderImage(
        color: item.status == 'Lost' ? Colors.orange : Colors.green,
        icon: item.status == 'Lost' ? Icons.search_off : Icons.check_circle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLost = item.status == 'Lost';
    final Color foundColor = theme.primaryColor;
    final Color lostColor = theme.colorScheme.secondary;
    final Color statusColor = isLost ? lostColor : foundColor;
    final Color initialsColor = foundColor;
    final Color bodyTextColor = theme.textTheme.bodyMedium!.color!;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      color: theme.cardColor,
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
                  backgroundColor: initialsColor,
                  child: Text(
                    item.userInitials, // Use item initials
                    style: TextStyle(color: theme.colorScheme.onPrimary),
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
                            item.userName, // Use item user name
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyTextColor,
                            ),
                          ),
                          if (item.isVerified) // Use item isVerified
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.check_circle,
                                color: foundColor,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        timeAgo, // Use calculated time ago
                        style: TextStyle(color: bodyTextColor.withOpacity(0.6)),
                      ),
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
                    item.status, // Use item status
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post Image/Content
          GestureDetector(
            onTap: () => _openItemDescription(context),
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: ClipRRect(
                child: _getItemImage(
                  context,
                ), // 🎯 FIX 12: Use Image network or placeholder
              ),
            ),
          ),

          // Post Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.status}: ${item.itemName}', // Use item name
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                // Display the full post text which includes the description
                Text(
                  item.postDisplayText.replaceAll(
                    '**',
                    '',
                  ), // Use item post display text
                  style: TextStyle(fontSize: 14, color: bodyTextColor),
                ),
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
                    Icon(Icons.location_on, color: bodyTextColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      item.location, // Use item location
                      style: TextStyle(color: bodyTextColor.withOpacity(0.8)),
                    ),
                  ],
                ),
                Divider(color: theme.dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- 1. Likes (Heart Toggle) ---
                    GestureDetector(
                      onTap: onLikeTapped,
                      child: Row(
                        children: [
                          Icon(
                            item.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: item.isLiked ? Colors.red : bodyTextColor,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.likes}', // Use item likes
                            style: TextStyle(
                              fontSize: 16,
                              color: bodyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- 2. Comments (Opens Modal) ---
                    GestureDetector(
                      onTap: onCommentTapped,
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: bodyTextColor,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.comments}', // Use item comments
                            style: TextStyle(
                              fontSize: 16,
                              color: bodyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- 3. Share (Opens Native Dialog) ---
                    GestureDetector(
                      onTap: onShareTapped,
                      child: Icon(
                        Icons.share_outlined,
                        color: bodyTextColor,
                        size: 24,
                      ),
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

// --- Widget for Comment Modal Content (Theme Adapted) ---
// 🎯 FIX 13: Update _CommentSheetContent to use Item model
class _CommentSheetContent extends StatelessWidget {
  final Item postData; // Use Item model
  final List<String> currentComments;
  final Function(String) onCommentSubmitted;

  const _CommentSheetContent({
    required this.postData,
    required this.currentComments,
    required this.onCommentSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color textColor = theme.textTheme.bodyMedium!.color!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header (Grabber and Title)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Comments (${currentComments.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Comment List (Scrollable)
          Expanded(
            child: ListView.builder(
              itemCount: currentComments.length,
              itemBuilder: (context, index) {
                final String commentText = currentComments[index];
                final String userName = index.isEven
                    ? 'Guest User'
                    : 'Community Member';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.primaryColor.withOpacity(0.5),
                        child: Text(
                          userName[0],
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              commentText,
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Comment Input Field (Bottom)
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _CommentInputBar(
              onCommentSubmitted: (comment) {
                onCommentSubmitted(comment);
                // Important: Close the bottom sheet after submitting the comment.
                // This is already present in the original code, but kept here for clarity.
                // Navigator.pop(context); // This logic is in the caller's submit
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Separated Input Bar Widget (Theme Adapted) ---
class _CommentInputBar extends StatefulWidget {
  final Function(String) onCommentSubmitted;

  const _CommentInputBar({required this.onCommentSubmitted});

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentValid = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_validateComment);
  }

  @override
  void dispose() {
    _commentController.removeListener(_validateComment);
    _commentController.dispose();
    super.dispose();
  }

  void _validateComment() {
    setState(() {
      _isCommentValid = _commentController.text.trim().isNotEmpty;
    });
  }

  void _submitComment() {
    if (_isCommentValid) {
      widget.onCommentSubmitted(_commentController.text.trim());
      _commentController.clear();
      _validateComment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : lightBlueBackground,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Write your comment...',
          fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.send,
              color: _isCommentValid ? theme.primaryColor : Colors.grey,
            ),
            onPressed: _isCommentValid ? _submitComment : null,
          ),
        ),
      ),
    );
  }
}

// The PlaceholderImage class remains the same
class PlaceholderImage extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PlaceholderImage({required this.color, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.3),
      child: Center(child: Icon(icon, size: 60, color: color)),
    );
  }
}
