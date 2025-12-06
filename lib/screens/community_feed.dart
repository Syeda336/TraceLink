// community_feed.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // Import for json decoding/encoding

import '../theme_provider.dart';
import '../supabase_lost_service.dart';
import '../supabase_found_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Assuming these files exist in your project structure
import 'bottom_navigation.dart';
import 'item_description.dart';

import 'package:tracelink/firebase_service.dart';

// Ensure Supabase is initialized in main.dart
final supabase = Supabase.instance.client;

// --- Define the NEW Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// --- Helper for Supabase Comments Structure ---
// Represents a single comment for easy JSON/Map handling
class SupabaseComment {
  final String commenterName;
  final String text;
  final DateTime timestamp;

  SupabaseComment({
    required this.commenterName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'commenter_name': commenterName,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SupabaseComment.fromJson(Map<String, dynamic> json) =>
      SupabaseComment(
        commenterName: json['commenter_name'] as String? ?? 'Unknown User',
        text: json['text'] as String? ?? '',
        timestamp:
            DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
      );
}

class Item {
  // 🌟 NEW: Unique identifier for the Supabase row
  final int id;
  // Column names from your Supabase table
  final String userInitials;
  final String userName; // 🌟 Maps to 'Reporter Name'
  final String userEmail; // 🌟 NEW: To potentially store the reporter's email
  final String userId; // 🌟 NEW: To store the 'User ID' (Student ID)
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
  // 🎯 CHANGE: Comments are now fetched as a list of SupabaseComment objects
  List<SupabaseComment> commentsList;
  bool isLiked;

  // Added a placeholder for verification
  final bool isVerified;

  Item({
    required this.id, // Added
    required this.userInitials,
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.itemName,
    required this.category,
    required this.color,
    required this.description,
    required this.location,
    required this.dateLost,
    required this.imageUrl,
    required this.status,
    this.likes = 0,
    required this.commentsList, // Changed to List<SupabaseComment>
    this.isLiked = false,
    this.isVerified = true,
  });

  // 🌟 Factory constructor to create an Item from a Supabase row (Map)
  factory Item.fromSupabase(Map<String, dynamic> data) {
    // --- 🎯 FIX: Extract REAL User Data from Supabase Columns ---
    final fetchedUserName = data['User Name'] as String? ?? 'Community User';
    final fetchedUserId = data['User ID'] as String? ?? 'N/A';
    final fetchedUserEmail = data['User Email'] as String? ?? 'N/A';

    final initials = fetchedUserName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join('');
    // -------------------------------------------------------------

    // Safely parse the 'Comments' JSON array column
    final rawComments = data['Comments'] as List<dynamic>?;
    final List<SupabaseComment> parsedComments = (rawComments ?? [])
        .map((commentMap) {
          if (commentMap is String) {
            // Handle case where comments might be stored as a list of JSON strings
            try {
              return SupabaseComment.fromJson(jsonDecode(commentMap));
            } catch (_) {
              return null;
            }
          }
          if (commentMap is Map<String, dynamic>) {
            return SupabaseComment.fromJson(commentMap);
          }
          return null;
        })
        .whereType<SupabaseComment>()
        .toList();

    return Item(
      id: data['id'] as int, // 🌟 IMPORTANT: Extract the Supabase Row ID
      userInitials: initials.isEmpty ? 'CU' : initials, // Use initials
      userName: fetchedUserName, // Use Reporter Name
      userEmail: fetchedUserEmail, // Use Reporter Email
      userId: fetchedUserId, // Use User ID (Student ID)
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
      commentsList: parsedComments, // Use parsed list
      isLiked: (data['isLiked'] as bool?) ?? false,
      isVerified:
          fetchedUserId !=
          'N/A', // Set verified if we successfully fetched a User ID
    );
  }

  // Helper method to generate the post text (similar to the old implementation)
  String get postDisplayText {
    // Simple description for the feed
    return description;
  }
}

// 1. CommunityFeed StatefulWidget
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  Map<String, dynamic>? userData;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load real data when screen starts
    _fetchItemsFromSupabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userData == null && !isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    // Assuming FirebaseService.getUserData() fetches the required data (full name, student ID, email)
    Map<String, dynamic>? data = await FirebaseService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  bool _isLoading = true;
  bool _hasError = false;
  List<Item> _masterItems = []; // Correct list for fetched items

  // 🎯 REMOVED: Local comment data map is no longer needed, comments are in Item model
  // late Map<int, List<String>> _commentData;

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

  // 🌟 Fetch data from Supabase
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

      // Sort the items by dateLost (most recent first)
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

  // 🎯 FIX: Update feature handlers to use the correct list and Item model
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

  void _sharePost(Item post) {
    final String shareText =
        '${post.status} Item: ${post.itemName} - Found/Lost at/Near: ${post.location}. Contact ${post.userName} on our app.';
    Share.share(shareText, subject: '${post.status} Item in Community Feed');
  }

  // 🎯 FIX: Update comment sheet to use Item properties and fetched comments
  void _showCommentSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CommentSheetContent(
          // Pass the Item object
          postData: _masterItems[index],
          // Pass the list of SupabaseComment objects
          currentComments: _masterItems[index].commentsList,
          // Pass the comment submission handler
          onCommentSubmitted: (commentText) {
            _addCommentToPost(index, commentText);
          },
        );
      },
    );
  }

  // 🌟 NEW: Logic to add and save a comment to Supabase
  void _addCommentToPost(int index, String commentText) async {
    final Item item = _masterItems[index];

    // 1. Create the new comment object
    final String commenterName =
        userData?['fullName'] ?? 'Guest User'; // 🌟 Use Firebase User Name

    // 1. Create the new comment object
    final newComment = SupabaseComment(
      commenterName: commenterName,
      text: commentText,
      timestamp: DateTime.now(),
    );

    // 2. Add the new comment locally
    setState(() {
      item.commentsList.add(newComment);
      item.commentsList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });

    try {
      // 3. Prepare the updated comments list for Supabase (JSON array of objects)
      final List<Map<String, dynamic>> updatedCommentsJson = item.commentsList
          .map((comment) => comment.toJson())
          .toList();

      // 4. Save the updated comments array to Supabase
      if (item.status == 'Lost') {
        await SupabaseLostService.updateComments(
          itemId: item.id,
          comments: updatedCommentsJson,
        );
      } else if (item.status == 'Found') {
        await SupabaseFoundService.updateComments(
          itemId: item.id,
          comments: updatedCommentsJson,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Comment submitted and saved to database!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to save comment to Supabase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to save comment! Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
      // Revert local changes on failure
      setState(() {
        item.commentsList.remove(newComment);
      });
    }
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
                    MaterialPageRoute(
                      builder: (context) => const BottomNavScreen(),
                    ),
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
                          // Use _FeedPostCard with the correct Item model
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

  void _openItemDescription(BuildContext context) {
    // Pass the actual item name
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailScreen(id: item.id)),
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
    // Use the default color for lost items (secondary in the original, often orange/red)
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
                            item.userName, // Use item user name (Reporter Name)
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
                ), // Use Image network or placeholder
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
                  'ID: ${item.id}', // Display the Item ID
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
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
                          Icon(Icons.chat_bubble_outline, color: bodyTextColor),
                          const SizedBox(width: 4),
                          Text(
                            // 🎯 FIX: Use the actual comment count
                            '${item.commentsList.length}',
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
class _CommentSheetContent extends StatelessWidget {
  final Item postData; // Use Item model
  // 🎯 CHANGE: Expecting List<SupabaseComment>
  final List<SupabaseComment> currentComments;
  final Function(String) onCommentSubmitted;

  const _CommentSheetContent({
    required this.postData,
    required this.currentComments,
    required this.onCommentSubmitted,
  });

  // Helper to simulate time ago logic for comments
  String _timeAgoComment(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins ago';
    } else {
      return 'Just now';
    }
  }

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
            child: currentComments.isEmpty
                ? Center(
                    child: Text(
                      'Be the first to comment!',
                      style: TextStyle(color: textColor.withOpacity(0.6)),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentComments.length,
                    itemBuilder: (context, index) {
                      // 🎯 FIX: Use SupabaseComment model
                      final SupabaseComment comment = currentComments[index];
                      final String userName = comment.commenterName;
                      final String initials = userName.isNotEmpty
                          ? userName
                                .split(' ')
                                .map((e) => e.isNotEmpty ? e[0] : '')
                                .join('')
                          : 'U';

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
                              backgroundColor: theme.primaryColor.withOpacity(
                                0.5,
                              ),
                              child: Text(
                                initials,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        _timeAgoComment(comment.timestamp),
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.6),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    comment.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                    ),
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
                // We keep the sheet open after submitting for a better flow
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
