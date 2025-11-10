import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // 1. Import for sharing

// Assuming these files exist in your project structure
import 'home.dart';
import 'profile_page.dart';
import 'search_lost.dart';
import 'messages.dart';
import 'item_description.dart';

// --- Define the NEW Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue
const Color darkBlue = Color(0xFF1977D2); // Dark Blue
const Color lightBlueBackground = Color(0xFFE3F2FD); // Very Light Blue

// --- Helper class for Post Data (Improves data management) ---
class FeedPostData {
  final String userInitials;
  final String userName;
  final String timeAgo;
  final String status;
  final bool isVerified;
  final String postText;
  final String location;
  final Widget imageWidget;
  int likes;
  int comments;
  bool isLiked; // New state field

  FeedPostData({
    required this.userInitials,
    required this.userName,
    required this.timeAgo,
    required this.status,
    required this.isVerified,
    required this.postText,
    required this.location,
    required this.imageWidget,
    required this.likes,
    required this.comments,
    this.isLiked = false, // Default to not liked
  });
}

// 1. Convert StatelessWidget to StatefulWidget
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  int _selectedIndex = 2; // Set to 2 (Feed) since this is the Feed screen

  // --- Bottom Navigation Colors ---
  final List<Color> _navItemColors = const [
    Colors.green, // Home (Index 0)
    Colors.pink, // Browse (Index 1)
    Colors.orange, // Feed (Index 2)
    Color(0xFF00008B), // Dark Blue for Chat (Index 3)
    Colors.purple, // Profile (Index 4)
  ];

  // --- List of Feed Posts (Now using the FeedPostData class) ---
  late List<FeedPostData> _feedPosts;

  // --- IN-MEMORY Comment Storage (Simulates comments.json) ---
  // Key: Post Index (int)
  // Value: List of comment strings
  late Map<int, List<String>> _commentData;

  @override
  void initState() {
    super.initState();
    // Initialize post data in initState
    _feedPosts = [
      FeedPostData(
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
        imageWidget: Image.asset('lib/images/key.jfif', fit: BoxFit.cover),
      ),
      FeedPostData(
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
      FeedPostData(
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
        imageWidget: Image.asset('lib/images/card.jfif', fit: BoxFit.cover),
      ),
      FeedPostData(
        userInitials: 'JD',
        userName: 'John Doe',
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
    ];

    // Initialize in-memory comment data
    _commentData = {
      0: [
        'Great find Sarah! I hope the owner sees this.',
        'Did you turn them in to Lost & Found?',
        'I think those belong to Mark in Chemistry.',
      ],
      1: [
        'Sorry to hear that, Mike. I\'ll keep an eye out.',
        'Check the lost and found office.',
        'Was this near the lecture hall or the labs?',
        'I saw a similar one near the library yesterday.',
        'Did you put up a flyer?',
      ],
      2: [
        'Thanks for finding it! Always helpful.',
        'What name is on the card?',
        'If it\'s mine, please wait, I\'m on my way!',
        'This is why I love this community.',
        'I know someone who lost a card, maybe it\'s hers.',
        'Can you show the back?',
        'DM sent.',
      ],
      3: [
        'A good deed a day!',
        'Hope the owner is found soon.',
        'Was it full of money?',
        'I\'ll share this post.',
        'I lost a black wallet 3 weeks ago, is it leather?',
        'Contacting you now.',
        'Can you verify the contents?',
        'Great job!',
        'Is there a photo ID?',
        'I\'ll check the security cameras.',
        'Good luck finding the owner!',
      ],
    };
  }

  // 2. Correctly define _onItemTapped using setState
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Avoid navigating to the same screen

    setState(() {
      _selectedIndex = index;
    });

    Widget screenToNavigate;

    switch (index) {
      case 0: // Home
        screenToNavigate = const HomeScreen();
        break;
      case 1: // Browse
        screenToNavigate = const SearchLost();
        break;
      case 2: // Feed
        screenToNavigate =
            const CommunityFeed(); // This will trigger a replace but is safe
        return;
      case 3: // Chat
        screenToNavigate = const MessagesListScreen();
        break;
      case 4: // Profile
        screenToNavigate = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screenToNavigate),
    );
  }

  // Helper function to get the icon color
  Color _getIconColor(int index) {
    return _selectedIndex == index ? _navItemColors[index] : Colors.grey;
  }

  // --- New Feature Handlers ---

  // 1. Like Toggle Handler
  void _toggleLike(int index) {
    setState(() {
      final post = _feedPosts[index];
      if (post.isLiked) {
        post.likes--;
      } else {
        post.likes++;
      }
      post.isLiked = !post.isLiked;
    });
  }

  // 2. Share Handler (Logically correct, relies on mobile environment for dialog)
  void _sharePost(FeedPostData post) {
    final String shareText =
        '${post.status} Item: ${post.postText} - Found at/Near: ${post.location}. Contact ${post.userName} on our app.';

    // Uses the share_plus plugin to open the native share dialog
    // NOTE: This relies on the 'share_plus' package being correctly configured
    // and running on a supported platform (mobile/desktop).
    Share.share(shareText, subject: '${post.status} Item in Community Feed');
  }

  // 3. Comment Handler (Opens Modal Sheet)
  void _showCommentSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CommentSheetContent(
          postData: _feedPosts[index],
          currentComments: _commentData[index] ?? [],
          onCommentSubmitted: (comment) {
            _addCommentToPost(index, comment);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Simulation of adding and saving a comment
  void _addCommentToPost(int index, String comment) {
    setState(() {
      // 1. Update the post's comment count
      _feedPosts[index].comments++;

      // 2. Save the comment to in-memory storage (simulating file/DB save)
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

  // ⚠️ Function Stub for File Saving (Now simulates saving to in-memory store)
  void _saveCommentToFile({
    required String postId,
    required String commentText,
  }) {
    // This simulates the file/database write to 'lib/databases/comments.json'
    print('--- Database Write Simulation ---');
    print('Saving to comments.json: Post ID $postId, Comment: "$commentText"');
    print('New Comments for Post $postId: ${_commentData[int.parse(postId)]}');
    print('---------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- Fixed Header (Community Feed) ---
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 100,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  // Back Arrow Button (Top Left Corner Button)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Feed Content ---
          SliverList(
            delegate: SliverChildListDelegate([
              ..._feedPosts.asMap().entries.map((entry) {
                int index = entry.key;
                FeedPostData post = entry.value;

                return Column(
                  children: [
                    _FeedPostCard(
                      postData: post,
                      onLikeTapped: () => _toggleLike(index),
                      onCommentTapped: () => _showCommentSheet(index),
                      onShareTapped: () => _sharePost(post),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 8,
                      color: lightBlueBackground,
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
      // 3. BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, color: _getIconColor(2)),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, color: _getIconColor(3)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}

// --- Enhanced Feed Post Card Widget (Uses FeedPostData and Callbacks) ---
class _FeedPostCard extends StatelessWidget {
  final FeedPostData postData;
  final VoidCallback onLikeTapped;
  final VoidCallback onCommentTapped;
  final VoidCallback onShareTapped;

  const _FeedPostCard({
    required this.postData,
    required this.onLikeTapped,
    required this.onCommentTapped,
    required this.onShareTapped,
  });

  String _itemNameFromPostText(String text) {
    if (text.startsWith('Found these keys')) return 'Set of Keys';
    if (text.startsWith('Lost my blue')) return 'Blue Backpack';
    if (text.startsWith('Found a student ID')) return 'Student ID';
    if (text.startsWith('Found a black wallet')) return 'Black Wallet';
    return 'Item';
  }

  void _openItemDescription(BuildContext context) {
    final itemName = _itemNameFromPostText(postData.postText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(itemName: itemName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLost = postData.status == 'Lost';
    final Color statusColor = isLost ? darkBlue : primaryBlue;
    const Color initialsColor = primaryBlue;
    final String itemName = _itemNameFromPostText(postData.postText);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      color: Colors.white,
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
                    postData.userInitials,
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
                            postData.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          if (postData.isVerified)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.check_circle,
                                color: primaryBlue,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        postData.timeAgo,
                        style: TextStyle(color: darkBlue.withOpacity(0.6)),
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
                    postData.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Post Image/Content (Now a GestureDetector for navigation)
          GestureDetector(
            onTap: () => _openItemDescription(context),
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: ClipRRect(child: postData.imageWidget),
            ),
          ),

          // Post Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${postData.status}: $itemName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  postData.postText,
                  style: const TextStyle(fontSize: 14, color: darkBlue),
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
                    const Icon(Icons.location_on, color: darkBlue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      postData.location,
                      style: TextStyle(color: darkBlue.withOpacity(0.8)),
                    ),
                  ],
                ),
                const Divider(color: lightBlueBackground),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- 1. Likes (Heart Toggle) ---
                    GestureDetector(
                      onTap: onLikeTapped,
                      child: Row(
                        children: [
                          Icon(
                            postData.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: postData.isLiked
                                ? Colors.red
                                : darkBlue, // Toggle color
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${postData.likes}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: darkBlue,
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
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: darkBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${postData.comments}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- 3. Share (Opens Native Dialog) ---
                    GestureDetector(
                      onTap: onShareTapped,
                      child: const Icon(
                        Icons.share_outlined,
                        color: darkBlue,
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

// --- NEW Widget for Comment Modal Content (Displays comments + input) ---
class _CommentSheetContent extends StatelessWidget {
  final FeedPostData postData;
  final List<String> currentComments;
  final Function(String) onCommentSubmitted;

  const _CommentSheetContent({
    required this.postData,
    required this.currentComments,
    required this.onCommentSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Comments (${postData.comments})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
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
                // Simple comment structure for simulation
                final String commentText = currentComments[index];
                // Simulate different users for variety
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
                        backgroundColor: primaryBlue.withOpacity(0.5),
                        child: Text(
                          userName[0], // First letter
                          style: const TextStyle(
                            color: Colors.white,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              commentText,
                              style: const TextStyle(fontSize: 14),
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
            child: _CommentInputBar(onCommentSubmitted: onCommentSubmitted),
          ),
        ],
      ),
    );
  }
}

// --- Separated Input Bar Widget ---
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
      // Re-validate after clearing
      _validateComment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: lightBlueBackground,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Write your comment...',
          fillColor: Colors.white,
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
              color: _isCommentValid ? primaryBlue : Colors.grey,
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
