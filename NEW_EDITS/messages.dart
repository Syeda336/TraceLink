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

  // Helper function to get initials from name(updated)
  static String _getInitials(String name) {
    // 1. Trim to remove start/end spaces immediately
    String cleanedName = name.trim();
    
    if (cleanedName.isEmpty) return "U";

    // 2. Split by space and FILTER out empty parts
    // This handles "Faseeha " -> ['Faseeha'] instead of ['Faseeha', '']
    List<String> names = cleanedName.split(' ').where((part) => part.isNotEmpty).toList();

    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, 1).toUpperCase();
    }
    
    return 'UU';
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
            receiverId: userData['uid'], // Pass the UID to start chat
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
            child: _isSearching ? _buildSearchResults(isDarkMode) : _buildConversationsList(isDarkMode),
          ),
        ],
      ),
    );
  }

  // Widget to display search results
  Widget _buildSearchResults(bool isDarkMode) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text("No users found", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
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
          title: Text(name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          subtitle: Text(
            "$department • $studentId", // Display extra info to distinguish users
            style: TextStyle(color: isDarkMode ? darkHintColor : Colors.grey[600]),
          ),
          onTap: () => _openChat(user),
        );
      },
    );
  }

  // Widget to display existing conversations (Same as previous code)
  Widget _buildConversationsList(bool isDarkMode) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final inputTextColor = isDarkMode ? darkTextColor : darkBlue;
    final hintColor = isDarkMode ? darkHintColor : Colors.grey;

    // 1. OUTER STREAM: Listen to Current User to get PINNED chats
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .snapshots(),
      builder: (context, userSnapshot) {
        
        // Get list of pinned IDs safely
        List<dynamic> pinnedIds = [];
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
          pinnedIds = userData?['pinnedChats'] ?? [];
        }

        // 2. INNER STREAM: Your existing chat conversation stream
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseService.getConversations(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
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
                    Text("No messages yet.", style: TextStyle(color: inputTextColor)),
                  ],
                ),
              );
            }

            // 3. PROCESS DATA: Extract "Other User" info so we can sort
            // 3. PROCESS DATA
            
            // --- NEW: Filter out hidden chats ---
            final visibleDocs = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final hiddenFor = List<String>.from(data['hiddenFor'] ?? []);
              // Only keep chat if my ID is NOT in the hidden list
              return !hiddenFor.contains(currentUserId);
            }).toList();
            // ------------------------------------

            var processedDocs = visibleDocs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final names = data['participantNames'] as Map<String, dynamic>? ?? {};
              final initialsMap = data['participantInitials'] as Map<String, dynamic>? ?? {};

              // ... rest of your existing logic ...
              // (Find other user, calculate timeAgo, etc.)
              
              String otherId = '';
              String otherName = 'Unknown';
              names.forEach((key, value) {
                if (key != currentUserId) {
                  otherId = key;
                  otherName = value;
                }
              });

              String otherInitials = initialsMap[otherId] ?? 'U';
              
              String timeAgo = '';
              if (data['lastMessageTimestamp'] != null) {
                Timestamp t = data['lastMessageTimestamp'];
                DateTime dt = t.toDate();
                Duration diff = DateTime.now().difference(dt);
                if (diff.inDays > 0) timeAgo = '${diff.inDays}d';
                else if (diff.inHours > 0) timeAgo = '${diff.inHours}h';
                else timeAgo = '${diff.inMinutes}m';
              }

              return {
                'doc': doc,
                'data': data,
                'otherId': otherId,
                'otherName': otherName,
                'otherInitials': otherInitials,
                'timeAgo': timeAgo,
                'isPinned': pinnedIds.contains(otherId),
              };
            }).toList();
            // 4. SORT: Pinned items first
            processedDocs.sort((a, b) {
              bool aPinned = a['isPinned'] as bool;
              bool bPinned = b['isPinned'] as bool;
              if (aPinned && !bPinned) return -1;
              if (!aPinned && bPinned) return 1;
              return 0; // Keep original order otherwise (usually by time)
            });

            // 5. BUILD THE LIST
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: processedDocs.length,
              separatorBuilder: (ctx, i) => Divider(
                height: 1, 
                color: isDarkMode ? darkSurfaceColor : lightBlueBackground
              ),
              itemBuilder: (context, index) {
                final item = processedDocs[index];
                final otherId = item['otherId'] as String;
                final otherName = item['otherName'] as String;
                final otherInitials = item['otherInitials'] as String;
                final timeAgo = item['timeAgo'] as String;
                final isPinned = item['isPinned'] as bool;
                final lastMessage = (item['data'] as Map)['lastMessage'] ?? '';
                final docId = (item['doc'] as DocumentSnapshot).id;

                // We stream unread count individually like before
                return StreamBuilder<int>(
                  stream: FirebaseService.getUnreadCountStream(docId),
                  builder: (context, unreadSnapshot) {
                    int unread = unreadSnapshot.data ?? 0;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      // Highlight pinned chats
                      tileColor: isPinned 
                          ? (isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.05)) 
                          : null,

                      // CLICKABLE AVATAR logic
                     
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: primaryBlue,
                                    child: Text(otherInitials, style: const TextStyle(fontSize: 30, color: Colors.white)),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    otherName,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                  // --- NEW: Fetch 'studentId' here too ---
                                  FutureBuilder<Map<String, dynamic>?>(
                                    future: FirebaseService.getUserDataById(otherId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                        );
                                      }
                                      
                                      final studentId = snapshot.data?['studentId'] ?? 'N/A';
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SelectableText(
                                          "ID: $studentId",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                  // ---------------------------------------
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
                              ],
                            ),
                          );
                        },


                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: primaryBlue,
                              child: Text(otherInitials, style: const TextStyle(color: Colors.white)),
                            ),
                            if (isPinned)
                              const Positioned(
                                bottom: 0, right: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.push_pin, size: 12, color: primaryBlue),
                                ),
                              )
                          ],
                        ),
                      ),

                      title: Text(
                        otherName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          if (unread > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                unread.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to Chat Screen
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                          chatPartnerName: otherName,
                          chatPartnerInitials: otherInitials,
                          isOnline: false,
                          avatarColor: primaryBlue,
                          receiverId: otherId, // Needed for pinning inside chat
                        )));
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}