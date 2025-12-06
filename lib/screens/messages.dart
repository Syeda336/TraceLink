import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracelink/theme_provider.dart';
import '../firebase_service.dart';

// Import the screens
import 'bottom_navigation.dart';
import 'chat.dart';

// --- Define the Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5);
const Color darkBlue = Color(0xFF1977D2);
const Color lightBlueBackground = Color(0xFFE3F2FD);

// --- Define Dark Theme Colors ---
const Color darkBackgroundColor = Color(0xFF121212);
const Color darkSurfaceColor = Color(0xFF1E1E1E);
const Color darkPrimaryColor = Color(0xFF90CAF9);
const Color darkTextColor = Colors.white;
const Color darkHintColor = Color(0xFFB0B0B0);

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Function to search users
  void _onSearchChanged(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await FirebaseService.searchUsers(value.trim());

    // Remove the current user from results (can't chat with yourself)
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      results.removeWhere((user) => user['uid'] == currentUserId);
    }

    if (mounted) {
      setState(() {
        _searchResults = results;
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  void _openChat(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatPartnerName: userData['fullName'] ?? 'Unknown',
          chatPartnerInitials: _getInitials(userData['fullName'] ?? 'U'),
          isOnline: false,
          avatarColor: Colors.blueAccent,
          receiverId: userData['uid'],
        ),
      ),
    );
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final appbarColor = isDarkMode ? darkSurfaceColor : primaryBlue;
    final iconTextColor = isDarkMode ? darkTextColor : Colors.white;
    final backgroundColor = isDarkMode ? darkBackgroundColor : Colors.white;
    final searchBoxColor = isDarkMode ? darkSurfaceColor : lightBlueBackground;
    final searchIconColor = isDarkMode ? darkPrimaryColor : darkBlue;
    final inputTextColor = isDarkMode ? darkTextColor : darkBlue;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconTextColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavScreen()),
            );
          },
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: iconTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: searchBoxColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by Name...',
                  hintStyle: TextStyle(color: darkHintColor),
                  prefixIcon: Icon(Icons.search, color: searchIconColor),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: Icon(Icons.close, color: searchIconColor),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(color: inputTextColor),
              ),
            ),
          ),

          // --- Body Content (Switches between Search Results and Chat List) ---
          Expanded(
            child: _isSearching
                ? _buildSearchResults(isDarkMode)
                : _buildConversationsList(isDarkMode),
          ),
        ],
      ),
    );
  }

  // Widget to display search results
  Widget _buildSearchResults(bool isDarkMode) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          "No users found",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final name = user['fullName'] ?? 'Unknown';
        final initials = _getInitials(name);
        final department = user['department'] ?? 'No Department';
        final studentId = user['studentId'] ?? '';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isDarkMode ? darkPrimaryColor : primaryBlue,
            child: Text(initials, style: const TextStyle(color: Colors.white)),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "$department • $studentId", // Display extra info to distinguish users
            style: TextStyle(
              color: isDarkMode ? darkHintColor : Colors.grey[600],
            ),
          ),
          onTap: () => _openChat(user),
        );
      },
    );
  }

  // Widget to display existing conversations (Same as previous code)
  Widget _buildConversationsList(bool isDarkMode) {
    final inputTextColor = isDarkMode ? darkTextColor : darkBlue;
    final hintColor = isDarkMode ? darkHintColor : Colors.grey;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getConversations(),
      //********Testinggg*********** */
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //return Center(child: Text("Error loading chats", style: TextStyle(color: inputTextColor)));
          // MODIFIED: Print the actual error so you can see the link
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SelectableText(
                // Use SelectableText so you can copy the link
                "Error: ${snapshot.error}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 50, color: hintColor),
                const SizedBox(height: 10),
                Text(
                  "No messages yet.\nSearch above to start chatting!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: inputTextColor),
                ),
              ],
            ),
          );
        }

        final currentUserId = FirebaseAuth.instance.currentUser?.uid;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (ctx, i) => Divider(
            height: 1,
            color: isDarkMode ? darkSurfaceColor : lightBlueBackground,
          ),
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            // Determine the "Other" user
            final Map<String, dynamic> names = data['participantNames'] ?? {};
            final Map<String, dynamic> initials =
                data['participantInitials'] ?? {};

            String otherUserId = '';
            String otherUserName = 'Unknown';
            String otherUserInitials = 'U';

            names.forEach((key, value) {
              if (key != currentUserId) {
                otherUserId = key;
                otherUserName = value;
              }
            });

            if (initials.containsKey(otherUserId)) {
              otherUserInitials = initials[otherUserId];
            }

            // Format Time
            String timeAgo = '';
            if (data['lastMessageTimestamp'] != null) {
              final ts = data['lastMessageTimestamp'] as Timestamp;
              final dt = ts.toDate();
              final now = DateTime.now();
              final diff = now.difference(dt);

              if (diff.inDays > 0) {
                timeAgo = '${diff.inDays}d ago';
              } else if (diff.inHours > 0) {
                timeAgo = '${diff.inHours}h ago';
              } else {
                timeAgo = '${diff.inMinutes}m ago';
              }
            }

            return StreamBuilder<int>(
              stream: FirebaseService.getUnreadCountStream(doc.id),
              builder: (context, unreadSnapshot) {
                return _ConversationListItem(
                  userInitials: otherUserInitials,
                  userName: otherUserName,
                  lastMessage: data['lastMessage'] ?? '',
                  timeAgo: timeAgo,
                  unreadCount: unreadSnapshot.data ?? 0,
                  isOnline: false,
                  receiverId: otherUserId,
                );
              },
            );
          },
        );
      },
    );
  }
}

// _ConversationListItem remains exactly the same as provided previously
class _ConversationListItem extends StatelessWidget {
  final String userInitials;
  final String userName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;
  final String? receiverId;

  const _ConversationListItem({
    required this.userInitials,
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
    this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final avatarBg = isDarkMode ? darkSurfaceColor : lightBlueBackground;
    final initialsColor = isDarkMode ? darkPrimaryColor : darkBlue;
    final userNameColor = isDarkMode ? darkTextColor : darkBlue;
    final messageColor = isDarkMode ? darkHintColor : darkBlue.withOpacity(0.7);
    final timeColor = isDarkMode
        ? darkHintColor.withOpacity(0.6)
        : darkBlue.withOpacity(0.6);
    final unreadColor = isDarkMode ? darkPrimaryColor : primaryBlue;

    return InkWell(
      onTap: () {
        if (receiverId == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: userName,
              chatPartnerInitials: userInitials,
              isOnline: isOnline,
              avatarColor: avatarBg,
              receiverId: receiverId,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: avatarBg,
                  child: Text(
                    userInitials,
                    style: TextStyle(
                      color: initialsColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: userNameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(color: messageColor, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeAgo, style: TextStyle(color: timeColor, fontSize: 12)),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: unreadColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
