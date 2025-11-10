import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart'; // Import provider to access the theme
import '../theme_provider.dart'; // Import your dynamic theme provider

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

// --- Helper class for Post Data (No change) ---
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
  bool isLiked;

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
    this.isLiked = false,
  });
}

// 1. CommunityFeed StatefulWidget
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  int _selectedIndex = 2;

  // --- Bottom Navigation Colors ---
  // These will now be used for the selected item color.
  final List<Color> _navItemColors = const [
    Colors.green,
    Colors.pink,
    primaryBlue, // Changed to primaryBlue for consistency
    Color(0xFF00008B),
    Colors.purple,
  ];

  late List<FeedPostData> _feedPosts;
  late Map<int, List<String>> _commentData;

  @override
  void initState() {
    super.initState();
    // ... [InitState remains the same] ...
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

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    Widget screenToNavigate;

    switch (index) {
      case 0:
        screenToNavigate = const HomeScreen();
        break;
      case 1:
        screenToNavigate = const SearchLost();
        break;
      case 2:
        screenToNavigate = const CommunityFeed();
        return;
      case 3:
        screenToNavigate = const MessagesListScreen();
        break;
      case 4:
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

  // Helper function to get the icon color (Uses the theme's default unselected color)
  Color _getIconColor(int index, ThemeData theme) {
    return _selectedIndex == index
        ? _navItemColors[index]
        : theme.unselectedWidgetColor;
  }

  // ... [Feature handlers remain the same] ...
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

  void _sharePost(FeedPostData post) {
    final String shareText =
        '${post.status} Item: ${post.postText} - Found at/Near: ${post.location}. Contact ${post.userName} on our app.';
    Share.share(shareText, subject: '${post.status} Item in Community Feed');
  }

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

  void _addCommentToPost(int index, String comment) {
    setState(() {
      _feedPosts[index].comments++;
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
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access the provider

    return Scaffold(
      // Use theme's background color
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Use theme for AppBar
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 100,
        backgroundColor: theme.primaryColor, // Use primary color from theme
        foregroundColor: theme
            .colorScheme
            .onPrimary, // Text/Icon color on primary background
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
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              const Text(
                'Community Feed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Color inherited from AppBar's foregroundColor
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),

      // ... [SliverList content remains the same, but the inner widgets use theme] ...
      body: CustomScrollView(
        slivers: [
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
                    Divider(
                      height: 1,
                      thickness: 8,
                      // Use a color that contrasts with the background
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

      // 3. BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _getIconColor(0, theme)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery, color: _getIconColor(1, theme)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2_outlined,
              color: _getIconColor(2, theme),
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: _getIconColor(3, theme),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: _getIconColor(4, theme)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        // Use custom color for selected item, or theme's primary color
        selectedItemColor: _navItemColors[_selectedIndex],
        unselectedItemColor: theme.unselectedWidgetColor,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        // Use theme's BottomNavigationBar background color
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        elevation: 10,
      ),
    );
  }
}

// --- Enhanced Feed Post Card Widget (Theme Adapted) ---
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
    final theme = Theme.of(context);
    final isLost = postData.status == 'Lost';
    // Use theme's primary/secondary for status/key colors
    final Color foundColor = theme.primaryColor;
    final Color lostColor = theme.colorScheme.secondary;
    final Color statusColor = isLost ? lostColor : foundColor;
    final Color initialsColor = foundColor;
    final Color bodyTextColor = theme.textTheme.bodyMedium!.color!;
    final String itemName = _itemNameFromPostText(postData.postText);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      // Use theme's card color (usually matches scaffold background)
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
                    postData.userInitials,
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
                            postData.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyTextColor, // Use theme text color
                            ),
                          ),
                          if (postData.isVerified)
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
                        postData.timeAgo,
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
                    postData.status,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  postData.postText,
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
                      postData.location,
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
                            postData.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: postData.isLiked
                                ? Colors.red
                                : bodyTextColor,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${postData.likes}',
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
                            '${postData.comments}',
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

// --- NEW Widget for Comment Modal Content (Theme Adapted) ---
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color textColor = theme.textTheme.bodyMedium!.color!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Use theme background color
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
                  'Comments (${postData.comments})',
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
            child: _CommentInputBar(onCommentSubmitted: onCommentSubmitted),
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
        // Use a slight variation of background or a divider for separation
        color: isDarkMode ? Colors.grey[850] : lightBlueBackground,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        style: theme.textTheme.bodyMedium, // Use theme text style
        decoration: InputDecoration(
          hintText: 'Write your comment...',
          // White background for text field in light mode, lighter grey in dark mode
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
