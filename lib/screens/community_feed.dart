// community_feed.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tracelink/firebase_service.dart';

// MOCK SERVICES (ASSUMED TO EXIST)
import '../supabase_lost_service.dart';
import '../supabase_found_service.dart';
import '../supabase_comments_service.dart';

// Assuming these files exist in your project structure
import 'bottom_navigation.dart';
import 'item_description.dart';

// --- Define the NEW Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// --- 1. Item Model Definition (No changes needed here) ---
class Item {
  // Column names from your Supabase table
  final String userInitials;
  final String userName; // Maps to 'Reporter Name'
  final String userEmail; // Reporter's email
  final String userId; // 'User ID' (Student ID)
  final String itemName; // Matches 'Item Name'
  final String category;
  final String color;
  final String description;
  final String location;
  final DateTime dateLost;
  final String imageUrl;
  final String status; // 'Lost' or 'Found'

  // Variables for local state management (likes/comments)
  int likes;
  int comments;
  bool isLiked;
  final bool isVerified;

  Item({
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
    this.comments = 0,
    this.isLiked = false,
    this.isVerified = true,
  });

  // Factory constructor to create an Item from a Supabase row (Map)
  factory Item.fromSupabase(Map<String, dynamic> data) {
    final fetchedUserName = data['User Name'] as String? ?? 'Community User';
    final fetchedUserId =
        data['id']?.toString() ?? data['User ID'] as String? ?? 'N/A';
    final fetchedUserEmail = data['User Email'] as String? ?? 'N/A';

    // Generate initials
    final initials = fetchedUserName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join('');

    return Item(
      userInitials: initials.isEmpty ? 'CU' : initials,
      userName: fetchedUserName,
      userEmail: fetchedUserEmail,
      userId: fetchedUserId,
      itemName: data['Item Name'] as String? ?? 'N/A',
      category: data['Category'] as String? ?? 'N/A',
      color: data['Color'] as String? ?? 'N/A',
      description: data['Description'] as String? ?? 'N/A',
      location: data['Location'] as String? ?? 'N/A',
      dateLost:
          DateTime.tryParse(data['Date Lost'] as String? ?? '') ??
          DateTime.tryParse(data['Date Found'] as String? ?? '') ??
          DateTime.now(),
      imageUrl: data['Image'] as String? ?? '',
      status: data['status'] as String? ?? 'Unknown',
      likes: (data['likes'] as int?) ?? 0,
      comments: (data['comments'] as int?) ?? 0,
      isLiked: (data['isLiked'] as bool?) ?? false,
      isVerified: fetchedUserId != 'N/A',
    );
  }

  String get postDisplayText {
    return description;
  }
}

// --- 2. CommunityFeed StatefulWidget ---
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  // 🎯 FIX 1: Renamed to hold current, logged-in user data for commenting
  Map<String, dynamic>? _currentCommenterData;

  bool _isLoading = true;
  bool _hasError = false;
  List<Item> _masterItems = [];

  // 🎯 FIX 2: Map for simulating comments locally. Key is post index.
  // Value is a list of formatted comments (e.g., "UserName: Comment Text")
  late Map<int, List<String>> _commentData;

  @override
  void initState() {
    super.initState();
    _commentData = {};
    // 🎯 FIX 3: Combine user data and feed data fetching
    _loadInitialData();
  }

  // 🎯 FIX 4: Redundant lifecycle methods removed.

  // 🌟 NEW/CORRECTED: Single function to load both user and item data
  Future<void> _loadInitialData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // --- 1. Load Current User Data from Firebase ---
      final userDataFuture = FirebaseService.getUserData();

      // --- 2. Load Feed Items from Supabase ---
      final lostItemsFuture = SupabaseLostService.fetchLostItems();
      final foundItemsFuture = SupabaseFoundService.fetchFoundItems();

      // Wait for all data simultaneously
      final results = await Future.wait([
        userDataFuture,
        lostItemsFuture,
        foundItemsFuture,
      ]);

      final Map<String, dynamic>? userData =
          results[0] as Map<String, dynamic>?;
      final List<Map<String, dynamic>> lostData =
          results[1] as List<Map<String, dynamic>>;
      final List<Map<String, dynamic>> foundData =
          results[2] as List<Map<String, dynamic>>;

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

      if (!mounted) return;
      setState(() {
        _currentCommenterData = userData; // Store fetched user data
        _masterItems = items;
        _isLoading = false;
      });

      // ignore: avoid_print
      print('✅ Current User Data Loaded: $_currentCommenterData');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load initial data: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
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
          // 🎯 FIX 5: Pass the current commenter's data
          currentCommenterData: _currentCommenterData,
          onCommentSubmitted: (comment) {
            _addCommentToPost(index, comment);
          },
        );
      },
    );
  }

  // 🎯 IMPORTANT FIX: Use CURRENT USER data for saving the comment
  Future<void> _addCommentToPost(int index, String comment) async {
    final Item post = _masterItems[index];

    // --- Get CURRENT Commenter Details from Firebase Data ---
    final String commenterUserId =
        _currentCommenterData?['studentId'] as String? ?? 'Anonymous';
    final String commenterUserName =
        _currentCommenterData?['fullName'] as String? ?? 'Anonymous User';
    final String commenterUserEmail =
        _currentCommenterData?['email'] as String? ?? 'anonymous@example.com';
    // --------------------------------------------------------

    // 1. Optimistically update the local UI first
    setState(() {
      post.comments++;
      // Locally display the comment with the actual commenter's name
      // This is crucial for 🎯 FIX 7 in _CommentSheetContent
      final displayComment = '$commenterUserName: $comment';
      _commentData.update(
        index,
        (comments) => [...comments, displayComment],
        ifAbsent: () => [displayComment],
      );
    });

    try {
      // 2. Call the Supabase service to save the comment
      await SupabaseCommentsService.saveComment(
        userId: commenterUserId, // <-- CORRECT: Use CURRENT USER ID
        userName: commenterUserName, // <-- CORRECT: Use CURRENT USER NAME
        userEmail: commenterUserEmail, // <-- CORRECT: Use CURRENT USER EMAIL
        itemName: post.itemName,
        commentText: comment,
      );

      if (mounted) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Comment submitted to database!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to save comment to Supabase: $e');
      if (mounted) {
        // 3. Rollback the optimistic update if saving fails
        setState(() {
          post.comments--;
          _commentData[index]?.removeLast();
        });

        // Show failure snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '❌ Failed to submit comment. Please try again.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
                    onPressed: _loadInitialData, // Call the combined loader
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            )
          : _masterItems.isEmpty
          ? const Center(child: Text('No lost or found items posted yet.'))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    ..._masterItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      Item post = entry.value;

                      return Column(
                        children: [
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

// --- 3. Enhanced Feed Post Card Widget (No functional changes) ---
class _FeedPostCard extends StatelessWidget {
  final Item item;
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(itemName: item.itemName),
      ),
    );
  }

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
                    item.userInitials,
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
                            item.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyTextColor,
                            ),
                          ),
                          if (item.isVerified)
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
                        timeAgo,
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
                    item.status,
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
              child: ClipRRect(child: _getItemImage(context)),
            ),
          ),

          // Post Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.status}: ${item.itemName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.postDisplayText.replaceAll('**', ''),
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
                      item.location,
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
                            '${item.likes}',
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
                            '${item.comments}',
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

// --- 4. Widget for Comment Modal Content ---
class _CommentSheetContent extends StatelessWidget {
  final Item postData;
  final List<String> currentComments;
  final Function(String) onCommentSubmitted;
  // 🎯 FIX 6: Accept current commenter data
  final Map<String, dynamic>? currentCommenterData;

  const _CommentSheetContent({
    required this.postData,
    required this.currentComments,
    required this.onCommentSubmitted,
    this.currentCommenterData, // Required for input bar avatar
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color textColor = theme.textTheme.bodyMedium!.color!;

    // Helper function to get initials from the Firebase user data
    String getCommenterInitials() {
      final String fullName =
          currentCommenterData?['fullName'] as String? ?? 'A';
      final initials = fullName
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .join('');
      return initials.isEmpty ? 'A' : initials;
    }

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
                final String fullComment = currentComments[index];

                // 🎯 FIX 7: Parse the locally stored comment for display (Format: "UserName: Comment")
                final parts = fullComment.split(': ');
                final String userName = parts.length > 1
                    ? parts.first
                    : 'Anonymous';
                final String commentText = parts.length > 1
                    ? parts.sublist(1).join(': ')
                    : fullComment;
                // Generate initials for the comment avatar based on the name in the stored comment
                final String initials =
                    userName.isEmpty || userName == 'Anonymous'
                    ? '?'
                    : userName
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .join('')
                          .substring(0, 1) // Take only the first letter
                          .toUpperCase();

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
              // 🎯 FIX 8: Pass the commenter initials to the input bar
              userInitials: getCommenterInitials(),
              onCommentSubmitted: (comment) {
                onCommentSubmitted(comment);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. Separated Input Bar Widget ---
class _CommentInputBar extends StatefulWidget {
  final Function(String) onCommentSubmitted;
  // 🎯 FIX 9: Accept user initials
  final String userInitials;

  const _CommentInputBar({
    required this.onCommentSubmitted,
    required this.userInitials,
  });

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
      // Use widget.onCommentSubmitted
      widget.onCommentSubmitted(_commentController.text.trim());
      _commentController.clear();
      _validateComment(); // This sets _isCommentValid back to false
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
      child: Row(
        children: [
          // 🎯 FIX 10: Display user initials avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.primaryColor.withOpacity(0.5),
            child: Text(
              widget.userInitials,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}

// --- 6. Placeholder Image Widget (No changes) ---
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
